# Wildfire Infrastructure Risk Monitor

Which airports, ports and other critical infrastructure are most exposed to active wildfires?

This project combines NASA FIRMS satellite fire detections with public infrastructure locations to quantify wildfire exposure per asset and assign a transparent operational-risk score. It works for any geography (named regions or any bounding box), covers the historical record (2018-2025 by default), and includes both a local interactive dashboard and a daily-refreshed live page published via GitHub Actions + GitHub Pages.

Live dashboard: https://apham2509.github.io/personal-projects/wildfire-infrastructure-risk/

## Data sources

| Source | What | Why |
|--------|------|-----|
| [NASA FIRMS](https://firms.modaps.eosdis.nasa.gov/api/) `VIIRS_SNPP_SP` | Satellite fire/thermal-anomaly detections at ~375 m resolution, from 2012 onward | Standard-processing archive is consistently calibrated, which NASA recommends over the NRT feed for analysis |
| [NASA FIRMS](https://firms.modaps.eosdis.nasa.gov/api/) `VIIRS_SNPP_NRT` | Same instrument, near-real-time (last ~2 months) | Powers the daily live dashboard |
| [OurAirports](https://ourairports.com/data/) | Airport locations and classifications (public domain, global) | Large + medium airports |
| OpenStreetMap (Overpass API) | Named harbours and port areas | Port locations (leisure marinas excluded) |

Each FIRMS record includes latitude/longitude, acquisition date and UTC time, detection confidence (l/n/h), fire radiative power (FRP, in MW - a proxy for fire intensity), brightness temperatures, satellite, day/night flag, and a detection type (vegetation fire vs. static land source).

## Geography

Analyses run per region. Built-in regions: `world`, `iberia`, `greece`, `mediterranean`, `europe`, `california`, `north-america`, `south-america`, `africa`, `australia`, `southeast-asia`, `vietnam`, `india`, `siberia` - or pass any bounding box as `"west,south,east,north"`. Regions defined with country codes (iberia, greece, australia, vietnam, india) filter infrastructure to those countries; ports are skipped for continent-scale regions (the Overpass query would time out) while airports work globally.

Outputs are stored per region: `data/fires/<region>/`, `data/infrastructure/<region>/assets.csv`, `results/asset_risk_<region>.csv`.

## How to run the whole thing

```bash
# 0. Setup (once)
cd wildfire-infrastructure-risk
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
# the FIRMS MAP_KEY is read from map_key.txt (get your own free key at
# https://firms.modaps.eosdis.nasa.gov/api/map_key - limit 5,000 requests / 10 min)

# 1. Download historical fire detections (resumable; ~600 API calls, ~20 min)
.venv/bin/python download_fires.py --region iberia --start 2018 --end 2025

# 2. Download infrastructure assets (airports + ports)
.venv/bin/python download_infrastructure.py --region iberia

# 3. Compute exposure metrics and risk scores
.venv/bin/python risk_analysis.py --region iberia

# 4. Aggregate the archive into daily data for the web dashboard (commit the JSON)
.venv/bin/python prepare_history.py --region iberia

# 5a. Interactive dashboard (local Dash app) -> http://127.0.0.1:8050
.venv/bin/python dashboard.py --region iberia

# 5b. Static web dashboard (archive + live NRT, date-range picker) -> site/
.venv/bin/python render_static.py --regions iberia
```

To study another geography, repeat steps 1-4 with a different `--region` (e.g. `--region greece`, or `--region "20.0,35.0,30.0,42.0"`).

## Daily automation

`.github/workflows/update-dashboard.yml` runs every morning (05:30 UTC) on GitHub Actions: it pulls the last 5 days of near-real-time detections, recomputes which assets are currently exposed (against the committed historical baseline in `results/`), renders the static dashboard and deploys it to GitHub Pages. It can also be triggered manually from the Actions tab.

## Metrics and risk score

Per asset and radius (default 5/10/25 km): detection counts, high-confidence counts, total and maximum FRP, distance to the nearest detection, distinct exposure days within 10 km, the longest streak of consecutive exposure days, and the most recent exposure date.

The risk score is deliberately simple and explainable:

```
score = 0.5  * percentile(days_exposed_10km)     # chronic exposure
      + 0.35 * percentile(total_frp_10km)        # cumulative intensity
      + 0.15 * proximity_factor(nearest_km)      # 1.0 (<5km) / 0.6 (<10km) / 0.3 (<25km) / 0
```

with `high >= 0.70`, `medium >= 0.40`, `low` otherwise. Percentiles are computed across the asset set, so the score ranks assets against their regional peers.

## Key results (Iberia, 2018-2025)

161,129 vegetation-fire detections analysed against 198 assets (68 airports, 130 ports): 71 assets score high-risk. The most exposed are Reus Airport and the Port of Tarragona (Catalonia), the Huelva and Algeciras port clusters, Seville Airport, and northern-Portugal airfields - consistent with the major Iberian fire seasons of 2022 and 2025.

## Caveats

- A FIRMS detection is a satellite pixel flagged as a thermal anomaly. The analysis keeps only `type = 0` (presumed vegetation fire) by default, which removes persistent industrial heat sources - in the 2022 data, the port of Gijón showed 180 "exposure days" that were actually the neighbouring steelworks, all tagged `type = 2` and correctly dropped by the filter. Use `--include-all-types` to keep everything, and `--high-confidence-only` to tighten further.
- Proximity is measured to asset point coordinates, not asset polygons.
- Cloud cover can hide fires from the satellite; absence of detections is not proof of absence of fire.

## Roadmap

- Major roads via Geofabrik OSM extracts and buffered line geometries (geopandas)
- NASA GPM IMERG precipitation to test whether recent rainfall is associated with lower fire activity
- SQL modelling of the pipeline outputs (staging -> marts)
