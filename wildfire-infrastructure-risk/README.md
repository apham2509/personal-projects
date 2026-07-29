# Wildfire Infrastructure Risk Monitor

Which airports, ports and other critical infrastructure in Spain and Portugal are most exposed to active wildfires?

This project combines NASA FIRMS satellite fire detections with public infrastructure locations to quantify wildfire exposure per asset and assign a simple operational-risk score. Version 1 covers the historical record (2018-2025); a live monitoring mode on the near-real-time feed is on the roadmap.

## Data sources

| Source | What | Why |
|--------|------|-----|
| [NASA FIRMS](https://firms.modaps.eosdis.nasa.gov/api/) `VIIRS_SNPP_SP` | Satellite fire/thermal-anomaly detections at ~375 m resolution, from 2012 onward | Standard-processing archive is consistently calibrated, which NASA recommends over the NRT feed for analysis |
| [OurAirports](https://ourairports.com/data/) | Airport locations and classifications (public domain) | Large + medium airports in ES/PT |
| OpenStreetMap (Overpass API) | Named harbours and port areas | Port locations in ES/PT |

Each FIRMS record includes latitude/longitude, acquisition date and UTC time, detection confidence (l/n/h), fire radiative power (FRP, in MW - a proxy for fire intensity), brightness temperatures, satellite, and a day/night flag.

## Scope (v1)

- Period: 2018-2025
- Geography: mainland Spain and Portugal (bounding box -10.0,35.9,4.5,44.0)
- Fire source: VIIRS_SNPP_SP
- Infrastructure: large/medium airports and named ports
- Risk radii: 5, 10 and 25 km around each asset

## Setup

```bash
pip install -r requirements.txt
```

## Pipeline

```bash
# 1. Fire detections, year by year (resumable; ~600 API calls for 2018-2025)
python download_fires.py

# 2. Infrastructure assets (airports + ports)
python download_infrastructure.py

# 3. Exposure metrics and risk scores per asset
python risk_analysis.py
```


## Metrics and risk score

Per asset and radius: detection counts, high-confidence counts, total and maximum FRP, distance to the nearest detection, distinct exposure days within 10 km, the longest streak of consecutive exposure days, and the most recent exposure date.

The v1 risk score is deliberately simple and explainable:

```
score = 0.5  * percentile(days_exposed_10km)     # chronic exposure
      + 0.35 * percentile(total_frp_10km)        # cumulative intensity
      + 0.15 * proximity_factor(nearest_km)      # 1.0 (<5km) / 0.6 (<10km) / 0.3 (<25km) / 0
```

with `high >= 0.70`, `medium >= 0.40`, `low` otherwise. Percentiles are computed across the asset set, so the score ranks assets against their Iberian peers.

## Caveats

- A FIRMS detection is a satellite pixel flagged as a thermal anomaly. The analysis keeps only `type = 0` (presumed vegetation fire) by default, which removes persistent industrial heat sources - in the 2022 test data, the port of Gijón showed 180 "exposure days" that were actually the neighbouring steelworks, all tagged `type = 2` and correctly dropped by the filter. Use `--include-all-types` to keep everything, and `--high-confidence-only` to tighten further.
- Proximity is measured to asset point coordinates, not asset polygons.
- Cloud cover can hide fires from the satellite; absence of detections is not proof of absence of fire.

## Roadmap

- Live mode: same metrics on `VIIRS_SNPP_NRT` / `VIIRS_NOAA20_NRT` for the last 1-5 days, refreshed on a schedule
- Major roads via Geofabrik OSM extracts and buffered line geometries (geopandas)
- NASA GPM IMERG precipitation to test whether recent rainfall is associated with lower fire activity
- SQL modelling of the pipeline outputs (staging -> marts) and a dashboard on top
