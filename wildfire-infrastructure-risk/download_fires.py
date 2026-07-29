"""Download historical VIIRS fire detections for Iberia, year by year.

The FIRMS area API returns at most 5 days per request, so each year is
fetched in 5-day chunks and written to data/fires/fires_<SOURCE>_<YEAR>.csv.gz.
Years whose output file already exists are skipped, so the download is
resumable - delete a year's file (or pass --force) to re-fetch it.

Usage:
    python download_fires.py                          # 2018-2025, VIIRS_SNPP_SP
    python download_fires.py --start 2022 --end 2022  # one year
"""

from __future__ import annotations

import argparse
import datetime as dt
import sys
import time
from pathlib import Path

import pandas as pd

import firms


def download_year(year: int, source: str, bbox: str, pause: float) -> pd.DataFrame:
    start = dt.date(year, 1, 1)
    year_end = dt.date(year, 12, 31)
    frames = []
    calls = 0
    while start <= year_end:
        days = min(5, (year_end - start).days + 1)
        chunk = firms.area_fires(source=source, bbox=bbox, days=days, date=start.isoformat())
        if not chunk.empty:
            frames.append(chunk)
        calls += 1
        if calls % 50 == 0:
            firms.wait_for_quota()
        start += dt.timedelta(days=days)
        time.sleep(pause)
    if not frames:
        return pd.DataFrame()
    df = pd.concat(frames, ignore_index=True).drop_duplicates()
    return df


def main() -> int:
    parser = argparse.ArgumentParser(description="Download historical FIRMS fire data.")
    parser.add_argument("--start", type=int, default=2018, help="First year")
    parser.add_argument("--end", type=int, default=2025, help="Last year")
    parser.add_argument("--source", default="VIIRS_SNPP_SP")
    parser.add_argument("--bbox", default=firms.IBERIA_BBOX)
    parser.add_argument("--outdir", default="data/fires")
    parser.add_argument("--pause", type=float, default=0.5, help="Seconds between API calls")
    parser.add_argument("--force", action="store_true", help="Re-download existing years")
    args = parser.parse_args()

    outdir = Path(args.outdir)
    outdir.mkdir(parents=True, exist_ok=True)

    for year in range(args.start, args.end + 1):
        out_file = outdir / f"fires_{args.source}_{year}.csv.gz"
        if out_file.exists() and not args.force:
            print(f"{year}: already downloaded ({out_file}), skipping")
            continue
        t0 = time.time()
        df = download_year(year, args.source, args.bbox, args.pause)
        df.to_csv(out_file, index=False, compression="gzip")
        print(f"{year}: {len(df):,} detections -> {out_file} ({time.time() - t0:.0f}s)")

    return 0


if __name__ == "__main__":
    sys.exit(main())
