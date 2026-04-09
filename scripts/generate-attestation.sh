#!/usr/bin/env bash
set -euo pipefail
if [ $# -ne 1 ]; then
  echo "Usage: ./scripts/generate-attestation.sh sha256:<64-hex-root>"
  exit 1
fi
ROOT="$1"
OUTPUT_DIR="attestation"
rm -rf "$OUTPUT_DIR" && mkdir -p "$OUTPUT_DIR"
npm ls --json > "$OUTPUT_DIR/sbom.raw.json"
node utils/canonical.js "$OUTPUT_DIR/sbom.raw.json" > "$OUTPUT_DIR/sbom.canonical.json"
cat > "$OUTPUT_DIR/build-provenance.json" <<EOP
{
  "version": "1.5.0",
  "sovereign_root": "$ROOT",
  "generated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOP
node utils/canonical.js "$OUTPUT_DIR/build-provenance.json" > "$OUTPUT_DIR/build-provenance.canonical.json"
gpg --detach-sign --armor "$OUTPUT_DIR/build-provenance.canonical.json"
tar -czf riverbraid-v1.5.0-genesis-attestation.tar.gz "$OUTPUT_DIR"
