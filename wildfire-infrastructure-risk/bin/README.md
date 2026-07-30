# bin/ - retired code

Kept for reference; nothing in the live pipeline imports from here
(git history also preserves everything).

- `dashboard.py` - the original local Dash app (superseded by the static
  web dashboard that render_static.py builds). To run it anyway:
  `pip install dash plotly`, download a regional fire archive
  (e.g. `python download_fires.py --region iberia`), then
  `python bin/dashboard.py --region iberia` from the project root.
