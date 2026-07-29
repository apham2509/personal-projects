"""Render the live wildfire dashboard as a static HTML page.

Pulls the most recent near-real-time fire detections (last 1-5 days), checks
which infrastructure assets are currently exposed, and writes a single
self-contained HTML file (plotly keeps the map and charts interactive).
Designed to run daily in CI and publish to GitHub Pages; works locally too.

Usage:
    python render_static.py                       # iberia, last 5 days -> site/index.html
    python render_static.py --region greece --days 3 --out site/index.html
"""

from __future__ import annotations

import argparse
import datetime as dt
import html as html_escape
from pathlib import Path

import pandas as pd
import plotly.graph_objects as go

import firms
import regions
from risk_analysis import haversine_km

SURFACE = "#fcfcfb"
TEXT_PRIMARY = "#0b0b0b"
TEXT_SECONDARY = "#52514e"
BORDER = "#e6e5e1"
# Status colors (reference palette): current exposure state, always shown
# with a text label - never color alone.
COLOR_EXPOSED = "#d03b3b"    # detection within 10 km
COLOR_NEARBY = "#fab219"     # detection within 25 km
COLOR_CLEAR = "#8a8983"      # no detection nearby
BAR_COLOR = "#2a78d6"
HEAT_SCALE = [
    [0.0, "rgba(255,245,235,0)"], [0.2, "#fdd0a2"], [0.4, "#fdae6b"],
    [0.6, "#f16913"], [0.8, "#d94801"], [1.0, "#7f2704"],
]


def current_exposure(assets: pd.DataFrame, fires: pd.DataFrame) -> pd.DataFrame:
    rows = []
    fire_lat = fires["latitude"].to_numpy()
    fire_lon = fires["longitude"].to_numpy()
    frp = fires["frp"].fillna(0).to_numpy() if len(fires) else None
    for asset in assets.itertuples(index=False):
        row = {"asset_id": asset.asset_id, "name": asset.name, "kind": asset.kind,
               "latitude": asset.latitude, "longitude": asset.longitude,
               "detections_10km": 0, "detections_25km": 0,
               "total_frp_10km": 0.0, "nearest_km": float("nan"), "status": "clear"}
        if len(fires):
            dist = haversine_km(asset.latitude, asset.longitude, fire_lat, fire_lon)
            within10, within25 = dist <= 10, dist <= 25
            row.update(
                detections_10km=int(within10.sum()),
                detections_25km=int(within25.sum()),
                total_frp_10km=round(float(frp[within10].sum()), 1),
                nearest_km=round(float(dist.min()), 1),
            )
            row["status"] = ("exposed" if within10.any()
                             else "nearby" if within25.any() else "clear")
        rows.append(row)
    return pd.DataFrame(rows)


def make_map(exposure: pd.DataFrame, fires: pd.DataFrame, region: regions.Region) -> go.Figure:
    if len(fires):
        center = {"lat": fires["latitude"].mean(), "lon": fires["longitude"].mean()}
    else:
        center = {"lat": exposure["latitude"].mean(), "lon": exposure["longitude"].mean()}
    width = abs(region.bounds[2] - region.bounds[0])
    zoom = 1.2 if width >= 300 else 2.5 if width >= 100 else 3.5 if width >= 40 else 4.6 if width >= 20 else 5.2

    fig = go.Figure()
    if len(fires):
        fig.add_trace(go.Densitymap(
            lat=fires["latitude"], lon=fires["longitude"], z=fires["frp"].clip(upper=50),
            radius=8, colorscale=HEAT_SCALE, showscale=False, hoverinfo="skip",
            name="Fire detections",
        ))
    styles = {
        "exposed": ("Exposed - fire within 10 km", COLOR_EXPOSED, 14),
        "nearby": ("Fire within 25 km", COLOR_NEARBY, 11),
        "clear": ("No fire nearby", COLOR_CLEAR, 7),
    }
    for status, (label, color, size) in styles.items():
        sub = exposure[exposure["status"] == status]
        if sub.empty:
            continue
        fig.add_trace(go.Scattermap(
            lat=sub["latitude"], lon=sub["longitude"], mode="markers",
            marker={"size": size, "color": color},
            name=f"{label} ({len(sub)})",
            customdata=sub[["name", "kind", "detections_10km", "total_frp_10km",
                            "nearest_km", "baseline_risk"]].values,
            hovertemplate=(
                "<b>%{customdata[0]}</b> (%{customdata[1]})<br>"
                "Detections within 10 km: %{customdata[2]}<br>"
                "FRP within 10 km: %{customdata[3]:,.0f} MW<br>"
                "Nearest detection: %{customdata[4]} km<br>"
                "Historical risk level: %{customdata[5]}"
                "<extra></extra>"
            ),
        ))
    fig.update_layout(
        map={"style": "carto-positron", "center": center, "zoom": zoom},
        margin={"l": 0, "r": 0, "t": 0, "b": 0}, height=540, paper_bgcolor=SURFACE,
        legend={"x": 0.01, "y": 0.99, "bgcolor": "rgba(255,255,255,0.88)",
                "font": {"color": TEXT_PRIMARY}},
    )
    return fig


def make_daily_chart(fires: pd.DataFrame) -> go.Figure:
    daily = fires.groupby(fires["acq_datetime"].dt.date).size()
    fig = go.Figure(go.Bar(
        x=[d.isoformat() for d in daily.index], y=daily.values,
        marker={"color": BAR_COLOR, "cornerradius": 4},
        hovertemplate="%{x}: %{y:,} detections<extra></extra>",
    ))
    fig.update_layout(
        title={"text": "Detections per day (current window)",
               "font": {"color": TEXT_PRIMARY, "size": 15}},
        height=240, margin={"l": 50, "r": 20, "t": 45, "b": 40},
        paper_bgcolor=SURFACE, plot_bgcolor=SURFACE,
        xaxis={"tickfont": {"color": TEXT_SECONDARY}, "showgrid": False, "type": "category"},
        yaxis={"tickfont": {"color": TEXT_SECONDARY}, "gridcolor": "#eceae6"},
        bargap=0.3,
    )
    return fig


def tile(label: str, value: str) -> str:
    return (f'<div class="tile"><div class="tile-label">{label}</div>'
            f'<div class="tile-value">{value}</div></div>')


def table_html(df: pd.DataFrame, columns: dict) -> str:
    head = "".join(f"<th>{title}</th>" for title in columns.values())
    body = ""
    for row in df.itertuples(index=False):
        cells = "".join(
            f"<td>{html_escape.escape(str(getattr(row, col)))}</td>" for col in columns
        )
        body += f"<tr>{cells}</tr>"
    return f'<table><thead><tr>{head}</tr></thead><tbody>{body}</tbody></table>'


def render(region: regions.Region, days: int, source: str, out: Path) -> None:
    fires = firms.area_fires(source=source, bbox=region.bbox, days=days)
    assets = pd.read_csv(f"data/infrastructure/{region.slug}/assets.csv")

    baseline_path = Path(f"results/asset_risk_{region.slug}.csv")
    if baseline_path.is_file():
        baseline = pd.read_csv(baseline_path)[["asset_id", "risk_level"]]
        baseline.columns = ["asset_id", "baseline_risk"]
    else:
        baseline = pd.DataFrame({"asset_id": assets["asset_id"], "baseline_risk": "n/a"})

    exposure = current_exposure(assets, fires).merge(baseline, on="asset_id", how="left")
    exposure["baseline_risk"] = exposure["baseline_risk"].fillna("n/a")

    exposed = exposure[exposure["status"] != "clear"].sort_values(
        ["detections_10km", "total_frp_10km"], ascending=False
    )
    now = dt.datetime.now(dt.timezone.utc)
    if len(fires):
        window = f"{fires['acq_datetime'].min():%Y-%m-%d} to {fires['acq_datetime'].max():%Y-%m-%d} UTC"
    else:
        window = f"last {days} day(s) - no detections"

    tiles = "".join([
        tile("Fire detections", f"{len(fires):,}"),
        tile("Data window", window),
        tile("Assets monitored", f"{len(assets)}"),
        tile("Exposed (fire &le; 10 km)", f"{(exposure['status'] == 'exposed').sum()}"),
        tile("Near fire (&le; 25 km)", f"{(exposure['status'] == 'nearby').sum()}"),
        tile("Strongest detection", f"{fires['frp'].max():,.0f} MW" if len(fires) else "-"),
    ])

    map_html = make_map(exposure, fires, region).to_html(
        full_html=False, include_plotlyjs="cdn", config={"scrollZoom": True})
    daily_html = (make_daily_chart(fires).to_html(full_html=False, include_plotlyjs=False)
                  if len(fires) else "")

    if exposed.empty:
        exposed_html = "<p>No monitored asset currently has fire detections within 25 km.</p>"
    else:
        exposed_html = table_html(exposed, {
            "name": "Asset", "kind": "Kind", "status": "Status",
            "detections_10km": "Detections &le;10 km", "total_frp_10km": "FRP &le;10 km (MW)",
            "nearest_km": "Nearest (km)", "baseline_risk": "Historical risk",
        })

    top_hist = exposure.sort_values("baseline_risk").query("baseline_risk == 'high'")
    hist_note = (f"{len(top_hist)} assets are rated high-risk on the 2018-2025 "
                 "historical record (see repository for the full analysis).")

    page = f"""<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Wildfire Infrastructure Risk - {region.slug}</title>
<style>
  body {{ background: {SURFACE}; color: {TEXT_PRIMARY}; font-family: system-ui, sans-serif;
         max-width: 1150px; margin: 0 auto; padding: 24px; }}
  h1 {{ font-size: 24px; margin-bottom: 2px; }}
  .subtitle {{ color: {TEXT_SECONDARY}; margin-bottom: 18px; }}
  .tiles {{ display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 18px; }}
  .tile {{ flex: 1; min-width: 150px; background: white; border: 1px solid {BORDER};
           border-radius: 10px; padding: 13px 16px; }}
  .tile-label {{ font-size: 12px; color: {TEXT_SECONDARY}; }}
  .tile-value {{ font-size: 21px; font-weight: 600; }}
  table {{ border-collapse: collapse; width: 100%; font-size: 13px; margin-bottom: 18px; }}
  th, td {{ text-align: left; padding: 6px 10px; border-bottom: 1px solid {BORDER}; }}
  th {{ background: #f2f1ed; }}
  h3 {{ margin: 22px 0 8px; }}
  footer {{ color: {TEXT_SECONDARY}; font-size: 12px; margin-top: 24px; }}
</style></head><body>
<h1>Wildfire Infrastructure Risk Monitor - {region.slug}</h1>
<div class="subtitle">Satellite fire detections ({source}) vs. airports and ports.
Updated {now:%Y-%m-%d %H:%M} UTC - refreshed daily.</div>
<div class="tiles">{tiles}</div>
{map_html}
{daily_html}
<h3>Assets with fire activity nearby</h3>
{exposed_html}
<p>{hist_note}</p>
<footer>Data: NASA FIRMS (VIIRS 375 m active fire), OurAirports, OpenStreetMap contributors.
A detection is a satellite thermal anomaly; cloud cover can hide fires.
Built with Python and Plotly - source in the repository.</footer>
</body></html>"""

    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(page, encoding="utf-8")
    print(f"{len(fires):,} detections, {(exposure['status'] == 'exposed').sum()} exposed assets "
          f"-> {out}")


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
