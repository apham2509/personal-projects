"""Minimal Python client for the NASA FIRMS fire-detection API.

FIRMS (Fire Information for Resource Management System) serves near-real-time
satellite fire/hotspot detections from MODIS, VIIRS, Landsat and GOES.
API docs: https://firms.modaps.eosdis.nasa.gov/api/

Requires a free MAP_KEY (https://firms.modaps.eosdis.nasa.gov/api/map_key),
read from the FIRMS_MAP_KEY environment variable or a local .env file.

Note: the API's country endpoints are currently disabled server-side, so this
client works exclusively with the area endpoint (bounding boxes or 'world').
"""

from __future__ import annotations

import io
import os
from pathlib import Path

import pandas as pd
import requests

API_BASE = "https://firms.modaps.eosdis.nasa.gov"

#: Named bounding boxes (west,south,east,north) usable instead of coordinates.
REGIONS = {
    "world": "world",
    "finland": "19.0,59.5,31.6,70.1",
    "nordics": "4.0,54.0,32.0,71.5",
    "europe": "-11.0,35.0,40.0,71.5",
    "mediterranean": "-10.0,34.0,36.0,46.0",
    "california": "-125.0,32.0,-113.0,42.5",
    "australia": "112.0,-44.0,154.0,-10.0",
    "amazon": "-74.0,-18.0,-43.0,6.0",
    "vietnam": "102.0,8.0,110.0,23.5",
    "siberia": "60.0,50.0,180.0,75.0",
}

#: Datasets accepted by the API (see data_availability() for live date ranges).
SOURCES = [
    "VIIRS_NOAA20_NRT",
    "VIIRS_NOAA21_NRT",
    "VIIRS_SNPP_NRT",
    "MODIS_NRT",
    "LANDSAT_NRT",
    "GOES_NRT",
    "VIIRS_NOAA20_SP",
    "VIIRS_SNPP_SP",
    "MODIS_SP",
]


class FirmsError(RuntimeError):
    """Raised when the FIRMS API rejects a request."""


def _load_dotenv() -> None:
    """Load a .env file next to this module or in the cwd, if present."""
    for candidate in (Path(__file__).parent / ".env", Path.cwd() / ".env"):
        if candidate.is_file():
            for line in candidate.read_text().splitlines():
                line = line.strip()
                if line and not line.startswith("#") and "=" in line:
                    key, _, value = line.partition("=")
                    os.environ.setdefault(key.strip(), value.strip())


def _map_key(map_key: str | None = None) -> str:
    if map_key:
        return map_key
    _load_dotenv()
    key = os.environ.get("FIRMS_MAP_KEY")
    if not key:
        raise FirmsError(
            "No MAP_KEY found. Get a free key at "
            "https://firms.modaps.eosdis.nasa.gov/api/map_key and set it as "
            "FIRMS_MAP_KEY (environment variable or .env file)."
        )
    return key


def _get(path: str) -> str:
    response = requests.get(f"{API_BASE}{path}", timeout=120)
    response.raise_for_status()
    text = response.text
    if text.startswith("Invalid"):
        raise FirmsError(f"FIRMS rejected the request: {text.strip()!r}")
    return text


def key_status(map_key: str | None = None) -> dict:
    """Return the current transaction usage for the MAP_KEY."""
    key = _map_key(map_key)
    response = requests.get(
        f"{API_BASE}/mapserver/mapkey_status/", params={"MAP_KEY": key}, timeout=30
    )
    response.raise_for_status()
    return response.json()


def data_availability(map_key: str | None = None) -> pd.DataFrame:
    """Return the available date range for every dataset."""
    key = _map_key(map_key)
    csv_text = _get(f"/api/data_availability/csv/{key}/ALL")
    return pd.read_csv(io.StringIO(csv_text))


def area_fires(
    region: str = "world",
    source: str = "VIIRS_NOAA20_NRT",
    days: int = 1,
    date: str | None = None,
    map_key: str | None = None,
) -> pd.DataFrame:
    """Fetch fire detections for a region.

    Args:
        region: A name from REGIONS or a bounding box "west,south,east,north".
        source: Dataset name, e.g. "VIIRS_NOAA20_NRT" (see SOURCES).
        days: Day range 1-10.
        date: Optional start date "YYYY-MM-DD" for historical queries;
            defaults to the most recent data.
        map_key: Override the FIRMS_MAP_KEY environment variable.

    Returns:
        DataFrame with one row per detection (latitude, longitude, frp,
        confidence, ...) plus a combined "acq_datetime" column (UTC).
    """
    if not 1 <= days <= 10:
        raise ValueError("days must be between 1 and 10")
    key = _map_key(map_key)
    area = REGIONS.get(region.lower(), region)
    path = f"/api/area/csv/{key}/{source}/{area}/{days}"
    if date:
        path += f"/{date}"
    csv_text = _get(path)
    df = pd.read_csv(io.StringIO(csv_text))
    if not df.empty and {"acq_date", "acq_time"} <= set(df.columns):
        df["acq_datetime"] = pd.to_datetime(
            df["acq_date"] + " " + df["acq_time"].astype(str).str.zfill(4),
            format="%Y-%m-%d %H%M",
            utc=True,
        )
    return df
