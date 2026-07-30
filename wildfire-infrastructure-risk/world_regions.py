"""Geographic divisions for the unified world dashboard.

Two mappings, used together:
  - COUNTRY_REGION: ISO 3166-1 alpha-2 -> region key. Authoritative for
    assets (each asset has a country code).
  - REGION_DEFS: per region, display label, map view, and bounding boxes.
    Fires carry no country, so regional fire counts use these boxes -
    matched in REGION_ORDER, first hit wins. Borders are approximate by
    construction (a bounding box cannot follow a coastline), which the
    dashboard footnotes.
"""

from __future__ import annotations

REGION_DEFS = {
    "europe": {
        "label": "Europe",
        "bboxes": [(-31, 34, 60, 72)],
        "center": {"lat": 52, "lon": 14}, "zoom": 2.6,
    },
    "north-america": {
        "label": "Northern America",
        "bboxes": [(-170, 24, -50, 84)],
        "center": {"lat": 50, "lon": -100}, "zoom": 2.1,
    },
    "central-america-caribbean": {
        "label": "Central America & Caribbean",
        "bboxes": [(-118, 5, -58, 24)],
        "center": {"lat": 17, "lon": -84}, "zoom": 3.2,
    },
    "south-america": {
        "label": "South America",
        "bboxes": [(-92, -56, -32, 13)],
        "center": {"lat": -17, "lon": -60}, "zoom": 2.2,
    },
    "africa": {
        "label": "Africa",
        "bboxes": [(-26, -35, 52, 12), (-26, 12, 34, 38)],
        "center": {"lat": 2, "lon": 20}, "zoom": 2.2,
    },
    "middle-east": {
        "label": "Middle East",
        "bboxes": [(34, 12, 63, 42)],
        "center": {"lat": 29, "lon": 47}, "zoom": 3.0,
    },
    "south-asia": {
        "label": "South Asia",
        "bboxes": [(60, 5, 92, 38)],
        "center": {"lat": 23, "lon": 78}, "zoom": 3.0,
    },
    "southeast-asia": {
        "label": "Southeast Asia",
        "bboxes": [(92, -11, 141, 25)],
        "center": {"lat": 7, "lon": 113}, "zoom": 3.0,
    },
    "east-asia": {
        "label": "East Asia",
        "bboxes": [(87, 18, 146, 54)],
        "center": {"lat": 36, "lon": 115}, "zoom": 2.7,
    },
    "russia-central-asia": {
        "label": "Russia & Central Asia",
        "bboxes": [(46, 38, 180, 82), (-180, 60, -168, 72)],
        "center": {"lat": 60, "lon": 90}, "zoom": 1.8,
    },
    "oceania": {
        "label": "Oceania",
        "bboxes": [(110, -50, 180, 10), (-180, -50, -160, 10)],
        "center": {"lat": -25, "lon": 145}, "zoom": 2.4,
    },
}

# Matching order for fire-to-region attribution (first bbox hit wins).
REGION_ORDER = [
    "europe", "north-america", "central-america-caribbean", "south-america",
    "africa", "middle-east", "south-asia", "southeast-asia", "east-asia",
    "russia-central-asia", "oceania",
]

_GROUPS = {
    "europe": (
        "AD AL AT AX BA BE BG BY CH CY CZ DE DK EE ES FI FO FR GB GG GI GR "
        "HR HU IE IM IS IT JE LI LT LU LV MC MD ME MK MT NL NO PL PT RO RS "
        "SE SI SJ SK SM UA VA XK"
    ),
    "north-america": "BM CA GL PM US",
    "central-america-caribbean": (
        "AG AI AW BB BL BQ BS BZ CR CU CW DM DO GD GP GT HN HT JM KN KY LC "
        "MF MQ MS MX NI PA PR SV SX TC TT VC VG VI"
    ),
    "south-america": "AR BO BR CL CO EC FK GF GY PE PY SR UY VE",
    "africa": (
        "AO BF BI BJ BW CD CF CG CI CM CV DJ DZ EG EH ER ET GA GH GM GN GQ "
        "GW KE KM LR LS LY MA MG ML MR MU MW MZ NA NE NG RE RW SC SD SH SL "
        "SN SO SS ST SZ TD TG TN TZ UG YT ZA ZM ZW"
    ),
    "middle-east": "AE BH IL IQ IR JO KW LB OM PS QA SA SY TR YE",
    "south-asia": "AF BD BT IN LK MV NP PK",
    "southeast-asia": "BN ID KH LA MM MY PH SG TH TL VN",
    "east-asia": "CN HK JP KP KR MN MO TW",
    "russia-central-asia": "AM AZ GE KG KZ RU TJ TM UZ",
    "oceania": (
        "AS AU CK FJ FM GU KI MH MP NC NF NR NU NZ PF PG PN PW SB TK TO TV "
        "UM VU WF WS"
    ),
}

COUNTRY_REGION = {
    code: region for region, codes in _GROUPS.items() for code in codes.split()
}


def client_payload() -> dict:
    """The structures the dashboard JS needs, JSON-ready."""
    return {
        "order": REGION_ORDER,
        "defs": {key: {"label": d["label"], "bboxes": [list(b) for b in d["bboxes"]],
                       "center": d["center"], "zoom": d["zoom"]}
                 for key, d in REGION_DEFS.items()},
        "countryRegion": COUNTRY_REGION,
    }
