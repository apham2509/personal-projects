"""CLI for pulling NASA FIRMS fire detections: summary, CSV export, and map plot.

Examples:
    python fetch_fires.py --region finland --days 3
    python fetch_fires.py --region california --days 7 --out fires.csv --plot fires.png
    python fetch_fires.py --region "19.0,59.5,31.6,70.1" --source VIIRS_SNPP_NRT
    python fetch_fires.py --status
"""

from __future__ import annotations

import argparse
import sys

import pandas as pd

import firms_client as firms


def summarize(df, region: str, source: str, days: int) -> None:
    print(f"\n{'=' * 56}")
    print(f"FIRMS detections | region={region} source={source} days={days}")
    print(f"{'=' * 56}")
    if df.empty:
        print("No fire detections found.")
        return
    print(f"Detections:       {len(df):,}")
    print(f"Period (UTC):     {df['acq_datetime'].min()} -> {df['acq_datetime'].max()}")
    if "confidence" in df.columns:
        conf = df["confidence"].astype(str).str.lower()
        high = (conf.isin(["h", "high"]) | (conf.str.isdigit() & (pd.to_numeric(conf, errors="coerce") >= 80))).sum()
        print(f"High confidence:  {high:,} ({high / len(df):.0%})")
    if "frp" in df.columns:
        print(f"Fire radiative power: total {df['frp'].sum():,.0f} MW · max {df['frp'].max():,.1f} MW")
        print("\nStrongest detections (by FRP):")
        cols = [c for c in ["acq_datetime", "latitude", "longitude", "frp", "confidence", "satellite"] if c in df.columns]
        print(df.nlargest(5, "frp")[cols].to_string(index=False))


def plot(df, path: str, region: str, days: int) -> None:
    import matplotlib

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    fig, ax = plt.subplots(figsize=(9, 7))
    sizes = 8 + 40 * (df["frp"] / max(df["frp"].max(), 1)) if "frp" in df.columns else 12
    scatter = ax.scatter(
        df["longitude"], df["latitude"],
        c=df["frp"] if "frp" in df.columns else "orangered",
        s=sizes, cmap="YlOrRd", alpha=0.6, edgecolors="none",
    )
    if "frp" in df.columns:
        fig.colorbar(scatter, ax=ax, label="Fire radiative power (MW)")
    ax.set_xlabel("Longitude")
    ax.set_ylabel("Latitude")
    ax.set_title(f"FIRMS fire detections - {region}, last {days} day(s) ({len(df):,} points)")
    ax.grid(alpha=0.3)
    fig.tight_layout()
    fig.savefig(path, dpi=150)
    print(f"\nMap saved to {path}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Fetch NASA FIRMS fire detections.")
    parser.add_argument("--region", "-r", default="finland",
                        help=f"Named region ({', '.join(firms.REGIONS)}) or bbox 'west,south,east,north'")
    parser.add_argument("--source", "-s", default="VIIRS_NOAA20_NRT",
                        help=f"Dataset ({', '.join(firms.SOURCES[:4])}, ...)")
    parser.add_argument("--days", "-d", type=int, default=1, help="Day range 1-10")
    parser.add_argument("--date", help="Start date YYYY-MM-DD for historical queries")
    parser.add_argument("--out", "-o", help="Write detections to this CSV file")
    parser.add_argument("--plot", "-p", help="Save a scatter map to this PNG file")
    parser.add_argument("--status", action="store_true", help="Show MAP_KEY quota usage and exit")
    args = parser.parse_args()

    if args.status:
        status = firms.key_status()
        print(f"Transactions used: {status['current_transactions']}/{status['transaction_limit']} "
              f"per {status['transaction_interval']}")
        return 0

    df = firms.area_fires(region=args.region, source=args.source, days=args.days, date=args.date)
    summarize(df, args.region, args.source, args.days)

    if args.out:
        df.to_csv(args.out, index=False)
        print(f"\nSaved {len(df):,} rows to {args.out}")
    if args.plot and not df.empty:
        plot(df, args.plot, args.region, args.days)
    return 0


if __name__ == "__main__":
    sys.exit(main())
