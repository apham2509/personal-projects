# data/infrastructure/ - asset lists, one folder per download scope

The dashboard is one unified world view, but asset lists are collected per
scope because their sources differ:

- `world/` - the 1,172 large airports worldwide (OurAirports). No ports:
  OSM's Overpass API cannot answer a planet-scale port query.
- `iberia/` - the regional study's assets, including the 130 commercial
  ports of Spain and Portugal from per-country OSM queries.

At build time `render_static.py` merges the regional port lists into the
world dataset (port ids get a prefix), which is how the dashboard monitors
1,302 assets. Expanding port coverage means adding another regional folder
(`download_infrastructure.py --region greece`), not editing these files.
