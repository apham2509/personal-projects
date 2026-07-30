"""Download infrastructure asset locations for a study region.

Two public sources:
  - Airports: OurAirports open dataset (large + medium airports, global).
  - Ports: OpenStreetMap via the Overpass API (harbour / port features).

Writes data/infrastructure/<region>/assets.csv with one row per asset:
asset_id, name, kind, latitude, longitude, source.

Notes:
  - Regions defined with country codes (e.g. iberia = ES+PT) filter assets
    to those countries; plain bounding-box regions take everything inside.
  - For very large regions (continents, world) the Overpass port query is
    skipped - it would time out - and only airports are included.
  - Major roads are on the roadmap (they need line geometries and a proper
    geospatial buffer join - see README).

Usage:
    python download_infrastructure.py                    # iberia
    python download_infrastructure.py --region greece
"""

from __future__ import annotations

import argparse
import io
import sys
import time
from pathlib import Path

import pandas as pd
import requests

import regions

OURAIRPORTS_URL = "https://davidmegginson.github.io/ourairports-data/airports.csv"
OVERPASS_URLS = [
    "https://overpass-api.de/api/interpreter",
    "https://overpass.kumi.systems/api/interpreter",
]

# Overpass cannot answer harbour queries over continent-scale boxes.
MAX_PORT_QUERY_SQ_DEGREES = 2500

# Leisure marinas are not logistics infrastructure.
MARINA_CATEGORIES = {"marina", "marina_no_facilities", "yacht_harbour"}

PORT_FILTERS = [
    'node["seamark:type"="harbour"]',
    'way["seamark:type"="harbour"]',
    'node["harbour"="yes"]',
    'way["harbour"="yes"]',
    'way["industrial"="port"]',
    'relation["industrial"="port"]',
]


def build_port_query(region: regions.Region, country: str | None) -> str:
    """One query per country (results get tagged with it) or one bbox query."""
    west, south, east, north = region.bounds
    if country:
        # Query the country area so coastal features of neighbouring
        # countries inside the bbox are excluded.
        scope = f'area["ISO3166-1"="{country}"][admin_level=2]->.a;\n'
        suffix = "(area.a)"
    else:
        scope = ""
        suffix = f"({south},{west},{north},{east})"
    body = "\n".join(f"  {f}{suffix};" for f in PORT_FILTERS)
    return f"[out:json][timeout:180];\n{scope}(\n{body}\n);\nout center tags;\n"


def fetch_airports(region: regions.Region) -> pd.DataFrame:
    west, south, east, north = region.bounds
    response = requests.get(OURAIRPORTS_URL, timeout=120)
    response.raise_for_status()
    df = pd.read_csv(io.StringIO(response.text))
    # World scope keeps the dataset shippable by tracking large airports only.
    types = ["large_airport"] if region.slug == "world" else ["large_airport", "medium_airport"]
    df = df[
        df["type"].isin(types)
        & df["latitude_deg"].between(south, north)
        & df["longitude_deg"].between(west, east)
    ]
    if region.countries:
        df = df[df["iso_country"].isin(region.countries)]
    return pd.DataFrame(
        {
            "name": df["name"],
            "kind": "airport",
            "country": df["iso_country"],
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


def fetch_ports(region: regions.Region) -> pd.DataFrame:
    if regions.area_sq_degrees(region) > MAX_PORT_QUERY_SQ_DEGREES:
        print(f"Region '{region.slug}' is too large for an OSM port query - "
              "including airports only. Use a smaller region for ports.")
        return pd.DataFrame()
    frames = [fetch_ports_one(region, c) for c in (region.countries or [None])]
    df = pd.concat(frames, ignore_index=True)
    if df.empty:
        return df
    # The same harbour often appears as both a node and an area polygon.
    return df.drop_duplicates(subset=["name"]).reset_index(drop=True)


def fetch_ports_one(region: regions.Region, country: str | None) -> pd.DataFrame:
    west, south, east, north = region.bounds
    rows = []
    for element in overpass(build_port_query(region, country)).get("elements", []):
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
        if not (south <= lat <= north and west <= lon <= east):
            continue  # e.g. overseas islands of a matched country
        rows.append(
            {
                "name": name,
                "kind": "port",
                "country": country or "",
                "latitude": lat,
                "longitude": lon,
                "source": f"osm:{element['type']}/{element['id']}",
            }
        )
    return pd.DataFrame(
        rows, columns=["name", "kind", "country", "latitude", "longitude", "source"])


def main() -> int:
    parser = argparse.ArgumentParser(description="Download infrastructure assets.")
    parser.add_argument("--region", default="iberia",
                        help=f"{', '.join(regions.REGIONS)} or 'west,south,east,north'")
    args = parser.parse_args()
    region = regions.resolve(args.region)

    outdir = Path("data/infrastructure") / region.slug
    outdir.mkdir(parents=True, exist_ok=True)

    airports = fetch_airports(region)
    print(f"Airports (large + medium) in {region.slug}: {len(airports)}")
    ports = fetch_ports(region)
    print(f"Named ports/harbours from OSM: {len(ports)}")

    assets = pd.concat([airports, ports], ignore_index=True)
    if assets.empty:
        raise SystemExit("No assets found for this region.")
    assets.insert(0, "asset_id", range(1, len(assets) + 1))
    out_file = outdir / "assets.csv"
    assets.to_csv(out_file, index=False)
    print(f"Wrote {len(assets)} assets to {out_file}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
