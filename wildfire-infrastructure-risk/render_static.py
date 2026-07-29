"""Render the wildfire dashboard as a static, client-interactive HTML page.

The page combines:
  - live near-real-time detections (last 5 days) pulled at build time
  - the precomputed historical aggregates (results/history_<region>.json,
    built by prepare_history.py) so viewers can switch the data window
    between "Live", each year, and the full record
  - a global fire-activity map (last 24 h, world)

All interactivity (window selector, hover, zoom, sortable table, term
definitions) runs client-side, so the page deploys to GitHub Pages as-is.

Usage:
    python render_static.py                       # iberia -> site/index.html
    python render_static.py --region iberia --out ../site/wildfire-infrastructure-risk/index.html
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
from pathlib import Path

import pandas as pd

import firms
import regions
from prepare_history import GRID, window_payload

REGION_LABELS = {"iberia": "Iberia (Spain & Portugal)"}


def world_heat(days: int = 1, grid: float = 0.1) -> dict:
    fires = firms.area_fires(source="VIIRS_SNPP_NRT", bbox="world", days=days)
    if "type" in fires.columns:
        fires = fires[fires["type"] == 0]
    cells = (
        fires.assign(
            glat=(fires["latitude"] / grid).round() * grid,
            glon=(fires["longitude"] / grid).round() * grid,
        )
        .groupby(["glat", "glon"])
        .size()
        .reset_index(name="n")
    )
    return {
        "lat": [round(v, 2) for v in cells["glat"]],
        "lon": [round(v, 2) for v in cells["glon"]],
        "z": cells["n"].tolist(),
        "detections": int(len(fires)),
    }


def build_data(region: regions.Region, days: int, source: str) -> tuple[dict, list, dict]:
    fires = firms.area_fires(source=source, bbox=region.bbox, days=days)
    if "type" in fires.columns:
        fires = fires[fires["type"] == 0]
    fires["acq_date"] = pd.to_datetime(fires["acq_date"])
    assets = pd.read_csv(f"data/infrastructure/{region.slug}/assets.csv")

    history_path = Path(f"results/history_{region.slug}.json")
    windows = {}
    if history_path.is_file():
        windows = json.loads(history_path.read_text())["windows"]

    live_label = "Live - last 5 days"
    windows = {"live": window_payload(fires, assets, live_label, freq="D"), **windows}

    baseline_path = Path(f"results/asset_risk_{region.slug}.csv")
    baseline = {}
    if baseline_path.is_file():
        b = pd.read_csv(baseline_path)
        baseline = dict(zip(b["asset_id"].astype(str), b["risk_level"]))

    asset_list = [
        {
            "id": str(a.asset_id), "name": a.name, "kind": a.kind,
            "lat": round(a.latitude, 4), "lon": round(a.longitude, 4),
            "baseline": baseline.get(str(a.asset_id), "n/a"),
        }
        for a in assets.itertuples(index=False)
    ]
    meta = {
        "region": region.slug,
        "region_label": REGION_LABELS.get(region.slug, region.slug),
        "center": {"lat": assets["latitude"].mean(), "lon": assets["longitude"].mean()},
        "zoom": 5.0,
        "generated": dt.datetime.now(dt.timezone.utc).strftime("%Y-%m-%d %H:%M UTC"),
        "source": source,
    }
    return windows, asset_list, meta


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
    --surface: #fcfcfb; --card: #ffffff; --border: #e6e5e1;
    --ink: #0b0b0b; --ink-2: #52514e; --accent: #2a78d6;
    --exposed: #d03b3b; --nearby: #fab219; --clear: #8a8983;
  }
  * { box-sizing: border-box; }
  body { background: var(--surface); color: var(--ink); margin: 0;
         font-family: Inter, system-ui, sans-serif; }
  .wrap { max-width: 1180px; margin: 0 auto; padding: 28px 22px 40px; }
  header { display: flex; align-items: baseline; gap: 12px; flex-wrap: wrap; }
  h1 { font-size: 26px; font-weight: 700; margin: 0; letter-spacing: -0.02em; }
  .badge { font-size: 12px; font-weight: 600; padding: 3px 10px; border-radius: 999px; }
  .badge-region { background: #e8f0fb; color: #1c5cab; }
  .badge-live { background: #e7f6e7; color: #0a7a0a; }
  .subtitle { color: var(--ink-2); font-size: 14px; margin: 6px 0 22px; max-width: 900px; }
  .controls { display: flex; align-items: center; gap: 10px; margin-bottom: 14px; flex-wrap: wrap; }
  .controls label { font-size: 13px; color: var(--ink-2); font-weight: 500; }
  select { font: inherit; font-size: 14px; padding: 7px 12px; border-radius: 8px;
           border: 1px solid var(--border); background: var(--card); color: var(--ink); }
  .tiles { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
           gap: 12px; margin-bottom: 16px; }
  .tile { background: var(--card); border: 1px solid var(--border); border-radius: 12px;
          padding: 14px 16px; box-shadow: 0 1px 2px rgba(0,0,0,0.04); }
  .tile-label { font-size: 12px; color: var(--ink-2); margin-bottom: 3px; }
  .tile-value { font-size: 22px; font-weight: 650; letter-spacing: -0.01em; }
  .card { background: var(--card); border: 1px solid var(--border); border-radius: 12px;
          box-shadow: 0 1px 2px rgba(0,0,0,0.04); padding: 10px; margin-bottom: 16px; }
  h2 { font-size: 17px; font-weight: 650; margin: 26px 0 10px; }
  table { border-collapse: collapse; width: 100%; font-size: 13px; }
  th, td { text-align: left; padding: 7px 10px; border-bottom: 1px solid var(--border); }
  th { background: #f4f3f0; cursor: pointer; user-select: none; white-space: nowrap; }
  th:hover { background: #ecebe7; }
  tr:hover td { background: #faf9f6; }
  .status { font-weight: 600; font-size: 12px; padding: 2px 9px; border-radius: 999px; }
  .status-exposed { background: #fbe4e4; color: #a52222; }
  .status-nearby { background: #fdf2d7; color: #8a6100; }
  .status-clear { background: #efeeeb; color: #52514e; }
  .term { border-bottom: 1px dotted var(--ink-2); cursor: help; position: relative; }
  .term:hover::after { content: attr(data-tip); position: absolute; left: 0; bottom: 130%;
    z-index: 30; width: 280px; background: #262622; color: #fbfbfa; font-size: 12px;
    font-weight: 400; line-height: 1.45; padding: 9px 11px; border-radius: 8px;
    box-shadow: 0 4px 14px rgba(0,0,0,0.25); white-space: normal; }
  footer { color: var(--ink-2); font-size: 12.5px; line-height: 1.7; margin-top: 30px;
           border-top: 1px solid var(--border); padding-top: 14px; }
  footer a { color: var(--accent); }
  .empty { color: var(--ink-2); font-size: 14px; padding: 12px 4px; }
</style>
</head>
<body>
<div class="wrap">
  <header>
    <h1>Wildfire Infrastructure Risk Monitor</h1>
    <span class="badge badge-region">__REGION_LABEL__</span>
    <span class="badge badge-live" id="live-badge">LIVE</span>
  </header>
  <div class="subtitle">
    Satellite
    <span class="term" data-tip="A 'detection' is one ~375 m satellite pixel flagged as a thermal anomaly by the VIIRS instrument. Static industrial heat sources are filtered out; what remains is presumed vegetation fire.">fire detections</span>
    from NASA FIRMS
    (<span class="term" data-tip="VIIRS: Visible Infrared Imaging Radiometer Suite, an instrument on the Suomi-NPP satellite. It observes every point on Earth at least twice a day.">VIIRS</span>,
    <span class="term" data-tip="NRT = near-real-time feed (available within ~3 hours, used for the live window). Historical years use the standard-processing archive, which is more consistently calibrated.">NRT + archive</span>)
    versus airports and ports. Pick a data window to explore the full 2018-2025 record.
    Updated __GENERATED__, refreshed daily.
  </div>

  <div class="controls">
    <label for="window">Data window</label>
    <select id="window"></select>
  </div>

  <div class="tiles" id="tiles"></div>

  <div class="card"><div id="map" style="height:560px"></div></div>
  <div class="card"><div id="trend" style="height:250px"></div></div>

  <h2>Assets with fire activity nearby</h2>
  <div class="card" style="padding: 4px 10px;">
    <div id="table-holder"></div>
  </div>

  <h2>Global fire activity - last 24 hours</h2>
  <div class="card"><div id="worldmap" style="height:430px"></div></div>

  <footer>
    <b>Notes.</b>
    <span class="term" data-tip="Fire Radiative Power, in megawatts: the radiant heat output of the fire in that pixel at overpass time. Higher FRP = more intense burning.">FRP</span>
    is used as the intensity measure; an asset counts as exposed when a detection falls
    within 10 km, and "nearby" within 25 km. Historical risk is a percentile score over
    the 2018-2025 record (see the
    <a href="https://github.com/apham2509/personal-projects/tree/main/wildfire-infrastructure-risk">repository</a>
    for the method). Detections can also be missed under cloud cover - absence of
    detections is not proof of absence of fire.<br>
    Data: <a href="https://firms.modaps.eosdis.nasa.gov/">NASA FIRMS</a> (VIIRS 375 m active fire, LANCE/ESDIS),
    <a href="https://ourairports.com/data/">OurAirports</a>,
    <a href="https://www.openstreetmap.org/copyright">OpenStreetMap contributors</a>.
    Built with Python and Plotly.
  </footer>
</div>

<script>
const WINDOWS = __WINDOWS__;
const ASSETS = __ASSETS__;
const META = __META__;
const WORLD = __WORLD__;

const STATUS = {
  exposed: {label: "Exposed - fire within 10 km", color: "#d03b3b", size: 13},
  nearby:  {label: "Fire within 25 km",           color: "#fab219", size: 10},
  clear:   {label: "No fire nearby",              color: "#8a8983", size: 6},
};
const HEAT_SCALE = [[0,"rgba(255,245,235,0)"],[0.2,"#fdd0a2"],[0.4,"#fdae6b"],
                    [0.6,"#f16913"],[0.8,"#d94801"],[1,"#7f2704"]];
const fmt = n => n.toLocaleString("en-US");

function mapTraces(key) {
  const w = WINDOWS[key];
  const traces = [{
    type: "densitymap", lat: w.heat.lat, lon: w.heat.lon, z: w.heat.z,
    radius: key === "live" ? 9 : 7, colorscale: HEAT_SCALE, zmin: 0,
    zmax: Math.max(5, quantile(w.heat.z, 0.98)),
    showscale: true, hoverinfo: "skip", name: "Detections",
    colorbar: {title: {text: "Detections<br>per ~5 km cell", font: {size: 11}},
               thickness: 12, len: 0.55, y: 0.75, outlinewidth: 0},
  }];
  for (const [status, style] of Object.entries(STATUS)) {
    const subset = ASSETS.filter(a => (w.assets[a.id] || {status: "clear"}).status === status);
    if (!subset.length) continue;
    traces.push({
      type: "scattermap", mode: "markers",
      lat: subset.map(a => a.lat), lon: subset.map(a => a.lon),
      marker: {size: style.size, color: style.color},
      name: `${style.label} (${subset.length})`,
      customdata: subset.map(a => {
        const m = w.assets[a.id] || {};
        return [a.name, a.kind, m.det10 ?? 0, m.frp10 ?? 0, m.nearest ?? "-", a.baseline];
      }),
      hovertemplate: "<b>%{customdata[0]}</b> (%{customdata[1]})<br>" +
        "Detections within 10 km: %{customdata[2]}<br>" +
        "FRP within 10 km: %{customdata[3]:,.0f} MW<br>" +
        "Nearest detection: %{customdata[4]} km<br>" +
        "Historical risk: %{customdata[5]}<extra></extra>",
    });
  }
  return traces;
}

function quantile(arr, q) {
  const s = [...arr].sort((a, b) => a - b);
  return s[Math.min(s.length - 1, Math.floor(q * s.length))] || 1;
}

const MAP_LAYOUT = {
  map: {style: "carto-positron", center: META.center, zoom: META.zoom},
  margin: {l: 0, r: 0, t: 0, b: 0}, paper_bgcolor: "#ffffff",
  legend: {x: 0.01, y: 0.99, bgcolor: "rgba(255,255,255,0.88)", font: {size: 12}},
};

function trendFigure(key) {
  const w = WINDOWS[key];
  return {
    data: [{type: "bar", x: w.trend.x, y: w.trend.y,
            marker: {color: "#2a78d6", cornerradius: 4},
            hovertemplate: "%{x}: %{y:,} detections<extra></extra>"}],
    layout: {
      title: {text: key === "live" ? "Detections per day" : "Detections per month",
              font: {size: 14, family: "Inter"}, x: 0.02},
      height: 250, margin: {l: 55, r: 15, t: 40, b: 40},
      paper_bgcolor: "#ffffff", plot_bgcolor: "#ffffff", bargap: 0.25,
      xaxis: {tickfont: {size: 11, color: "#52514e"}, showgrid: false, type: "category",
              nticks: 16},
      yaxis: {tickfont: {size: 11, color: "#52514e"}, gridcolor: "#eceae6"},
    },
    config: {displayModeBar: false, responsive: true},
  };
}

function renderTiles(key) {
  const k = WINDOWS[key].kpis;
  const highBaseline = ASSETS.filter(a => a.baseline === "high").length;
  document.getElementById("tiles").innerHTML = [
    ["Window", WINDOWS[key].label],
    ["Fire detections", fmt(k.detections)],
    ["Assets monitored", fmt(ASSETS.length)],
    ["Exposed (fire &le; 10 km)", fmt(k.exposed)],
    ["Near fire (&le; 25 km)", fmt(k.nearby)],
    ["Strongest detection", k.max_frp ? fmt(Math.round(k.max_frp)) + " MW" : "-"],
    ["High-risk (2018-2025)", fmt(highBaseline)],
  ].map(([label, value]) =>
    `<div class="tile"><div class="tile-label">${label}</div>` +
    `<div class="tile-value">${value}</div></div>`).join("");
}

let sortKey = "det10", sortDir = -1;
function renderTable(key) {
  const w = WINDOWS[key];
  const rows = ASSETS
    .map(a => ({...a, ...(w.assets[a.id] || {det10: 0, frp10: 0, days10: 0, nearest: null, status: "clear"})}))
    .filter(r => r.status !== "clear");
  if (!rows.length) {
    document.getElementById("table-holder").innerHTML =
      '<div class="empty">No monitored asset had fire detections within 25 km in this window.</div>';
    return;
  }
  rows.sort((a, b) => {
    const va = a[sortKey] ?? -1, vb = b[sortKey] ?? -1;
    return (va < vb ? -1 : va > vb ? 1 : 0) * sortDir;
  });
  const cols = [
    ["name", "Asset"], ["kind", "Kind"], ["status", "Status"],
    ["det10", "Detections &le;10 km"], ["frp10", "FRP &le;10 km (MW)"],
    ["days10", "Days with fire &le;10 km"], ["nearest", "Nearest (km)"],
    ["baseline", "Historical risk"],
  ];
  const head = cols.map(([id, label]) =>
    `<th data-key="${id}">${label}${sortKey === id ? (sortDir < 0 ? " &#9662;" : " &#9652;") : ""}</th>`).join("");
  const body = rows.map(r => `<tr>
    <td>${r.name}</td><td>${r.kind}</td>
    <td><span class="status status-${r.status}">${r.status}</span></td>
    <td>${fmt(r.det10)}</td><td>${fmt(Math.round(r.frp10))}</td>
    <td>${fmt(r.days10 ?? 0)}</td><td>${r.nearest ?? "-"}</td><td>${r.baseline}</td></tr>`).join("");
  document.getElementById("table-holder").innerHTML =
    `<table><thead><tr>${head}</tr></thead><tbody>${body}</tbody></table>`;
  document.querySelectorAll("th[data-key]").forEach(th => th.onclick = () => {
    const k = th.dataset.key;
    if (sortKey === k) sortDir *= -1; else { sortKey = k; sortDir = -1; }
    renderTable(current());
  });
}

function current() { return document.getElementById("window").value; }

function setWindow(key) {
  document.getElementById("live-badge").style.display = key === "live" ? "" : "none";
  renderTiles(key);
  Plotly.react("map", mapTraces(key), MAP_LAYOUT, {scrollZoom: true, responsive: true});
  const t = trendFigure(key);
  Plotly.react("trend", t.data, t.layout, t.config);
  renderTable(key);
}

const select = document.getElementById("window");
for (const key of Object.keys(WINDOWS)) {
  const opt = document.createElement("option");
  opt.value = key;
  opt.textContent = WINDOWS[key].label;
  select.appendChild(opt);
}
select.addEventListener("change", () => setWindow(current()));

Plotly.newPlot("map", mapTraces("live"), MAP_LAYOUT, {scrollZoom: true, responsive: true});
const t0 = trendFigure("live");
Plotly.newPlot("trend", t0.data, t0.layout, t0.config);
renderTiles("live"); renderTable("live");

Plotly.newPlot("worldmap", [{
  type: "densitymap", lat: WORLD.lat, lon: WORLD.lon, z: WORLD.z,
  radius: 4, colorscale: HEAT_SCALE, zmin: 0, zmax: Math.max(5, quantile(WORLD.z, 0.98)),
  showscale: true, hoverinfo: "skip",
  colorbar: {title: {text: "Detections<br>per ~11 km cell", font: {size: 11}},
             thickness: 12, len: 0.7, outlinewidth: 0},
}], {
  map: {style: "carto-positron", center: {lat: 15, lon: 10}, zoom: 0.7},
  margin: {l: 0, r: 0, t: 0, b: 0}, paper_bgcolor: "#ffffff",
}, {scrollZoom: true, responsive: true});
</script>
</body>
</html>
"""


def render(region: regions.Region, days: int, source: str, out: Path) -> None:
    windows, asset_list, meta = build_data(region, days, source)
    world = world_heat()
    page = (
        PAGE_TEMPLATE
        .replace("__REGION_LABEL__", meta["region_label"])
        .replace("__GENERATED__", meta["generated"])
        .replace("__WINDOWS__", json.dumps(windows, separators=(",", ":")))
        .replace("__ASSETS__", json.dumps(asset_list, separators=(",", ":")))
        .replace("__META__", json.dumps(meta, separators=(",", ":")))
        .replace("__WORLD__", json.dumps(world, separators=(",", ":")))
    )
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(page, encoding="utf-8")
    live = windows["live"]["kpis"]
    print(f"live: {live['detections']:,} detections, {live['exposed']} exposed assets | "
          f"world 24h: {world['detections']:,} detections | "
          f"windows: {', '.join(windows)} -> {out} "
          f"({out.stat().st_size / 1e6:.1f} MB)")


def main() -> None:
    parser = argparse.ArgumentParser(description="Render static wildfire dashboard.")
    parser.add_argument("--region", default="iberia",
                        help=f"{', '.join(regions.REGIONS)} or 'west,south,east,north'")
    parser.add_argument("--days", type=int, default=5, help="NRT window, 1-5 days")
    parser.add_argument("--source", default="VIIRS_SNPP_NRT")
    parser.add_argument("--out", default="site/index.html")
    args = parser.parse_args()
    render(regions.resolve(args.region), args.days, args.source, Path(args.out))


if __name__ == "__main__":
    main()
