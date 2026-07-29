"""Precompute daily-resolution aggregates for the static dashboard.

The dashboard lets viewers pick any from-to date range, so the data must be
daily. Raw detections are too big to ship (and CI has no raw archive), so
this script reduces the archive to three compact structures, committed as
results/history_<region>.json:

  - cells:    detections per (day, ~5 km grid cell) - drives the heatmap
  - daily:    detections and max FRP per day - drives KPIs and the trend chart
  - exposure: per asset, the days on which fire was detected within 25 km,
              with counts / FRP / min distance - drives markers and the table

Days are stored as integer offsets from EPOCH (2018-01-01).
Re-run (then commit the JSON) whenever the raw archive changes.

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

GRID = 0.05          # degrees, ~5.5 km cells - matches the 10 km exposure radius
EPOCH = pd.Timestamp("2018-01-01")


def day_index(dates: pd.Series) -> pd.Series:
    return (dates - EPOCH).dt.days


def aggregate_cells(fires: pd.DataFrame) -> dict:
    """Detections per (day, grid cell) as compact integer arrays."""
    grouped = (
        fires.assign(
            d=day_index(fires["acq_date"]),
            la=(fires["latitude"] / GRID).round().astype(int),
            lo=(fires["longitude"] / GRID).round().astype(int),
        )
        .groupby(["d", "la", "lo"])
        .size()
        .reset_index(name="n")
        .sort_values("d")
    )
    return {c: grouped[c].tolist() for c in ["d", "la", "lo", "n"]}


def daily_totals(fires: pd.DataFrame) -> dict:
    """Detections and max FRP per day."""
    grouped = (
        fires.assign(d=day_index(fires["acq_date"]))
        .groupby("d")
        .agg(n=("frp", "size"), fm=("frp", "max"))
        .reset_index()
        .sort_values("d")
    )
    return {
        "d": grouped["d"].tolist(),
        "n": grouped["n"].tolist(),
        "fm": [round(float(v), 1) for v in grouped["fm"].fillna(0)],
    }


def exposure_events(assets: pd.DataFrame, fires: pd.DataFrame) -> dict:
    """Per asset: the days with fire within 25 km, and what happened that day."""
    out = {}
    fire_lat = fires["latitude"].to_numpy()
    fire_lon = fires["longitude"].to_numpy()
    frp = fires["frp"].fillna(0).to_numpy()
    days = day_index(fires["acq_date"]).to_numpy()
    for asset in assets.itertuples(index=False):
        dist = haversine_km(asset.latitude, asset.longitude, fire_lat, fire_lon)
        near = dist <= 25
        if not near.any():
            continue
        frame = pd.DataFrame({
            "d": days[near], "dist": dist[near], "frp": frp[near],
        })
        frame["in10"] = frame["dist"] <= 10
        grouped = frame.groupby("d").agg(
            n25=("dist", "size"),
            n10=("in10", "sum"),
            f10=("frp", lambda s: 0.0),  # replaced below
            dm=("dist", "min"),
        )
        f10 = frame[frame["in10"]].groupby("d")["frp"].sum()
        grouped["f10"] = f10.reindex(grouped.index).fillna(0)
        grouped = grouped.reset_index().sort_values("d")
        out[str(asset.asset_id)] = {
            "d": grouped["d"].astype(int).tolist(),
            "n10": grouped["n10"].astype(int).tolist(),
            "n25": grouped["n25"].astype(int).tolist(),
            "f10": [round(float(v), 1) for v in grouped["f10"]],
            "dm": [round(float(v), 1) for v in grouped["dm"]],
        }
    return out


def load_archive(region: regions.Region) -> pd.DataFrame:
    files = sorted(glob.glob(f"data/fires/{region.slug}/*.csv.gz"))
    if not files:
        raise SystemExit(f"No fire archive for {region.slug}. Run download_fires.py first.")
    fires = pd.concat((pd.read_csv(f) for f in files), ignore_index=True)
    if "type" in fires.columns:
        fires = fires[fires["type"] == 0]
    fires["acq_date"] = pd.to_datetime(fires["acq_date"])
    return fires


def main() -> None:
    parser = argparse.ArgumentParser(description="Aggregate history for the dashboard.")
    parser.add_argument("--region", default="iberia",
                        help=f"{', '.join(regions.REGIONS)} or 'west,south,east,north'")
    args = parser.parse_args()
    region = regions.resolve(args.region)

    fires = load_archive(region)
    assets = pd.read_csv(f"data/infrastructure/{region.slug}/assets.csv")
    print(f"{len(fires):,} vegetation-fire detections "
          f"({fires['acq_date'].min():%Y-%m-%d} to {fires['acq_date'].max():%Y-%m-%d}), "
          f"{len(assets)} assets")

    payload = {
        "region": region.slug,
        "grid": GRID,
        "epoch": str(EPOCH.date()),
        "archive_end": str(fires["acq_date"].max().date()),
        "cells": aggregate_cells(fires),
        "daily": daily_totals(fires),
        "exposure": exposure_events(assets, fires),
    }
    out = Path(f"results/history_{region.slug}.json")
    out.parent.mkdir(parents=True, exist_ok=True)
    with open(out, "w") as f:
        json.dump(payload, f, separators=(",", ":"))
    print(f"Wrote {out} ({out.stat().st_size / 1e6:.1f} MB, "
          f"{len(payload['cells']['d']):,} cell-days, "
          f"{len(payload['exposure'])} assets with exposure days)")


if __name__ == "__main__":
    main()
