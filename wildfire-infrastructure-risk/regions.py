"""Named study regions for the Wildfire Infrastructure Risk Monitor.

A region is a bounding box (west, south, east, north) plus an optional list
of ISO country codes used to filter infrastructure to specific countries
(fire detections are always fetched by bounding box).

Any script that takes --region also accepts a raw bounding box string
"west,south,east,north"; its outputs are then stored under the slug "custom".
"""

from __future__ import annotations

from typing import NamedTuple


class Region(NamedTuple):
    slug: str
    bbox: str                      # "west,south,east,north" or "world"
    bounds: tuple                  # (west, south, east, north) as floats
    countries: list | None         # ISO 3166-1 alpha-2, or None = no filter


def _make(slug: str, bbox: str, countries: list | None = None) -> Region:
    if bbox == "world":
        bounds = (-180.0, -90.0, 180.0, 90.0)
    else:
        west, south, east, north = (float(x) for x in bbox.split(","))
        bounds = (west, south, east, north)
    return Region(slug, bbox, bounds, countries)


REGIONS = {
    "world": _make("world", "world"),
    "iberia": _make("iberia", "-10.0,35.9,4.5,44.0", ["ES", "PT"]),
    "greece": _make("greece", "19.0,34.5,28.5,42.0", ["GR"]),
    "mediterranean": _make("mediterranean", "-10.0,30.0,37.0,47.0"),
    "europe": _make("europe", "-11.0,35.0,40.0,72.0"),
    "california": _make("california", "-125.0,32.0,-113.0,42.5"),
    "north-america": _make("north-america", "-170.0,15.0,-50.0,72.0"),
    "south-america": _make("south-america", "-82.0,-56.0,-34.0,13.0"),
    "africa": _make("africa", "-18.0,-35.0,52.0,38.0"),
    "australia": _make("australia", "112.0,-44.0,154.0,-10.0", ["AU"]),
    "southeast-asia": _make("southeast-asia", "92.0,-11.0,141.0,29.0"),
    "vietnam": _make("vietnam", "102.0,8.0,110.0,23.5", ["VN"]),
    "india": _make("india", "68.0,6.0,98.0,36.0", ["IN"]),
    "siberia": _make("siberia", "60.0,50.0,180.0,75.0"),
}


def resolve(region: str) -> Region:
    """Return the Region for a name from REGIONS or a raw bbox string."""
    key = region.lower().strip()
    if key in REGIONS:
        return REGIONS[key]
    try:
        return _make("custom", region)
    except ValueError:
        raise SystemExit(
            f"Unknown region {region!r}. Use one of: {', '.join(REGIONS)} "
            "or a bounding box 'west,south,east,north'."
        )


def area_sq_degrees(region: Region) -> float:
    west, south, east, north = region.bounds
    return abs(east - west) * abs(north - south)
