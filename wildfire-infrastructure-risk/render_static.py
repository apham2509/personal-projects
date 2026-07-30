"""Render the wildfire dashboard as a static, client-interactive HTML page.

One unified world dataset. Build-time work:
  - loads the committed world aggregates (results/history_world.json:
    monthly 1-degree heat cells, per-region daily totals, per-asset
    exposure days for all large airports; built by prepare_world.py)
  - folds in the Iberian ports from the detailed regional study
    (results/history_iberia.json), so the asset set is airports + ports
  - pulls world near-real-time detections from the day after the archive
    ends up to today, so the record is gapless from 2018-01-01 to now
  - writes site/: index.html and data_world.json

Viewer-side (all client-side over the shipped daily exposure events):
cascading Region -> Country -> Asset filters, a from-to date range picker
defaulting to the 30 days up to yesterday, an operational KPI row and alert
queue for the latest satellite day, rule-based current-severity tiers, an
acute-vs-chronic quadrant, explainable chronic-exposure scores with peer
percentiles, per-asset drilldown drawers (rings map, daily activity,
seasonality), incident summaries, source-gap shading and a data-quality
strip. Deploys to GitHub Pages as-is.

Usage:
    python render_static.py
    python render_static.py --out ../site/wildfire-infrastructure-risk/index.html
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
from pathlib import Path

import numpy as np
import pandas as pd

import firms
import world_regions
from prepare_history import EPOCH, aggregate_cells, day_index, exposure_events
from prepare_world import assign_region
from risk_analysis import haversine_km

WORLD_VIEW = {"center": {"lat": 15, "lon": 10}, "zoom": 1.3}

# Incident clustering: detections within the same ~5 km cell neighbourhood
# and within 3 days of each other belong to the same fire incident.
INCIDENT_GRID = 0.05
INCIDENT_TIME_LINK = 3


def detect_gaps(daily_all: dict, max_day: int) -> list:
    """Interior runs of days with no detections at all - source outages."""
    have = {d for d, n in zip(daily_all["d"], daily_all["n"]) if n > 0}
    if not have:
        return []
    gaps, start = [], None
    for d in range(min(have), max_day + 1):
        if d not in have:
            if start is None:
                start = d
        else:
            if start is not None and d - start >= 2:
                gaps.append([start, d - 1])
            start = None
    if start is not None and max_day - start >= 1:
        gaps.append([start, max_day])
    return gaps


def cluster_incidents(recent: pd.DataFrame, assets: pd.DataFrame) -> tuple:
    """Group recent near-asset detections into distinct fire incidents.

    Spatial connected components over 0.05-degree cells (8-neighbourhood),
    each split wherever consecutive activity is more than 3 days apart.
    Returns (incident list, per-asset incident stats keyed by asset uid).
    """
    if recent.empty:
        return [], {}
    fires = recent.sort_values("latitude").reset_index(drop=True)
    lat = fires["latitude"].to_numpy()
    lon = fires["longitude"].to_numpy()
    frp = fires["frp"].fillna(0).to_numpy()
    days = day_index(fires["acq_date"]).to_numpy()

    keep = np.zeros(len(fires), dtype=bool)
    asset_hits = {}
    for a in assets.itertuples(index=False):
        lo = np.searchsorted(lat, a.latitude - 0.3)
        hi = np.searchsorted(lat, a.latitude + 0.3)
        if hi <= lo:
            continue
        scale = max(0.2, np.cos(np.radians(a.latitude)))
        near = np.abs(lon[lo:hi] - a.longitude) <= 0.3 / scale
        if not near.any():
            continue
        idx = np.arange(lo, hi)[near]
        dist = haversine_km(a.latitude, a.longitude, lat[idx], lon[idx])
        within = dist <= 25
        if not within.any():
            continue
        keep[idx[within]] = True
        asset_hits[a.uid] = (idx[within], dist[within])

    cells = {}
    for i in np.where(keep)[0]:
        cells.setdefault((round(lat[i] / INCIDENT_GRID), round(lon[i] / INCIDENT_GRID)),
                         []).append(int(i))
    parent = {c: c for c in cells}

    def find(c):
        while parent[c] != c:
            parent[c] = parent[parent[c]]
            c = parent[c]
        return c

    for (cy, cx) in list(cells):
        for dy in (-1, 0, 1):
            for dx in (-1, 0, 1):
                nb = (cy + dy, cx + dx)
                if nb in cells:
                    ra, rb = find((cy, cx)), find(nb)
                    if ra != rb:
                        parent[ra] = rb
    components = {}
    for c, rows in cells.items():
        components.setdefault(find(c), []).extend(rows)

    incident_rows = []
    for rows in components.values():
        rows.sort(key=lambda i: days[i])
        current = [rows[0]]
        for i in rows[1:]:
            if days[i] - days[current[-1]] > INCIDENT_TIME_LINK:
                incident_rows.append(current)
                current = [i]
            else:
                current.append(i)
        incident_rows.append(current)

    det_incident = np.full(len(fires), -1)
    incidents = []
    for iid, rows in enumerate(incident_rows):
        r = np.array(rows)
        det_incident[r] = iid
        incidents.append({
            "id": iid, "start": int(days[r].min()), "last": int(days[r].max()),
            "n": len(rows), "peakFrp": round(float(frp[r].max()), 1),
            "lat": round(float(lat[r].mean()), 3), "lon": round(float(lon[r].mean()), 3),
            "assets": 0,
        })

    asset_incidents = {}
    incident_asset_sets = [set() for _ in incidents]
    for uid, (idx, dist) in asset_hits.items():
        per_incident = {}
        for i, d_km in zip(idx, dist):
            iid = int(det_incident[i])
            if iid < 0:
                continue
            e = per_incident.setdefault(iid, {"minDist": 1e9, "firstDay": 10**9,
                                              "firstDist": 1e9, "lastDay": -1, "lastDist": 1e9})
            day_i = int(days[i])
            e["minDist"] = min(e["minDist"], d_km)
            if day_i < e["firstDay"] or (day_i == e["firstDay"] and d_km < e["firstDist"]):
                e["firstDay"], e["firstDist"] = day_i, d_km
            if day_i > e["lastDay"] or (day_i == e["lastDay"] and d_km < e["lastDist"]):
                e["lastDay"], e["lastDist"] = day_i, d_km
        records = []
        for iid, e in per_incident.items():
            incident_asset_sets[iid].add(uid)
            trend = ("approaching" if e["lastDist"] < e["firstDist"] - 1
                     else "receding" if e["lastDist"] > e["firstDist"] + 1 else "steady")
            records.append({"id": iid, "minDist": round(float(e["minDist"]), 1),
                            "lastDist": round(float(e["lastDist"]), 1), "trend": trend})
        if records:
            asset_incidents[uid] = sorted(records, key=lambda x: x["minDist"])[:6]
    for iid, uids in enumerate(incident_asset_sets):
        incidents[iid]["assets"] = len(uids)
    return incidents, asset_incidents


def pull_recent(start: dt.date, source: str) -> pd.DataFrame:
    """Fetch world NRT detections from `start` through today in 5-day chunks."""
    frames = []
    today = dt.date.today()
    cursor = start
    while cursor <= today:
        days = min(5, (today - cursor).days + 1)
        chunk = firms.area_fires(source=source, bbox="world", days=days,
                                 date=cursor.isoformat())
        if not chunk.empty:
            frames.append(chunk)
        cursor += dt.timedelta(days=days)
    if not frames:
        return pd.DataFrame(columns=["latitude", "longitude", "frp", "acq_date"])
    fires = pd.concat(frames, ignore_index=True).drop_duplicates()
    fires["acq_date"] = pd.to_datetime(fires["acq_date"])
    return fires


def read_assets(region_slug: str) -> pd.DataFrame:
    # keep_default_na: Namibia's ISO code is the string "NA", not a missing value
    assets = pd.read_csv(f"data/infrastructure/{region_slug}/assets.csv",
                         keep_default_na=False, na_values=[])
    for col in ["latitude", "longitude"]:
        assets[col] = pd.to_numeric(assets[col])
    return assets


def read_baseline(region_slug: str) -> dict:
    path = Path(f"results/asset_risk_{region_slug}.csv")
    if not path.is_file():
        return {}
    b = pd.read_csv(path)
    return dict(zip(b["asset_id"].astype(str), b["risk_level"].astype(str)))


def build_world_data(source: str) -> dict:
    history = json.loads(Path("results/history_world.json").read_text())

    airports = read_assets("world")
    airports["uid"] = airports["asset_id"].astype(str)
    airport_baseline = read_baseline("world")

    # Fold in the ports from the detailed Iberia study: same epoch, same
    # exposure schema - only the ids need a prefix to avoid collisions.
    iberia_assets = read_assets("iberia")
    ports = iberia_assets[iberia_assets["kind"] == "port"].copy()
    ports["uid"] = "p" + ports["asset_id"].astype(str)
    iberia_history = json.loads(Path("results/history_iberia.json").read_text())
    port_baseline = read_baseline("iberia")
    for port in ports.itertuples(index=False):
        events = iberia_history["exposure"].get(str(port.asset_id))
        if events:
            history["exposure"]["p" + str(port.asset_id)] = events

    combined = pd.concat([airports, ports], ignore_index=True)

    archive_end = dt.date.fromisoformat(history["archive_end"])
    availability = firms.data_availability()
    nrt_min = dt.date.fromisoformat(
        availability.loc[availability["data_id"] == source, "min_date"].iloc[0])
    nrt_start = max(archive_end + dt.timedelta(days=1), nrt_min)
    recent = pull_recent(nrt_start, source)
    print(f"world archive to {archive_end}, NRT {nrt_start} -> today: "
          f"{len(recent):,} detections")

    if len(recent):
        cells = aggregate_cells(recent, grid=history["grid"], period=history["cell_period"])
        for column, values in cells.items():
            history["cells"][column].extend(values)

        with_region = recent.assign(
            d=day_index(recent["acq_date"]),
            r=assign_region(recent["latitude"].to_numpy(),
                            recent["longitude"].to_numpy()),
        )
        per_region = (with_region.groupby(["r", "d"])
                      .agg(n=("frp", "size"), fm=("frp", "max")).reset_index())
        daily_all = (per_region.groupby("d", as_index=False)
                     .agg(n=("n", "sum"), fm=("fm", "max")).sort_values("d"))
        extensions = {"all": daily_all}
        for key, subset in per_region.groupby("r"):
            extensions[str(key)] = subset.sort_values("d")
        for key, frame in extensions.items():
            series = history["daily"].setdefault(key, {"d": [], "n": [], "fm": []})
            series["d"].extend(int(v) for v in frame["d"])
            series["n"].extend(int(v) for v in frame["n"])
            series["fm"].extend(round(float(v), 1) for v in frame["fm"].fillna(0))

        # exposure: combined asset list against the recent world detections
        exposure_assets = combined.rename(columns={"uid": "exposure_id"})
        recent_events = exposure_events(
            exposure_assets.assign(asset_id=exposure_assets["exposure_id"]), recent)
        for uid, events in recent_events.items():
            target = history["exposure"].setdefault(
                uid, {"d": [], "n10": [], "n25": [], "f10": [], "dm": []})
            for column, values in events.items():
                target[column].extend(values)

    history["assets"] = [
        {"id": a.uid, "name": a.name, "kind": a.kind,
         "country": a.country or "", "lat": round(a.latitude, 4),
         "lon": round(a.longitude, 4),
         "baseline": (port_baseline if a.kind == "port" else airport_baseline)
                     .get(str(a.asset_id), "n/a")}
        for a in combined.itertuples(index=False)
    ]
    combined_for_incidents = combined.copy()
    incidents, asset_incidents = cluster_incidents(recent, combined_for_incidents)
    history["incidents"] = incidents
    history["assetIncidents"] = asset_incidents
    print(f"incidents: {len(incidents)} distinct (recent window), "
          f"{len(asset_incidents)} assets involved")

    yesterday = dt.date.today() - dt.timedelta(days=1)
    max_day = (yesterday - EPOCH.date()).days
    freshest = ""
    if len(recent) and "acq_datetime" in recent.columns:
        freshest = recent["acq_datetime"].max().strftime("%Y-%m-%d %H:%M UTC")
    history["meta"] = {
        "epoch": history["epoch"],
        "max_day": max_day,
        "archive_end": history["archive_end"],
        "nrt_start_day": (nrt_start - EPOCH.date()).days,
        "gaps": detect_gaps(history["daily"]["all"], max_day),
        "freshest": freshest,
        "built": dt.datetime.now(dt.timezone.utc).strftime("%Y-%m-%d %H:%M UTC"),
        "view": WORLD_VIEW,
    }
    return history


PAGE_TEMPLATE = (Path(__file__).parent / "template.html").read_text(encoding="utf-8")


def render(source: str, out: Path) -> None:
    out.parent.mkdir(parents=True, exist_ok=True)
    data = build_world_data(source)
    data_path = out.parent / "data_world.json"
    # allow_nan=False: a stray NaN must fail the build, not ship invalid JSON
    data_path.write_text(json.dumps(data, separators=(",", ":"), allow_nan=False),
                         encoding="utf-8")
    stale = out.parent / "data_iberia.json"
    if stale.exists():
        stale.unlink()

    generated = dt.datetime.now(dt.timezone.utc).strftime("%d %b %Y, %H:%M UTC")
    page = (PAGE_TEMPLATE
            .replace("__GEO__", json.dumps(world_regions.client_payload(),
                                           separators=(",", ":")))
            .replace("__GENERATED__", generated))
    out.write_text(page, encoding="utf-8")
    print(f"assets {len(data['assets'])}, cell-months {len(data['cells']['d']):,} "
          f"-> {out} + {data_path} ({data_path.stat().st_size / 1e6:.1f} MB)")


def main() -> None:
    parser = argparse.ArgumentParser(description="Render static wildfire dashboard.")
    parser.add_argument("--source", default="VIIRS_SNPP_NRT",
                        help="NRT source used to extend the archive to today")
    parser.add_argument("--out", default="site/index.html")
    args = parser.parse_args()
    render(args.source, Path(args.out))


if __name__ == "__main__":
    main()
