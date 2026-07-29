"""NASA FIRMS API client for the Wildfire Infrastructure Risk Monitor.

Reads the MAP_KEY from (in order):
  1. the FIRMS_MAP_KEY environment variable
  2. a map_key.txt file next to this module (gitignored - never commit it)

Get a free key at https://firms.modaps.eosdis.nasa.gov/api/map_key.
Rate limit: 5,000 transactions per 10 minutes.
"""

from __future__ import annotations

import io
import os
import time
from pathlib import Path

import pandas as pd
import requests

API_BASE = "https://firms.modaps.eosdis.nasa.gov"

# Mainland Spain + Portugal (west,south,east,north). Excludes the Canary,
# Madeira and Azores islands so fire and infrastructure extents match.
IBERIA_BBOX = "-10.0,35.9,4.5,44.0"


class FirmsError(RuntimeError):
    """Raised when the FIRMS API rejects a request."""


def map_key() -> str:
    key = os.environ.get("FIRMS_MAP_KEY", "").strip()
    if key:
        return key
    key_file = Path(__file__).parent / "map_key.txt"
    if key_file.is_file():
        key = key_file.read_text().strip()
        if key:
            return key
    raise FirmsError(
        "No MAP_KEY found. Put it in map_key.txt next to firms.py "
        "(or set FIRMS_MAP_KEY). Get a free key at "
        "https://firms.modaps.eosdis.nasa.gov/api/map_key"
    )


def key_status() -> dict:
    """Current transaction usage for the MAP_KEY."""
    response = requests.get(
        f"{API_BASE}/mapserver/mapkey_status/",
        params={"MAP_KEY": map_key()},
        timeout=30,
    )
    response.raise_for_status()
    return response.json()


def wait_for_quota(threshold: int = 4500, poll_seconds: int = 60) -> None:
    """Block until transaction usage is below the threshold."""
    while True:
        used = key_status().get("current_transactions", 0)
        if used < threshold:
            return
        print(f"Quota high ({used} transactions), waiting {poll_seconds}s...")
        time.sleep(poll_seconds)


def area_fires(
    source: str,
    bbox: str = IBERIA_BBOX,
    days: int = 5,
    date: str | None = None,
) -> pd.DataFrame:
    """Fetch fire detections for a bounding box.

    Args:
        source: Dataset, e.g. "VIIRS_SNPP_SP" (archive) or "VIIRS_SNPP_NRT".
        bbox: "west,south,east,north" in decimal degrees.
        days: Range length in days (1-5, the API maximum).
        date: Range START date "YYYY-MM-DD"; the API returns detections for
            [date, date + days - 1]. Omit for the most recent data.

    Returns:
        One row per detection, with an added UTC "acq_datetime" column.
    """
    if not 1 <= days <= 5:
        raise ValueError("days must be between 1 and 5 (API maximum)")
    path = f"/api/area/csv/{map_key()}/{source}/{bbox}/{days}"
    if date:
        path += f"/{date}"
    response = requests.get(f"{API_BASE}{path}", timeout=300)
    response.raise_for_status()
    text = response.text
    if text.startswith("Invalid"):
        raise FirmsError(f"FIRMS rejected the request: {text.strip()!r}")
    df = pd.read_csv(io.StringIO(text))
    if not df.empty and {"acq_date", "acq_time"} <= set(df.columns):
        df["acq_datetime"] = pd.to_datetime(
            df["acq_date"] + " " + df["acq_time"].astype(str).str.zfill(4),
            format="%Y-%m-%d %H%M",
            utc=True,
        )
    return df


def data_availability() -> pd.DataFrame:
    """Available date range per dataset."""
    response = requests.get(
        f"{API_BASE}/api/data_availability/csv/{map_key()}/ALL", timeout=60
    )
    response.raise_for_status()
    return pd.read_csv(io.StringIO(response.text))
