#!/usr/bin/env bash
set -euo pipefail
if [ $# -ne 1 ]; then
  echo "Usage: ./scripts/anchor-root.sh sha256:<64-hex-root>"
  exit 1
fi
ROOT="$1"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
ANCHOR_FILE="anchor/anchor.txt"
echo "Riverbraid v1.5.0-Genesis Sovereign Root" > "$ANCHOR_FILE"
echo "Root: $ROOT" >> "$ANCHOR_FILE"
echo "Timestamp (UTC): $TIMESTAMP" >> "$ANCHOR_FILE"
if ! command -v ots >/dev/null 2>&1; then
  echo "OpenTimestamps not found. pip install opentimestamps-client"
  exit 0
fi
ots stamp "$ANCHOR_FILE"
