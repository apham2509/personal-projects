"""Render the wildfire dashboard as a static, client-interactive HTML page.

Build-time work, per region:
  - loads the committed daily aggregates (results/history_<region>.json,
    2018 -> archive end, built by prepare_history.py)
  - pulls near-real-time detections from the day after the archive ends up
    to today, so the daily record is gapless from 2018-01-01 to now
  - writes site/: index.html (page + logic) and data_<region>.json

Viewer-side, everything is client-interactive: region and country dropdowns,
a from-to date range picker (default: the 30 days up to yesterday), hoverable
definitions, a heatmap with colorbar, KPI tiles, trend chart and a sortable
exposure table. Deploys to GitHub Pages as-is.

Usage:
    python render_static.py                        # iberia -> site/
    python render_static.py --regions iberia,world --out ../site/wildfire-infrastructure-risk/index.html
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
from pathlib import Path

import pandas as pd

import firms
import regions
from prepare_history import EPOCH, aggregate_cells, daily_totals, exposure_events

REGION_LABELS = {
    "iberia": "Iberia (Spain & Portugal)",
    "world": "All regions (world)",
}
REGION_VIEWS = {"world": ({"lat": 15, "lon": 10}, 1.3)}
WORLD_PLACEHOLDER_NOTE = "world archive downloading - available soon"


def pull_recent(region: regions.Region, start: dt.date, source: str) -> pd.DataFrame:
    """Fetch NRT detections from `start` through today in 5-day chunks."""
    frames = []
    today = dt.date.today()
    cursor = start
    while cursor <= today:
        days = min(5, (today - cursor).days + 1)
        chunk = firms.area_fires(source=source, bbox=region.bbox, days=days,
                                 date=cursor.isoformat())
        if not chunk.empty:
            frames.append(chunk)
        cursor += dt.timedelta(days=days)
    if not frames:
        return pd.DataFrame(columns=["latitude", "longitude", "frp", "acq_date"])
    fires = pd.concat(frames, ignore_index=True).drop_duplicates()
    fires["acq_date"] = pd.to_datetime(fires["acq_date"])
    return fires


def merged_data(region: regions.Region, source: str) -> dict:
    history = json.loads(Path(f"results/history_{region.slug}.json").read_text())
    assets = pd.read_csv(f"data/infrastructure/{region.slug}/assets.csv")
    if "country" not in assets.columns:
        assets["country"] = ""

    archive_end = dt.date.fromisoformat(history["archive_end"])
    availability = firms.data_availability()
    nrt_min = dt.date.fromisoformat(
        availability.loc[availability["data_id"] == source, "min_date"].iloc[0])
    nrt_start = max(archive_end + dt.timedelta(days=1), nrt_min)
    recent = pull_recent(region, nrt_start, source)
    print(f"{region.slug}: archive to {archive_end}, "
          f"NRT {nrt_start} -> today: {len(recent):,} detections")

    if len(recent):
        for key, part in (("cells", aggregate_cells(recent)),
                          ("daily", daily_totals(recent))):
            for column, values in part.items():
                history[key][column].extend(values)
        for asset_id, events in exposure_events(assets, recent).items():
            target = history["exposure"].setdefault(
                asset_id, {"d": [], "n10": [], "n25": [], "f10": [], "dm": []})
            for column, values in events.items():
                target[column].extend(values)

    baseline_path = Path(f"results/asset_risk_{region.slug}.csv")
    baseline = {}
    if baseline_path.is_file():
        b = pd.read_csv(baseline_path)
        baseline = dict(zip(b["asset_id"].astype(str), b["risk_level"]))

    history["assets"] = [
        {"id": str(a.asset_id), "name": a.name, "kind": a.kind,
         "country": a.country or "", "lat": round(a.latitude, 4),
         "lon": round(a.longitude, 4),
         "baseline": baseline.get(str(a.asset_id), "n/a")}
        for a in assets.itertuples(index=False)
    ]
    center, zoom = REGION_VIEWS.get(
        region.slug,
        ({"lat": assets["latitude"].mean(), "lon": assets["longitude"].mean()}, 5.0),
    )
    yesterday = dt.date.today() - dt.timedelta(days=1)
    history["meta"] = {
        "region": region.slug,
        "region_label": REGION_LABELS.get(region.slug, region.slug),
        "epoch": history["epoch"],
        "max_day": (yesterday - EPOCH.date()).days,
        "archive_end": history["archive_end"],
        "center": center,
        "zoom": zoom,
    }
    return history


PAGE_TEMPLATE = r"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Wildfire Infrastructure Risk Monitor</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<script src="https://cdn.plot.ly/plotly-3.1.0.min.js" charset="utf-8"></script>
<style>
  :root {
    --bg: #f6f5f2; --card: #ffffff; --border: #e6e5e1; --strip: #faf9f6;
    --ink: #0b0b0b; --ink-2: #52514e; --accent: #2a78d6;
    --radius: 12px; --shadow: 0 1px 3px rgba(20, 18, 12, 0.06);
  }
  * { box-sizing: border-box; }
  body { background: var(--bg); color: var(--ink); margin: 0;
         font-family: Inter, system-ui, sans-serif; font-size: 14px; }
  .wrap { max-width: 1180px; margin: 0 auto; padding: 32px 24px 48px; }

  .eyebrow { font-size: 12px; font-weight: 600; letter-spacing: 0.08em;
             text-transform: uppercase; color: var(--accent); margin-bottom: 6px; }
  .titlebar { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  h1 { font-size: 28px; font-weight: 700; margin: 0; letter-spacing: -0.02em; }
  .badge { font-size: 12px; font-weight: 600; padding: 4px 11px; border-radius: 999px;
           background: #e8f0fb; color: #1c5cab; }
  .subtitle { color: var(--ink-2); font-size: 14px; line-height: 1.6;
              margin: 10px 0 24px; max-width: 880px; }

  .card { background: var(--card); border: 1px solid var(--border);
          border-radius: var(--radius); box-shadow: var(--shadow); margin-bottom: 24px; }
  .card-strip { display: flex; align-items: baseline; justify-content: space-between;
                gap: 12px; padding: 12px 18px; background: var(--strip);
                border-bottom: 1px solid var(--border);
                border-radius: var(--radius) var(--radius) 0 0; flex-wrap: wrap; }
  .card-title { font-size: 15px; font-weight: 600; }
  .card-context { font-size: 12.5px; color: var(--ink-2); }
  .card-body { padding: 12px; }

  .controls { display: flex; align-items: center; gap: 14px; flex-wrap: wrap;
              padding: 14px 18px; }
  .control { display: flex; align-items: center; gap: 7px; }
  .control label { font-size: 12.5px; color: var(--ink-2); font-weight: 500; }
  select, input[type="date"] { font: inherit; font-size: 13px; padding: 7px 10px;
    border-radius: 8px; border: 1px solid var(--border); background: var(--card);
    color: var(--ink); max-width: 210px; }
  .chips { display: flex; gap: 8px; flex-wrap: wrap; }
  .chip { font: inherit; font-size: 12.5px; font-weight: 500; padding: 6px 13px;
          border-radius: 999px; border: 1px solid var(--border); background: var(--card);
          color: var(--ink-2); cursor: pointer; }
  .chip:hover { border-color: var(--accent); color: var(--accent); }
  .chip.active { background: var(--accent); border-color: var(--accent); color: #fff; }
  .spacer { flex: 1; }

  .tiles { display: grid; grid-template-columns: repeat(auto-fit, minmax(148px, 1fr));
           gap: 16px; margin-bottom: 24px; }
  .tile { background: var(--card); border: 1px solid var(--border);
          border-radius: var(--radius); box-shadow: var(--shadow); padding: 14px 16px; }
  .tile-label { font-size: 12px; color: var(--ink-2); margin-bottom: 4px; }
  .tile-value { font-size: 24px; font-weight: 650; letter-spacing: -0.01em; }
  .tile-note { font-size: 11.5px; color: var(--ink-2); margin-top: 3px; }

  table { border-collapse: collapse; width: 100%; font-size: 13px; }
  th, td { text-align: left; padding: 8px 12px; border-bottom: 1px solid var(--border); }
  th { background: var(--strip); cursor: pointer; user-select: none;
       white-space: nowrap; font-weight: 600; font-size: 12.5px; }
  th:hover { color: var(--accent); }
  tr:hover td { background: var(--strip); }
  .status { font-weight: 600; font-size: 12px; padding: 2px 10px; border-radius: 999px; }
  .status-exposed { background: #fbe4e4; color: #a52222; }
  .status-nearby { background: #fdf2d7; color: #8a6100; }
  .num { font-variant-numeric: tabular-nums; }

  .term { border-bottom: 1px dotted var(--ink-2); cursor: help; position: relative; }
  .term:hover::after { content: attr(data-tip); position: absolute; left: 0; bottom: 135%;
    z-index: 30; width: 300px; background: #262622; color: #fbfbfa; font-size: 12px;
    font-weight: 400; line-height: 1.5; padding: 10px 12px; border-radius: 8px;
    box-shadow: 0 6px 18px rgba(0,0,0,0.28); white-space: normal; }
  .empty { color: var(--ink-2); font-size: 13.5px; padding: 14px 6px; }
  .loading { color: var(--ink-2); padding: 60px 0; text-align: center; }
  footer { color: var(--ink-2); font-size: 12.5px; line-height: 1.75; margin-top: 8px;
           border-top: 1px solid var(--border); padding-top: 16px; }
  footer a { color: var(--accent); }
  @media (max-width: 760px) { h1 { font-size: 23px; } }
</style>
</head>
<body>
<div class="wrap">
  <div class="eyebrow">NASA FIRMS &middot; VIIRS 375 m active fire</div>
  <div class="titlebar">
    <h1>Wildfire Infrastructure Risk Monitor</h1>
    <span class="badge" id="region-badge"></span>
  </div>
  <div class="subtitle">
    Daily satellite
    <span class="term" data-tip="A 'detection' is one ~375 m satellite pixel flagged as a thermal anomaly by the VIIRS instrument. In the historical archive, static industrial heat sources are filtered out; what remains is presumed vegetation fire.">fire detections</span>
    versus airports and ports, gapless from January 2018 to yesterday
    (<span class="term" data-tip="2018 to April 2026 comes from the standard-processing archive (consistently calibrated); the most recent weeks come from the near-real-time feed, available within ~3 hours of the satellite overpass.">archive + near-real-time</span>).
    Pick a region, a country and any date range. Updated __GENERATED__, refreshed daily.
  </div>

  <div id="app" class="loading">Loading data&hellip;</div>
</div>

<template id="app-template">
  <div class="card">
    <div class="controls">
      <div class="control"><label for="region">Region</label><select id="region"></select></div>
      <div class="control"><label for="country">Country</label><select id="country"></select></div>
      <div class="spacer"></div>
      <div class="chips" id="chips"></div>
      <div class="control"><label for="from">From</label><input type="date" id="from">
        <label for="to">to</label><input type="date" id="to"></div>
    </div>
  </div>

  <div class="tiles" id="tiles"></div>

  <div class="card">
    <div class="card-strip">
      <span class="card-title term" data-tip="Orange cells aggregate all fire detections inside the selected date range (~5 km grid). Markers are the monitored assets, colored by whether fire came within 10 km (red) or 25 km (yellow) of them during the range. Hover any marker for details; scroll to zoom.">Fire detections &amp; infrastructure exposure</span>
      <span class="card-context" id="map-context"></span>
    </div>
    <div class="card-body"><div id="map" style="height:560px"></div></div>
  </div>

  <div class="card">
    <div class="card-strip">
      <span class="card-title term" id="trend-title" data-tip="Total detections in the selected region per day. For ranges longer than four months the bars aggregate to months.">Detections over time</span>
      <span class="card-context">click and drag to zoom</span>
    </div>
    <div class="card-body"><div id="trend" style="height:240px"></div></div>
  </div>

  <div class="card">
    <div class="card-strip">
      <span class="card-title term" data-tip="Every monitored asset that had at least one fire detection within 25 km during the selected range, with counts, summed intensity (FRP), the closest a detection came, and the asset's long-run risk level. Click a column header to sort.">Assets with fire activity in this range</span>
      <span class="card-context">click a column header to sort</span>
    </div>
    <div class="card-body" style="padding: 4px 12px 10px;"><div id="table-holder"></div></div>
  </div>

  <footer>
    <b>Notes.</b>
    <span class="term" data-tip="Fire Radiative Power, in megawatts: the radiant heat output of the fire in that pixel at overpass time. Higher FRP = more intense burning.">FRP</span>
    is the intensity measure; an asset counts as
    <span class="term" data-tip="At least one detection within 10 km of the asset on at least one day of the selected range.">exposed</span>
    when a detection falls within 10 km, and "nearby" within 25 km. The country filter
    applies to assets; fire counts always cover the whole region. Historical risk is a
    percentile score over the 2018-2026 record - method in the
    <a href="https://github.com/apham2509/personal-projects/tree/main/wildfire-infrastructure-risk">repository</a>.
    Recent weeks come from the near-real-time feed, which cannot yet filter out
    static industrial heat sources; the satellite also cannot see through clouds,
    so absence of detections is not proof of absence of fire.<br>
    Data: <a href="https://firms.modaps.eosdis.nasa.gov/">NASA FIRMS</a> (VIIRS 375 m active fire, LANCE/ESDIS),
    <a href="https://ourairports.com/data/">OurAirports</a>,
    <a href="https://www.openstreetmap.org/copyright">OpenStreetMap contributors</a>.
    Built with Python and Plotly.
  </footer>
</template>

<script>
const MANIFEST = __MANIFEST__;
const STATUS = {
  exposed: {label: "Exposed - fire within 10 km", color: "#d03b3b", size: 13},
  nearby:  {label: "Fire within 25 km",           color: "#fab219", size: 10},
  clear:   {label: "No fire nearby",              color: "#8a8983", size: 6},
};
const HEAT_SCALE = [[0,"rgba(255,245,235,0)"],[0.2,"#fdd0a2"],[0.4,"#fdae6b"],
                    [0.6,"#f16913"],[0.8,"#d94801"],[1,"#7f2704"]];
const MS_DAY = 86400000;
const fmt = n => n.toLocaleString("en-US");
const countryName = code => {
  if (!code) return "Unknown";
  try { return new Intl.DisplayNames(["en"], {type: "region"}).of(code) || code; }
  catch (e) { return code; }
};

let DATA, META, EPOCH_MS, booted = false;
let state = {from: 0, to: 0, country: "all"};
let sortKey = "det10", sortDir = -1;

const dayToDate = d => new Date(EPOCH_MS + d * MS_DAY);
const dateToDay = iso => Math.round((new Date(iso + "T00:00:00Z") - EPOCH_MS) / MS_DAY);
const isoOf = d => dayToDate(d).toISOString().slice(0, 10);
const human = d => dayToDate(d).toLocaleDateString("en-GB", {day: "numeric", month: "short", year: "numeric"});

const PRESETS = [
  ["Last 30 days", () => [META.max_day - 30, META.max_day]],
  ["Last 12 months", () => [META.max_day - 364, META.max_day]],
  ["2025", () => [dateToDay("2025-01-01"), dateToDay("2025-12-31")]],
  ["2022", () => [dateToDay("2022-01-01"), dateToDay("2022-12-31")]],
  ["All 2018-now", () => [0, META.max_day]],
];

function rangeAssets() {
  const {from, to, country} = state;
  return DATA.assets
    .filter(a => country === "all" || a.country === country)
    .map(a => {
      const e = DATA.exposure[a.id];
      let det10 = 0, det25 = 0, frp10 = 0, days10 = 0, nearest = null;
      if (e) {
        for (let i = 0; i < e.d.length; i++) {
          const d = e.d[i];
          if (d < from || d > to) continue;
          det10 += e.n10[i]; det25 += e.n25[i]; frp10 += e.f10[i];
          if (e.n10[i] > 0) days10 += 1;
          if (nearest === null || e.dm[i] < nearest) nearest = e.dm[i];
        }
      }
      const status = det10 > 0 ? "exposed" : det25 > 0 ? "nearby" : "clear";
      return {...a, det10, det25, frp10, days10, nearest, status};
    });
}

function heatTrace() {
  const {from, to} = state;
  const c = DATA.cells, acc = new Map();
  for (let i = 0; i < c.d.length; i++) {
    if (c.d[i] < from || c.d[i] > to) continue;
    const key = c.la[i] + ":" + c.lo[i];
    acc.set(key, (acc.get(key) || 0) + c.n[i]);
  }
  const lat = [], lon = [], z = [];
  for (const [key, n] of acc) {
    const [la, lo] = key.split(":");
    lat.push(la * DATA.grid); lon.push(lo * DATA.grid); z.push(n);
  }
  const zs = [...z].sort((a, b) => a - b);
  const zmax = Math.max(5, zs[Math.floor(zs.length * 0.98)] || 5);
  return {
    type: "densitymap", lat, lon, z, radius: (state.to - state.from) < 45 ? 9 : 7,
    colorscale: HEAT_SCALE, zmin: 0, zmax, showscale: true,
    hoverinfo: "skip", name: "Detections",
    colorbar: {title: {text: "Detections<br>per ~5 km cell", font: {size: 11}},
               thickness: 12, len: 0.5, y: 0.72, outlinewidth: 0},
  };
}

function mapTraces(assets) {
  const traces = [heatTrace()];
  for (const [status, style] of Object.entries(STATUS)) {
    const subset = assets.filter(a => a.status === status);
    if (!subset.length) continue;
    traces.push({
      type: "scattermap", mode: "markers",
      lat: subset.map(a => a.lat), lon: subset.map(a => a.lon),
      marker: {size: style.size, color: style.color},
      name: `${style.label} (${subset.length})`,
      customdata: subset.map(a => [a.name, a.kind, a.det10, Math.round(a.frp10),
                                   a.nearest ?? "-", a.days10, a.baseline]),
      hovertemplate: "<b>%{customdata[0]}</b> (%{customdata[1]})<br>" +
        "Detections within 10 km: %{customdata[2]:,}<br>" +
        "FRP within 10 km: %{customdata[3]:,} MW<br>" +
        "Days with fire within 10 km: %{customdata[5]:,}<br>" +
        "Nearest detection: %{customdata[4]} km<br>" +
        "Historical risk: %{customdata[6]}<extra></extra>",
    });
  }
  return traces;
}

function trendFigure() {
  const {from, to} = state, span = to - from;
  const monthly = span > 120, acc = new Map();
  const daily = DATA.daily;
  for (let i = 0; i < daily.d.length; i++) {
    const d = daily.d[i];
    if (d < from || d > to) continue;
    const key = monthly ? isoOf(d).slice(0, 7) : isoOf(d);
    acc.set(key, (acc.get(key) || 0) + daily.n[i]);
  }
  document.getElementById("trend-title").textContent =
    monthly ? "Detections per month" : "Detections per day";
  return {
    data: [{type: "bar", x: [...acc.keys()], y: [...acc.values()],
            marker: {color: "#2a78d6", cornerradius: 3},
            hovertemplate: "%{x}: %{y:,} detections<extra></extra>"}],
    layout: {height: 240, margin: {l: 55, r: 15, t: 10, b: 40},
      paper_bgcolor: "#ffffff", plot_bgcolor: "#ffffff", bargap: 0.25,
      font: {family: "Inter, system-ui, sans-serif"},
      xaxis: {tickfont: {size: 11, color: "#52514e"}, showgrid: false,
              type: "category", nticks: 14},
      yaxis: {tickfont: {size: 11, color: "#52514e"}, gridcolor: "#eceae6",
              zerolinecolor: "#eceae6"}},
    config: {displayModeBar: false, responsive: true},
  };
}

const TILE_TIPS = {
  "Fire detections": "Total satellite fire detections in the whole region during the selected range (the country filter does not reduce this number).",
  "Exposed assets": "Assets with at least one detection within 10 km during the range.",
  "Near fire": "Assets whose closest detection in the range fell between 10 and 25 km.",
  "Peak day": "The single day with the most detections in the range.",
  "Strongest detection": "The highest fire radiative power (MW) of any single detection in the range.",
  "Assets monitored": "Airports (large + medium) and named commercial ports in the current selection.",
};

function kpis(assets) {
  const {from, to} = state;
  let detections = 0, peak = 0, peakDay = null, maxFrp = 0;
  const daily = DATA.daily;
  for (let i = 0; i < daily.d.length; i++) {
    const d = daily.d[i];
    if (d < from || d > to) continue;
    detections += daily.n[i];
    if (daily.n[i] > peak) { peak = daily.n[i]; peakDay = d; }
    if (daily.fm[i] > maxFrp) maxFrp = daily.fm[i];
  }
  const exposed = assets.filter(a => a.status === "exposed").length;
  const nearby = assets.filter(a => a.status === "nearby").length;
  const high = assets.filter(a => a.baseline === "high").length;
  const scope = state.country === "all" ? "" : countryName(state.country);
  return [
    ["Fire detections", fmt(detections), `${human(from)} - ${human(to)}`],
    ["Exposed assets", fmt(exposed), "fire within 10 km"],
    ["Near fire", fmt(nearby), "within 25 km"],
    ["Peak day", peakDay === null ? "-" : fmt(peak), peakDay === null ? "" : human(peakDay)],
    ["Strongest detection", maxFrp ? fmt(Math.round(maxFrp)) + " MW" : "-", "fire radiative power"],
    ["Assets monitored", fmt(assets.length),
     scope ? `${scope} · ${high} high-risk` : `${high} high-risk since 2018`],
  ];
}

function renderTiles(assets) {
  document.getElementById("tiles").innerHTML = kpis(assets).map(([label, value, note]) =>
    `<div class="tile"><div class="tile-label"><span class="term" data-tip="${TILE_TIPS[label] || ""}">${label}</span></div>` +
    `<div class="tile-value">${value}</div>` +
    (note ? `<div class="tile-note">${note}</div>` : "")).join("");
}

function renderTable(assets) {
  const rows = assets.filter(r => r.status !== "clear");
  const holder = document.getElementById("table-holder");
  if (!rows.length) {
    holder.innerHTML = '<div class="empty">No monitored asset had fire detections within 25 km in this range.</div>';
    return;
  }
  rows.sort((a, b) => {
    const va = a[sortKey] ?? -1, vb = b[sortKey] ?? -1;
    return (va < vb ? -1 : va > vb ? 1 : 0) * sortDir;
  });
  const cols = [
    ["name", "Asset"], ["kind", "Kind"], ["country", "Country"], ["status", "Status"],
    ["det10", "Detections &le;10 km"], ["frp10", "FRP &le;10 km (MW)"],
    ["days10", "Days with fire &le;10 km"], ["nearest", "Nearest (km)"],
    ["baseline", "Historical risk"],
  ];
  const head = cols.map(([id, label]) =>
    `<th data-key="${id}">${label}${sortKey === id ? (sortDir < 0 ? " &#9662;" : " &#9652;") : ""}</th>`).join("");
  const body = rows.slice(0, 40).map(r => `<tr>
    <td>${r.name}</td><td>${r.kind}</td><td>${countryName(r.country)}</td>
    <td><span class="status status-${r.status}">${r.status}</span></td>
    <td class="num">${fmt(r.det10)}</td><td class="num">${fmt(Math.round(r.frp10))}</td>
    <td class="num">${fmt(r.days10)}</td><td class="num">${r.nearest ?? "-"}</td>
    <td>${r.baseline}</td></tr>`).join("");
  holder.innerHTML = `<table><thead><tr>${head}</tr></thead><tbody>${body}</tbody></table>` +
    (rows.length > 40 ? `<div class="empty">Showing the top 40 of ${rows.length} assets.</div>` : "");
  holder.querySelectorAll("th[data-key]").forEach(th => th.onclick = () => {
    const k = th.dataset.key;
    if (sortKey === k) sortDir *= -1; else { sortKey = k; sortDir = -1; }
    update(false);
  });
}

const MAP_LAYOUT = () => ({
  map: {style: "carto-positron", center: META.center, zoom: META.zoom},
  margin: {l: 0, r: 0, t: 0, b: 0}, paper_bgcolor: "#ffffff",
  font: {family: "Inter, system-ui, sans-serif"},
  legend: {x: 0.01, y: 0.99, bgcolor: "rgba(255,255,255,0.9)", font: {size: 12}},
});

function update(fullRedraw = true) {
  const assets = rangeAssets();
  renderTiles(assets);
  renderTable(assets);
  document.getElementById("map-context").textContent =
    `${human(state.from)} - ${human(state.to)} · ${state.to - state.from + 1} days`;
  if (fullRedraw) {
    Plotly.react("map", mapTraces(assets), MAP_LAYOUT(), {scrollZoom: true, responsive: true});
    const t = trendFigure();
    Plotly.react("trend", t.data, t.layout, t.config);
  }
  document.querySelectorAll(".chip").forEach(chip => {
    const [f, t] = PRESETS[chip.dataset.idx][1]();
    chip.classList.toggle("active",
      Math.max(0, f) === state.from && Math.min(t, META.max_day) === state.to);
  });
  document.getElementById("from").value = isoOf(state.from);
  document.getElementById("to").value = isoOf(state.to);
}

function setRange(from, to) {
  state.from = Math.max(0, Math.min(from, META.max_day));
  state.to = Math.max(state.from, Math.min(to, META.max_day));
  update();
}

function populateCountries() {
  const select = document.getElementById("country");
  select.innerHTML = "";
  const all = document.createElement("option");
  all.value = "all"; all.textContent = "All";
  select.appendChild(all);
  const codes = [...new Set(DATA.assets.map(a => a.country).filter(Boolean))].sort();
  for (const code of codes) {
    const opt = document.createElement("option");
    opt.value = code; opt.textContent = countryName(code);
    select.appendChild(opt);
  }
  select.value = "all";
  state.country = "all";
}

function applyRegion(payload) {
  DATA = payload; META = payload.meta;
  EPOCH_MS = new Date(META.epoch + "T00:00:00Z").getTime();
  document.getElementById("region-badge").textContent = META.region_label;

  if (!booted) {
    booted = true;
    const app = document.getElementById("app");
    app.classList.remove("loading");
    app.innerHTML = "";
    app.appendChild(document.getElementById("app-template").content);

    const regionSelect = document.getElementById("region");
    for (const entry of MANIFEST) {
      const opt = document.createElement("option");
      opt.value = entry.slug;
      opt.textContent = entry.available ? entry.label : `${entry.label} (${entry.note})`;
      opt.disabled = !entry.available;
      regionSelect.appendChild(opt);
    }
    regionSelect.value = META.region;
    regionSelect.addEventListener("change", () => loadRegion(regionSelect.value));
    document.getElementById("country").addEventListener("change", e => {
      state.country = e.target.value;
      update();
    });
    const chips = document.getElementById("chips");
    PRESETS.forEach(([label], idx) => {
      const b = document.createElement("button");
      b.className = "chip"; b.textContent = label; b.dataset.idx = idx;
      b.onclick = () => setRange(...PRESETS[idx][1]());
      chips.appendChild(b);
    });
    const clampInput = () => setRange(dateToDay(document.getElementById("from").value),
                                      dateToDay(document.getElementById("to").value));
    for (const id of ["from", "to"]) {
      document.getElementById(id).addEventListener("change", clampInput);
    }
  }
  for (const id of ["from", "to"]) {
    const input = document.getElementById(id);
    input.min = META.epoch; input.max = isoOf(META.max_day);
  }
  populateCountries();

  state.from = META.max_day - 30;
  state.to = META.max_day;
  const assets = rangeAssets();
  Plotly.newPlot("map", mapTraces(assets), MAP_LAYOUT(), {scrollZoom: true, responsive: true});
  const t = trendFigure();
  Plotly.newPlot("trend", t.data, t.layout, t.config);
  update(false);
}

function loadRegion(slug) {
  const entry = MANIFEST.find(e => e.slug === slug && e.available);
  if (!entry) return;
  document.getElementById("map-context").textContent = "loading...";
  fetch(entry.file).then(r => r.json()).then(applyRegion)
    .catch(err => { document.getElementById("app").textContent = "Failed to load data: " + err; });
}

fetch(MANIFEST.find(e => e.available).file).then(r => r.json()).then(applyRegion)
  .catch(err => { document.getElementById("app").textContent = "Failed to load data: " + err; });
</script>
</body>
</html>
"""


def render(region_names: list, source: str, out: Path) -> None:
    out.parent.mkdir(parents=True, exist_ok=True)
    manifest = []
    for name in region_names:
        region = regions.resolve(name)
        data = merged_data(region, source)
        data_path = out.parent / f"data_{region.slug}.json"
        data_path.write_text(json.dumps(data, separators=(",", ":")), encoding="utf-8")
        manifest.append({"slug": region.slug,
                         "label": REGION_LABELS.get(region.slug, region.slug),
                         "file": data_path.name, "available": True})
        print(f"  {data_path} ({data_path.stat().st_size / 1e6:.1f} MB)")
    if not any(entry["slug"] == "world" for entry in manifest):
        manifest.insert(0, {"slug": "world", "label": REGION_LABELS["world"],
                            "file": "", "available": False,
                            "note": WORLD_PLACEHOLDER_NOTE})

    generated = dt.datetime.now(dt.timezone.utc).strftime("%d %b %Y, %H:%M UTC")
    page = (PAGE_TEMPLATE
            .replace("__MANIFEST__", json.dumps(manifest))
            .replace("__GENERATED__", generated))
    out.write_text(page, encoding="utf-8")
    print(f"wrote {out}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Render static wildfire dashboard.")
    parser.add_argument("--regions", default="iberia",
                        help="Comma-separated region names with prepared history")
    parser.add_argument("--source", default="VIIRS_SNPP_NRT",
                        help="NRT source used to extend each archive to today")
    parser.add_argument("--out", default="site/index.html")
    args = parser.parse_args()
    render([r.strip() for r in args.regions.split(",")], args.source, Path(args.out))


if __name__ == "__main__":
    main()
