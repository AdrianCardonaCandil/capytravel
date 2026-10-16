#!/bin/bash
set -e

# Verify pmtiles installation
if ! command -v pmtiles &> /dev/null; then
    echo "❌ Error: pmtiles not installed. Run: brew install protomaps/pmtiles/pmtiles"
    exit 1
fi

# Variable declaration
SRC="${SRC:-https://overturemaps-extras-us-west-2.s3.us-west-2.amazonaws.com/tiles/2026-08-19.0}"
TARGET_DIR="${TARGET_DIR:-../data/}"
THREADS="${THREADS:-8}"

# Create target dir if not exists
mkdir -p "$TARGET_DIR"

# Download process begin
pmtiles extract "$SRC/base.pmtiles" "$TARGET_DIR/base.pmtiles" --download-threads=$THREADS
pmtiles extract "$SRC/buildings.pmtiles" "$TARGET_DIR/buildings.pmtiles" --download-threads=$THREADS
pmtiles extract "$SRC/divisions.pmtiles" "$TARGET_DIR/divisions.pmtiles" --download-threads=$THREADS
pmtiles extract "$SRC/transportation.pmtiles" "$TARGET_DIR/transportation.pmtiles" --download-threads=$THREADS

echo "✅ Files were successfully downloaded into $TARGET_DIR"
