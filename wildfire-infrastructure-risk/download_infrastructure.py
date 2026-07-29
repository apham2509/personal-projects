"""Download infrastructure asset locations for Spain and Portugal.

Two public sources:
  - Airports: OurAirports open dataset (large + medium airports).
  - Ports: OpenStreetMap via the Overpass API (harbour / port features).

Writes a combined data/infrastructure/assets.csv with one row per asset:
asset_id, name, kind, latitude, longitude, source.

Major roads are on the roadmap (they need line geometries and a proper
geospatial buffer join - see README).
"""

from __future__ import annotations

import io
import sys
import time
from pathlib import Path

import pandas as pd
import requests

OURAIRPORTS_URL = "https://davidmegginson.github.io/ourairports-data/airports.csv"
OVERPASS_URLS = [
    "https://overpass-api.de/api/interpreter",
    "https://overpass.kumi.systems/api/interpreter",
]

# Same mainland bounding box as the fire download (west,south,east,north).
# Applied after download to drop the Canary, Madeira and Azores islands.
WEST, SOUTH, EAST, NORTH = -10.0, 35.9, 4.5, 44.0

# Query within the ES/PT country areas (not the raw bbox) so coastal
# features in France, Algeria or Morocco are excluded.
OVERPASS_QUERY = """
[out:json][timeout:180];
area["ISO3166-1"~"^(ES|PT)$"][admin_level=2]->.a;
(
  node["seamark:type"="harbour"](area.a);
  way["seamark:type"="harbour"](area.a);
  node["harbour"="yes"](area.a);
  way["harbour"="yes"](area.a);
  way["industrial"="port"](area.a);
  relation["industrial"="port"](area.a);
);
out center tags;
"""

# Leisure marinas are not logistics infrastructure.
MARINA_CATEGORIES = {"marina", "marina_no_facilities", "yacht_harbour"}


def fetch_airports() -> pd.DataFrame:
    response = requests.get(OURAIRPORTS_URL, timeout=120)
    response.raise_for_status()
    df = pd.read_csv(io.StringIO(response.text))
    df = df[
        df["iso_country"].isin(["ES", "PT"])
        & df["type"].isin(["large_airport", "medium_airport"])
        & df["latitude_deg"].between(SOUTH, NORTH)
        & df["longitude_deg"].between(WEST, EAST)
    ]
    return pd.DataFrame(
        {
            "name": df["name"],
            "kind": "airport",
            "latitude": df["latitude_deg"],
            "longitude": df["longitude_deg"],
            "source": "ourairports:" + df["ident"].astype(str),
        }
    )


def overpass(query: str, attempts_per_url: int = 2) -> dict:
    """POST a query to Overpass, falling back across mirrors with retries."""
    last_error: Exception = RuntimeError("no Overpass endpoint attempted")
    for url in OVERPASS_URLS:
        for attempt in range(attempts_per_url):
            try:
                response = requests.post(
                    url,
                    data={"data": query},
                    timeout=300,
                    # Overpass rejects the default python-requests agent
                    headers={"User-Agent": "wildfire-infrastructure-risk/1.0 (github.com/apham2509)"},
                )
                response.raise_for_status()
                return response.json()
            except (requests.RequestException, ValueError) as error:
                last_error = error
                print(f"Overpass attempt failed ({url}): {error}")
                time.sleep(10 * (attempt + 1))
    raise last_error


def fetch_ports() -> pd.DataFrame:
    rows = []
    for element in overpass(OVERPASS_QUERY).get("elements", []):
        tags = element.get("tags", {})
        name = tags.get("name") or tags.get("seamark:name")
        if not name:
            continue  # unnamed features are mostly small jetties / duplicates
        if (
            tags.get("leisure") == "marina"
            or tags.get("seamark:harbour:category") in MARINA_CATEGORIES
        ):
            continue
        lat = element.get("lat") or element.get("center", {}).get("lat")
        lon = element.get("lon") or element.get("center", {}).get("lon")
        if lat is None or lon is None:
            continue
        if not (SOUTH <= lat <= NORTH and WEST <= lon <= EAST):
            continue  # islands outside the mainland study area
        rows.append(
            {
                "name": name,
                "kind": "port",
                "latitude": lat,
                "longitude": lon,
                "source": f"osm:{element['type']}/{element['id']}",
            }
        )
    df = pd.DataFrame(rows)
    if df.empty:
        return df
    # The same harbour often appears as both a node and an area polygon.
    df = df.drop_duplicates(subset=["name"]).reset_index(drop=True)
    return df


def main() -> int:
    outdir = Path("data/infrastructure")
    outdir.mkdir(parents=True, exist_ok=True)

    airports = fetch_airports()
    print(f"Airports (large + medium, ES/PT mainland): {len(airports)}")
    ports = fetch_ports()
    print(f"Named ports/harbours from OSM: {len(ports)}")

    assets = pd.concat([airports, ports], ignore_index=True)
    assets.insert(0, "asset_id", range(1, len(assets) + 1))
    out_file = outdir / "assets.csv"
    assets.to_csv(out_file, index=False)
    print(f"Wrote {len(assets)} assets to {out_file}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
