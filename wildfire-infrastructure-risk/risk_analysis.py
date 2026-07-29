"""Compute wildfire exposure metrics and a risk score per infrastructure asset.

For every asset (airport, port) and every radius (default 5/10/25 km),
this script measures how often and how intensely fires have been detected
nearby, then assigns a transparent low/medium/high operational-risk score.

Per asset it computes:
  - detections_<r>km        number of fire detections within r km
  - high_conf_<r>km         detections with high confidence within r km
  - total_frp_<r>km         summed fire radiative power (MW) within r km
  - max_frp_<r>km           strongest single detection (MW) within r km
  - nearest_km              distance to the closest detection in the period
  - days_exposed_10km       distinct days with at least one detection <= 10 km
  - max_consecutive_days_10km   longest streak of consecutive exposure days
  - last_exposure_10km      most recent exposure date

Risk score (v1, deliberately simple and explainable):
  score = 0.5 * percentile(days_exposed_10km)
        + 0.35 * percentile(total_frp_10km)
        + 0.15 * proximity_factor(nearest_km)   # 1.0 / 0.6 / 0.3 / 0.0
  high >= 0.70, medium >= 0.40, low otherwise.

Usage:
    python risk_analysis.py
    python risk_analysis.py --high-confidence-only --radii 5,10
"""

from __future__ import annotations

import argparse
import glob
import sys
from pathlib import Path

import numpy as np
import pandas as pd

EARTH_RADIUS_KM = 6371.0


def haversine_km(lat1: float, lon1: float, lat2: np.ndarray, lon2: np.ndarray) -> np.ndarray:
    """Distance in km from one point to arrays of points."""
    p1, p2 = np.radians(lat1), np.radians(lat2)
    dphi = np.radians(lat2 - lat1)
    dlambda = np.radians(lon2 - lon1)
    a = np.sin(dphi / 2) ** 2 + np.cos(p1) * np.cos(p2) * np.sin(dlambda / 2) ** 2
    return 2 * EARTH_RADIUS_KM * np.arcsin(np.sqrt(a))


def max_consecutive_days(dates: pd.Series) -> int:
    if dates.empty:
        return 0
    days = pd.to_datetime(dates.unique())
    days = pd.Series(sorted(days))
    gaps = days.diff().dt.days.fillna(1)
    streaks = (gaps != 1).cumsum()
    return int(streaks.value_counts().max())


def load_fires(fires_dir: str, high_confidence_only: bool, include_all_types: bool) -> pd.DataFrame:
    files = sorted(glob.glob(str(Path(fires_dir) / "*.csv.gz")))
    if not files:
        raise SystemExit(f"No fire files found in {fires_dir}. Run download_fires.py first.")
    df = pd.concat((pd.read_csv(f) for f in files), ignore_index=True)
    df["acq_date"] = pd.to_datetime(df["acq_date"])
    total = len(df)
    if "type" in df.columns and not include_all_types:
        # type 0 = presumed vegetation fire; 1 = volcano; 2 = other static
        # land source (industrial heat: refineries, steelworks); 3 = offshore.
        df = df[df["type"] == 0]
        print(f"Kept {len(df):,}/{total:,} detections after vegetation-fire filter (type=0)")
    if high_confidence_only:
        df = df[df["confidence"].astype(str).str.lower().isin(["h", "high"])]
    print(f"Loaded {len(df):,} detections from {len(files)} file(s), "
          f"{df['acq_date'].min():%Y-%m-%d} to {df['acq_date'].max():%Y-%m-%d}")
    return df.reset_index(drop=True)


def analyze(fires: pd.DataFrame, assets: pd.DataFrame, radii: list[int]) -> pd.DataFrame:
    fire_lat = fires["latitude"].to_numpy()
    fire_lon = fires["longitude"].to_numpy()
    conf = fires["confidence"].astype(str).str.lower().to_numpy()
    frp = fires["frp"].fillna(0).to_numpy()

    records = []
    for asset in assets.itertuples(index=False):
        dist = haversine_km(asset.latitude, asset.longitude, fire_lat, fire_lon)
        record = {
            "asset_id": asset.asset_id,
            "name": asset.name,
            "kind": asset.kind,
            "latitude": asset.latitude,
            "longitude": asset.longitude,
            "nearest_km": round(float(dist.min()), 2) if len(dist) else np.nan,
        }
        for r in radii:
            mask = dist <= r
            record[f"detections_{r}km"] = int(mask.sum())
            record[f"high_conf_{r}km"] = int((mask & (conf == "h")).sum())
            record[f"total_frp_{r}km"] = round(float(frp[mask].sum()), 1)
            record[f"max_frp_{r}km"] = round(float(frp[mask].max()), 1) if mask.any() else 0.0
        within_10 = fires.loc[dist <= 10, "acq_date"]
        record["days_exposed_10km"] = int(within_10.dt.date.nunique())
        record["max_consecutive_days_10km"] = max_consecutive_days(within_10)
        record["last_exposure_10km"] = (
            within_10.max().date().isoformat() if not within_10.empty else ""
        )
        records.append(record)

    result = pd.DataFrame(records)

    days_pct = result["days_exposed_10km"].rank(pct=True)
    frp_pct = result["total_frp_10km"].rank(pct=True)
    proximity = pd.cut(
        result["nearest_km"], bins=[-1, 5, 10, 25, np.inf], labels=[1.0, 0.6, 0.3, 0.0]
    ).astype(float)
    result["risk_score"] = (0.5 * days_pct + 0.35 * frp_pct + 0.15 * proximity).round(3)
    result["risk_level"] = pd.cut(
        result["risk_score"], bins=[-1, 0.40, 0.70, 2], labels=["low", "medium", "high"]
    )
    return result.sort_values("risk_score", ascending=False).reset_index(drop=True)


def main() -> int:
    parser = argparse.ArgumentParser(description="Wildfire exposure per infrastructure asset.")
    parser.add_argument("--fires-dir", default="data/fires")
    parser.add_argument("--assets", default="data/infrastructure/assets.csv")
    parser.add_argument("--radii", default="5,10,25", help="Comma-separated radii in km")
    parser.add_argument("--out", default="results/asset_risk.csv")
    parser.add_argument("--high-confidence-only", action="store_true")
    parser.add_argument("--include-all-types", action="store_true",
                        help="Keep static/industrial and offshore detections (types 1-3)")
    args = parser.parse_args()

    radii = [int(r) for r in args.radii.split(",")]
    fires = load_fires(args.fires_dir, args.high_confidence_only, args.include_all_types)
    assets = pd.read_csv(args.assets)
    print(f"Assets: {len(assets)} ({assets['kind'].value_counts().to_dict()})")

    result = analyze(fires, assets, radii)

    Path(args.out).parent.mkdir(parents=True, exist_ok=True)
    result.to_csv(args.out, index=False)
    print(f"\nWrote {len(result)} asset rows to {args.out}")
    print(f"Risk levels: {result['risk_level'].value_counts().to_dict()}")

    print("\nMost exposed assets:")
    cols = ["name", "kind", "risk_level", "risk_score", "days_exposed_10km",
            "max_consecutive_days_10km", "total_frp_10km", "nearest_km"]
    print(result.head(10)[cols].to_string(index=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
