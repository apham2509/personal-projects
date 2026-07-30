"""Precompute world-scale aggregates for the static dashboard.

The world archive is ~165M detections - far too much for the browser and for
one pandas frame - so it is processed year by year and reduced harder than a
regional dataset:

  - heat cells at 1 degree x calendar month (regional data uses 0.05 deg x day)
  - daily detection totals (drives KPIs and the trend chart, still daily)
  - per-asset exposure days for LARGE airports only, found with a
    sorted-latitude window search so 470 assets x 20M rows stays fast
  - a historical risk level per asset, using the same formula as
    risk_analysis.py, computed from the exposure days

Outputs (commit both):
  results/history_world.json
  results/asset_risk_world.csv

Usage:
    python prepare_world.py
"""

from __future__ import annotations

import glob
import json
from pathlib import Path

import numpy as np
import pandas as pd

import world_regions
from prepare_history import EPOCH, day_index
from risk_analysis import haversine_km

WORLD_GRID = 1.0
LAT_WINDOW = 0.3   # degrees; > 25 km everywhere


def assign_region(lat: np.ndarray, lon: np.ndarray) -> np.ndarray:
    """Attribute detections to regions by bounding box (first match wins)."""
    region = np.full(len(lat), "other", dtype=object)
    unassigned = np.ones(len(lat), dtype=bool)
    for key in world_regions.REGION_ORDER:
        for west, south, east, north in world_regions.REGION_DEFS[key]["bboxes"]:
            hit = unassigned & (lon >= west) & (lon <= east) & (lat >= south) & (lat <= north)
            region[hit] = key
            unassigned &= ~hit
    return region


def year_frames():
    for path in sorted(glob.glob("data/fires/world/*.csv.gz")):
        print(f"reading {path} ...")
        df = pd.read_csv(path, usecols=["latitude", "longitude", "frp", "acq_date", "type"])
        df = df[df["type"] == 0].drop(columns="type")
        df["acq_date"] = pd.to_datetime(df["acq_date"])
        yield path, df


def exposure_for_year(assets: pd.DataFrame, fires: pd.DataFrame) -> dict:
    """Per-asset exposure days using a sorted-latitude window prefilter."""
    fires = fires.sort_values("latitude")
    lat = fires["latitude"].to_numpy()
    lon = fires["longitude"].to_numpy()
    frp = fires["frp"].fillna(0).to_numpy()
    days = day_index(fires["acq_date"]).to_numpy()

    out = {}
    for asset in assets.itertuples(index=False):
        lo_i = np.searchsorted(lat, asset.latitude - LAT_WINDOW)
        hi_i = np.searchsorted(lat, asset.latitude + LAT_WINDOW)
        if hi_i <= lo_i:
            continue
        window = slice(lo_i, hi_i)
        lon_scale = max(0.2, np.cos(np.radians(asset.latitude)))
        near_lon = np.abs(lon[window] - asset.longitude) <= LAT_WINDOW / lon_scale
        if not near_lon.any():
            continue
        idx = np.arange(lo_i, hi_i)[near_lon]
        dist = haversine_km(asset.latitude, asset.longitude, lat[idx], lon[idx])
        within25 = dist <= 25
        if not within25.any():
            continue
        keep = idx[within25]
        frame = pd.DataFrame({
            "d": days[keep],
            "dist": dist[within25],
            "frp": frp[keep],
        })
        frame["in10"] = frame["dist"] <= 10
        grouped = frame.groupby("d").agg(
            n25=("dist", "size"), n10=("in10", "sum"), dm=("dist", "min"))
        f10 = frame[frame["in10"]].groupby("d")["frp"].sum()
        grouped["f10"] = f10.reindex(grouped.index).fillna(0)
        record = out.setdefault(str(asset.asset_id),
                                {"d": [], "n10": [], "n25": [], "f10": [], "dm": []})
        for day, row in grouped.sort_index().iterrows():
            record["d"].append(int(day))
            record["n10"].append(int(row["n10"]))
            record["n25"].append(int(row["n25"]))
            record["f10"].append(round(float(row["f10"]), 1))
            record["dm"].append(round(float(row["dm"]), 1))
    return out


def merge_exposure(total: dict, part: dict) -> None:
    for asset_id, events in part.items():
        record = total.setdefault(asset_id,
                                  {"d": [], "n10": [], "n25": [], "f10": [], "dm": []})
        for column, values in events.items():
            record[column].extend(values)


def baseline_from_exposure(assets: pd.DataFrame, exposure: dict) -> pd.DataFrame:
    """Same scoring recipe as risk_analysis.py, from the exposure days."""
    rows = []
    for asset in assets.itertuples(index=False):
        e = exposure.get(str(asset.asset_id))
        days10 = sum(1 for n in (e["n10"] if e else []) if n > 0)
        frp10 = sum(e["f10"]) if e else 0.0
        nearest = min(e["dm"]) if e and e["dm"] else np.nan
        rows.append({"asset_id": asset.asset_id, "name": asset.name,
                     "kind": asset.kind, "days_exposed_10km": days10,
                     "total_frp_10km": round(frp10, 1), "nearest_km": nearest})
    df = pd.DataFrame(rows)
    days_pct = df["days_exposed_10km"].rank(pct=True)
    frp_pct = df["total_frp_10km"].rank(pct=True)
    proximity = pd.cut(df["nearest_km"], bins=[-1, 5, 10, 25, np.inf],
                       labels=[1.0, 0.6, 0.3, 0.0]).astype(float).fillna(0.0)
    df["risk_score"] = (0.5 * days_pct + 0.35 * frp_pct + 0.15 * proximity).round(3)
    # Tied ranks give zero-exposure assets the tie-block's average percentile;
    # an asset with no exposure at all should score zero outright.
    df.loc[df["days_exposed_10km"].eq(0) & df["total_frp_10km"].eq(0), "risk_score"] = 0.0
    df["risk_level"] = pd.cut(df["risk_score"], bins=[-1, 0.40, 0.70, 2],
                              labels=["low", "medium", "high"])
    return df.sort_values("risk_score", ascending=False)


def main() -> None:
    assets = pd.read_csv("data/infrastructure/world/assets.csv")
    print(f"{len(assets)} world assets (large airports)")

    cell_parts, daily_parts, exposure = [], [], {}
    total = 0
    for path, fires in year_frames():
        total += len(fires)
        month_start = fires["acq_date"].dt.to_period("M").dt.start_time
        cells = (fires.assign(
            d=day_index(month_start),
            la=(fires["latitude"] / WORLD_GRID).round().astype(int),
            lo=(fires["longitude"] / WORLD_GRID).round().astype(int))
            .groupby(["d", "la", "lo"]).size().reset_index(name="n"))
        cell_parts.append(cells)
        with_region = fires.assign(
            d=day_index(fires["acq_date"]),
            r=assign_region(fires["latitude"].to_numpy(), fires["longitude"].to_numpy()),
        )
        daily = (with_region.groupby(["r", "d"])
                 .agg(n=("frp", "size"), fm=("frp", "max")).reset_index())
        daily_parts.append(daily)
        merge_exposure(exposure, exposure_for_year(assets, fires))
        print(f"  {path}: {len(fires):,} type-0 detections, "
              f"cells so far {sum(len(p) for p in cell_parts):,}")

    cells = (pd.concat(cell_parts).groupby(["d", "la", "lo"], as_index=False)["n"].sum()
             .sort_values("d"))
    per_region = (pd.concat(daily_parts).groupby(["r", "d"], as_index=False)
                  .agg(n=("n", "sum"), fm=("fm", "max")))
    daily_all = (per_region.groupby("d", as_index=False)
                 .agg(n=("n", "sum"), fm=("fm", "max")).sort_values("d"))

    def series(frame: pd.DataFrame) -> dict:
        frame = frame.sort_values("d")
        return {"d": frame["d"].tolist(), "n": frame["n"].tolist(),
                "fm": [round(float(v), 1) for v in frame["fm"].fillna(0)]}

    daily = {"all": series(daily_all)}
    for key in world_regions.REGION_ORDER:
        subset = per_region[per_region["r"] == key]
        if len(subset):
            daily[key] = series(subset)

    baseline = baseline_from_exposure(assets, exposure)
    baseline.to_csv("results/asset_risk_world.csv", index=False)
    print(f"baseline: {baseline['risk_level'].value_counts().to_dict()}")

    payload = {
        "region": "world",
        "grid": WORLD_GRID,
        "cell_period": "month",
        "epoch": str(EPOCH.date()),
        "archive_end": str(pd.Timestamp(
            EPOCH + pd.to_timedelta(int(daily_all["d"].max()), "D")).date()),
        "cells": {c: cells[c].tolist() for c in ["d", "la", "lo", "n"]},
        "daily": daily,
        "exposure": exposure,
    }
    out = Path("results/history_world.json")
    with open(out, "w") as f:
        json.dump(payload, f, separators=(",", ":"))
    print(f"{total:,} detections -> {out} ({out.stat().st_size / 1e6:.1f} MB, "
          f"{len(cells):,} cell-months, {len(exposure)} assets with exposure)")


if __name__ == "__main__":
    main()
