# Wildfire Tracker

Pull near-real-time satellite fire detections from the [NASA FIRMS API](https://firms.modaps.eosdis.nasa.gov/api/) — as a pandas DataFrame, a CSV export, or a quick map.

FIRMS (Fire Information for Resource Management System) publishes hotspot detections from the VIIRS, MODIS, Landsat and GOES instruments, updated multiple times per day, with archives going back to 2000.

## Setup

```bash
pip install -r requirements.txt
cp .env.example .env   # then paste your MAP_KEY into .env
```

Get a free MAP_KEY at https://firms.modaps.eosdis.nasa.gov/api/map_key (rate limit: 5,000 requests / 10 min).

## Usage

```bash
# Fire detections in Finland over the last 3 days
python fetch_fires.py --region finland --days 3

# California, last week: save CSV + map
python fetch_fires.py --region california --days 7 --out fires.csv --plot fires.png

# Any bounding box (west,south,east,north) and any dataset
python fetch_fires.py --region "102.0,8.0,110.0,23.5" --source VIIRS_SNPP_NRT

# Historical query (standard-processing archive)
python fetch_fires.py --region australia --source MODIS_SP --days 10 --date 2020-01-01

# Check your API quota
python fetch_fires.py --status
```

Named regions: `world`, `finland`, `nordics`, `europe`, `mediterranean`, `california`, `australia`, `amazon`, `vietnam`, `siberia`.

Or use it as a library:

```python
import firms_client as firms

df = firms.area_fires(region="europe", source="VIIRS_NOAA20_NRT", days=2)
firms.data_availability()   # date ranges per dataset
firms.key_status()          # quota usage
```

## Output columns

Each row is one satellite detection: `latitude`/`longitude`, `acq_datetime` (UTC), `frp` (fire radiative power, MW — a proxy for fire intensity), `confidence` (l/n/h), `brightness`, `satellite`, `daynight`.

## Notes

- `*_NRT` datasets are near-real-time (last ~2 months); `*_SP` are the calibrated standard-processing archives (MODIS back to 2000, VIIRS to 2012) — better for historical analysis.
- The API's country endpoints are currently disabled server-side; this tool uses the area endpoint with bounding boxes instead.
- A detection is a satellite pixel flagged as thermal anomaly — usually wildfire, but also industrial flares, volcanoes, or agricultural burns.
