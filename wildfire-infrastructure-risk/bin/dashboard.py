"""Interactive dashboard for the Wildfire Infrastructure Risk Monitor.

Shows, for one region:
  - key results as stat tiles (detections, assets, high-risk counts, FRP)
  - a fire-detection density heatmap with infrastructure assets overlaid,
    colored by risk level
  - monthly detection counts (fire seasonality)
  - a sortable table of the most exposed assets

Run risk_analysis.py first, then:
    python dashboard.py                   # iberia, http://127.0.0.1:8050
    python dashboard.py --region greece --port 8060
"""

from __future__ import annotations

import argparse
import glob
from pathlib import Path

import pandas as pd
import plotly.graph_objects as go
from dash import Dash, dash_table, dcc, html
from dash.dependencies import Input, Output

import regions

# Colors follow the reference dataviz palette: status colors for risk levels
# (always paired with labels - never color alone), a single-hue sequential
# ramp for the density heatmap, categorical slot 1 for the single-series bars.
SURFACE = "#fcfcfb"
TEXT_PRIMARY = "#0b0b0b"
TEXT_SECONDARY = "#52514e"
RISK_COLORS = {"high": "#d03b3b", "medium": "#fab219", "low": "#0ca30c"}
BAR_COLOR = "#2a78d6"
HEAT_SCALE = [
    [0.0, "rgba(255,245,235,0)"], [0.2, "#fdd0a2"], [0.4, "#fdae6b"],
    [0.6, "#f16913"], [0.8, "#d94801"], [1.0, "#7f2704"],
]

TILE_STYLE = {
    "flex": "1", "padding": "14px 18px", "borderRadius": "10px",
    "backgroundColor": "white", "border": f"1px solid #e6e5e1",
}


def load_data(region: regions.Region, results_path: str, fires_dir: str):
    risk = pd.read_csv(results_path)
    files = sorted(glob.glob(str(Path(fires_dir) / "*.csv.gz")))
    if not files:
        raise SystemExit(f"No fire files in {fires_dir}. Run download_fires.py first.")
    fires = pd.concat((pd.read_csv(f) for f in files), ignore_index=True)
    if "type" in fires.columns:
        fires = fires[fires["type"] == 0]  # vegetation fires, as in the analysis
    fires["acq_date"] = pd.to_datetime(fires["acq_date"])
    return risk, fires


def zoom_for(region: regions.Region) -> float:
    width = abs(region.bounds[2] - region.bounds[0])
    if width >= 300: return 1.2
    if width >= 100: return 2.5
    if width >= 40: return 3.5
    if width >= 20: return 4.6
    return 5.2


def make_map(risk: pd.DataFrame, fires: pd.DataFrame, region: regions.Region) -> go.Figure:
    center = {"lat": fires["latitude"].mean(), "lon": fires["longitude"].mean()}
    fig = go.Figure()
    fig.add_trace(go.Densitymap(
        lat=fires["latitude"], lon=fires["longitude"], z=fires["frp"].clip(upper=50),
        radius=5, colorscale=HEAT_SCALE, showscale=False,
        hoverinfo="skip", name="Fire detections",
    ))
    for level in ["high", "medium", "low"]:
        sub = risk[risk["risk_level"] == level]
        fig.add_trace(go.Scattermap(
            lat=sub["latitude"], lon=sub["longitude"],
            mode="markers",
            marker={"size": 10 + 8 * sub["risk_score"], "color": RISK_COLORS[level]},
            name=f"{level.capitalize()} risk ({len(sub)})",
            customdata=sub[["name", "kind", "risk_score", "days_exposed_10km",
                            "nearest_km", "total_frp_10km"]].values,
            hovertemplate=(
                "<b>%{customdata[0]}</b> (%{customdata[1]})<br>"
                f"Risk: {level} " + "(score %{customdata[2]:.2f})<br>"
                "Days exposed within 10 km: %{customdata[3]}<br>"
                "Nearest detection: %{customdata[4]:.1f} km<br>"
                "Total FRP within 10 km: %{customdata[5]:,.0f} MW"
                "<extra></extra>"
            ),
        ))
    fig.update_layout(
        map={"style": "carto-positron", "center": center, "zoom": zoom_for(region)},
        margin={"l": 0, "r": 0, "t": 0, "b": 0}, height=560,
        paper_bgcolor=SURFACE,
        legend={"x": 0.01, "y": 0.99, "bgcolor": "rgba(255,255,255,0.85)",
                "font": {"color": TEXT_PRIMARY}},
    )
    return fig


def make_monthly_chart(fires: pd.DataFrame) -> go.Figure:
    monthly = fires.groupby(fires["acq_date"].dt.to_period("M")).size()
    fig = go.Figure(go.Bar(
        x=monthly.index.astype(str), y=monthly.values,
        marker={"color": BAR_COLOR, "cornerradius": 4},
        hovertemplate="%{x}: %{y:,} detections<extra></extra>",
    ))
    fig.update_layout(
        title={"text": "Fire detections per month", "font": {"color": TEXT_PRIMARY, "size": 15}},
        height=260, margin={"l": 50, "r": 20, "t": 45, "b": 40},
        paper_bgcolor=SURFACE, plot_bgcolor=SURFACE,
        xaxis={"tickfont": {"color": TEXT_SECONDARY}, "showgrid": False},
        yaxis={"tickfont": {"color": TEXT_SECONDARY}, "gridcolor": "#eceae6"},
        bargap=0.25,
    )
    return fig


def tile(label: str, value: str) -> html.Div:
    return html.Div([
        html.Div(label, style={"fontSize": "12px", "color": TEXT_SECONDARY}),
        html.Div(value, style={"fontSize": "24px", "fontWeight": "600", "color": TEXT_PRIMARY}),
    ], style=TILE_STYLE)


def build_app(region: regions.Region, risk: pd.DataFrame, fires: pd.DataFrame) -> Dash:
    app = Dash(__name__, title=f"Wildfire Risk - {region.slug}")
    period = f"{fires['acq_date'].min():%Y-%m-%d} to {fires['acq_date'].max():%Y-%m-%d}"

    table_columns = [
        {"name": "Asset", "id": "name"}, {"name": "Kind", "id": "kind"},
        {"name": "Risk", "id": "risk_level"}, {"name": "Score", "id": "risk_score"},
        {"name": "Days exposed (10 km)", "id": "days_exposed_10km"},
        {"name": "Max streak (days)", "id": "max_consecutive_days_10km"},
        {"name": "Total FRP 10 km (MW)", "id": "total_frp_10km"},
        {"name": "Nearest fire (km)", "id": "nearest_km"},
        {"name": "Last exposure", "id": "last_exposure_10km"},
    ]

    app.layout = html.Div(style={
        "backgroundColor": SURFACE, "fontFamily": "system-ui, sans-serif",
        "padding": "24px", "maxWidth": "1200px", "margin": "0 auto",
    }, children=[
        html.H2(f"Wildfire Infrastructure Risk Monitor - {region.slug}",
                style={"color": TEXT_PRIMARY, "marginBottom": "2px"}),
        html.Div(f"NASA FIRMS VIIRS vegetation-fire detections, {period}",
                 style={"color": TEXT_SECONDARY, "marginBottom": "18px"}),

        html.Div(style={"display": "flex", "gap": "12px", "marginBottom": "18px"}, children=[
            tile("Fire detections", f"{len(fires):,}"),
            tile("Assets analysed", f"{len(risk):,}"),
            tile("High-risk assets", f"{(risk['risk_level'] == 'high').sum()}"),
            tile("Longest exposure streak", f"{risk['max_consecutive_days_10km'].max()} days"),
            tile("Strongest detection", f"{fires['frp'].max():,.0f} MW"),
        ]),

        html.Div(style={"display": "flex", "gap": "12px", "marginBottom": "12px"}, children=[
            dcc.Dropdown(id="kind-filter", value="all", clearable=False,
                         style={"width": "220px"},
                         options=[{"label": "All asset types", "value": "all"}]
                         + [{"label": k.capitalize() + "s", "value": k}
                            for k in sorted(risk["kind"].unique())]),
            dcc.Dropdown(id="risk-filter", value="all", clearable=False,
                         style={"width": "220px"},
                         options=[{"label": "All risk levels", "value": "all"},
                                  {"label": "High", "value": "high"},
                                  {"label": "Medium", "value": "medium"},
                                  {"label": "Low", "value": "low"}]),
        ]),

        dcc.Graph(id="risk-map", config={"scrollZoom": True}),
        dcc.Graph(figure=make_monthly_chart(fires), config={"displayModeBar": False}),

        html.H4("Most exposed assets", style={"color": TEXT_PRIMARY, "marginBottom": "6px"}),
        dash_table.DataTable(
            id="risk-table", columns=table_columns, page_size=15,
            sort_action="native", filter_action="native",
            style_table={"overflowX": "auto"},
            style_cell={"fontFamily": "system-ui, sans-serif", "fontSize": "13px",
                        "padding": "6px 10px", "color": TEXT_PRIMARY},
            style_header={"fontWeight": "600", "backgroundColor": "#f2f1ed"},
        ),
    ])

    @app.callback(
        Output("risk-map", "figure"), Output("risk-table", "data"),
        Input("kind-filter", "value"), Input("risk-filter", "value"),
    )
    def update(kind: str, level: str):
        view = risk
        if kind != "all":
            view = view[view["kind"] == kind]
        if level != "all":
            view = view[view["risk_level"] == level]
        table_data = view.sort_values("risk_score", ascending=False).to_dict("records")
        return make_map(view, fires, region), table_data

    return app


def main() -> None:
    parser = argparse.ArgumentParser(description="Wildfire risk dashboard.")
    parser.add_argument("--region", default="iberia",
                        help=f"{', '.join(regions.REGIONS)} or 'west,south,east,north'")
    parser.add_argument("--results", default=None, help="Default: results/asset_risk_<region>.csv")
    parser.add_argument("--fires-dir", default=None, help="Default: data/fires/<region>")
    parser.add_argument("--port", type=int, default=8050)
    args = parser.parse_args()

    region = regions.resolve(args.region)
    results_path = args.results or f"results/asset_risk_{region.slug}.csv"
    fires_dir = args.fires_dir or f"data/fires/{region.slug}"
    if not Path(results_path).is_file():
        raise SystemExit(f"{results_path} not found. Run risk_analysis.py --region {region.slug} first.")

    risk, fires = load_data(region, results_path, fires_dir)
    app = build_app(region, risk, fires)
    print(f"Dashboard: http://127.0.0.1:{args.port}")
    app.run(debug=False, port=args.port)


if __name__ == "__main__":
    main()
