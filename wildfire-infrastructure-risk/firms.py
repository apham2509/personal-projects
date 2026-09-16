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
import urllib3.util.connection

# CI runners intermittently resolve NASA's host to IPv6 without having an
# IPv6 route ([Errno 101] Network is unreachable); force IPv4.
urllib3.util.connection.HAS_IPV6 = False

API_BASE = "https://firms.modaps.eosdis.nasa.gov"


class FirmsError(RuntimeError):
    """Raised when the FIRMS API rejects a request."""


class FirmsUnavailable(FirmsError):
    """A temporary network or upstream failure, safe to retry elsewhere."""


def _get(url: str, tries: int = 3, **kwargs) -> requests.Response:
    """Retry temporary failures without exposing the MAP_KEY in exceptions."""
    if tries < 1:
        raise ValueError("tries must be at least 1")
    kwargs.setdefault("timeout", (10, 60))
    for attempt in range(tries):
        try:
            response = requests.get(url, **kwargs)
        except (requests.ConnectionError, requests.Timeout) as error:
            reason = error.__class__.__name__
        else:
            if response.status_code not in {429, 500, 502, 503, 504}:
                return response
            reason = f"HTTP {response.status_code}"
            response.close()
        if attempt == tries - 1:
            raise FirmsUnavailable(
                f"FIRMS unavailable after {tries} attempts ({reason})"
            ) from None
        wait = 5 * 2 ** attempt
        print(f"FIRMS {reason}, retrying in {wait}s...", flush=True)
        time.sleep(wait)


def _check_status(response: requests.Response) -> None:
    # requests' HTTPError includes the URL, which contains the MAP_KEY.
    if response.status_code >= 400:
        raise FirmsError(f"FIRMS rejected the request (HTTP {response.status_code})")


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
    response = _get(
        f"{API_BASE}/mapserver/mapkey_status/",
        params={"MAP_KEY": map_key()},
        timeout=(10, 30),
    )
    _check_status(response)
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
    bbox: str = "world",
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
    # Large (e.g. world-scale) responses cost many transactions, so the
    # rolling quota can empty mid-run: wait for the window to clear and retry.
    for _ in range(40):
        response = _get(f"{API_BASE}{path}", timeout=(10, 300))
        if response.status_code == 400 and "transaction limit" in response.text.lower():
            print("Transaction quota exhausted, waiting 60s...")
            time.sleep(60)
            continue
        break
    _check_status(response)
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
    response = _get(f"{API_BASE}/api/data_availability/csv/{map_key()}/ALL", timeout=(10, 60))
    _check_status(response)
    return pd.read_csv(io.StringIO(response.text))
