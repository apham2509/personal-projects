"""Precompute aggregated history for the static dashboard.

The static page cannot ship 160k+ raw detections, and CI does not have the
raw fire archive (data/fires/ is not committed). This script aggregates the
historical record into a compact JSON that IS committed
(results/history_<region>.json) and that render_static.py embeds:

  - per window (each year + "all"): a gridded heatmap (0.05 degree cells),
    monthly detection counts, KPIs, and per-asset exposure metrics.

Re-run it (then commit the JSON) whenever the raw archive changes.

Usage:
    python prepare_history.py --region iberia
"""

from __future__ import annotations

import argparse
import glob
import json
from pathlib import Path

import numpy as np
import pandas as pd

import regions
from risk_analysis import haversine_km

GRID = 0.05  # degrees, ~5.5 km cells - matches the 10 km exposure radius


def asset_metrics(assets: pd.DataFrame, fires: pd.DataFrame) -> dict:
    out = {}
    fire_lat = fires["latitude"].to_numpy()
    fire_lon = fires["longitude"].to_numpy()
    frp = fires["frp"].fillna(0).to_numpy()
    dates = fires["acq_date"].dt.date.to_numpy()
    for asset in assets.itertuples(index=False):
        dist = haversine_km(asset.latitude, asset.longitude, fire_lat, fire_lon)
        within10, within25 = dist <= 10, dist <= 25
        status = "exposed" if within10.any() else "nearby" if within25.any() else "clear"
        out[str(asset.asset_id)] = {
            "det10": int(within10.sum()),
            "frp10": round(float(frp[within10].sum()), 1),
            "days10": int(len(set(dates[within10]))),
            "nearest": round(float(dist.min()), 1) if len(dist) else None,
            "status": status,
        }
    return out


def window_payload(fires: pd.DataFrame, assets: pd.DataFrame, label: str,
                   freq: str = "M") -> dict:
    cells = (
        fires.assign(
            glat=(fires["latitude"] / GRID).round() * GRID,
            glon=(fires["longitude"] / GRID).round() * GRID,
        )
        .groupby(["glat", "glon"])
        .size()
        .reset_index(name="n")
    )
    monthly = fires.groupby(
        fires["acq_date"].dt.date if freq == "D" else fires["acq_date"].dt.to_period("M")
    ).size()
    metrics = asset_metrics(assets, fires)
    exposed = sum(1 for m in metrics.values() if m["status"] == "exposed")
    nearby = sum(1 for m in metrics.values() if m["status"] == "nearby")
    return {
        "label": label,
        "heat": {
            "lat": [round(v, 3) for v in cells["glat"]],
            "lon": [round(v, 3) for v in cells["glon"]],
            "z": cells["n"].tolist(),
        },
        "trend": {
            "x": [str(p) for p in monthly.index],
            "y": monthly.values.tolist(),
        },
        "kpis": {
            "detections": int(len(fires)),
            "exposed": exposed,
            "nearby": nearby,
            "max_frp": round(float(fires["frp"].max()), 1) if len(fires) else 0,
            "window": label,
        },
        "assets": metrics,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description="Aggregate history for the dashboard.")
    parser.add_argument("--region", default="iberia",
                        help=f"{', '.join(regions.REGIONS)} or 'west,south,east,north'")
    args = parser.parse_args()
    region = regions.resolve(args.region)

    files = sorted(glob.glob(f"data/fires/{region.slug}/*.csv.gz"))
    if not files:
        raise SystemExit(f"No fire archive for {region.slug}. Run download_fires.py first.")
    fires = pd.concat((pd.read_csv(f) for f in files), ignore_index=True)
    if "type" in fires.columns:
        fires = fires[fires["type"] == 0]
    fires["acq_date"] = pd.to_datetime(fires["acq_date"])
    assets = pd.read_csv(f"data/infrastructure/{region.slug}/assets.csv")
    print(f"{len(fires):,} vegetation-fire detections, {len(assets)} assets")

    windows = {}
    for year, group in fires.groupby(fires["acq_date"].dt.year):
        windows[str(year)] = window_payload(group, assets, str(year))
        print(f"  {year}: {len(group):,} detections")
    years = sorted(fires["acq_date"].dt.year.unique())
    windows["all"] = window_payload(fires, assets, f"All years {years[0]}-{years[-1]}")

    out = Path(f"results/history_{region.slug}.json")
    out.parent.mkdir(parents=True, exist_ok=True)
    with open(out, "w") as f:
        json.dump({"region": region.slug, "grid_degrees": GRID, "windows": windows},
                  f, separators=(",", ":"))
    print(f"Wrote {out} ({out.stat().st_size / 1e6:.1f} MB)")


if __name__ == "__main__":
    main()
