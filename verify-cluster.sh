#!/bin/bash
# Riverbraid Cluster Sentinel v1.5.0
TARGET_ROOT="01a777"
PETALS=("Riverbraid-Action-Gold" "Riverbraid-Audio-Gold" "Riverbraid-Cognition" "Riverbraid-Core" "Riverbraid-Crypto-Gold" "Riverbraid-GPG-Gold" "Riverbraid-Golds" "Riverbraid-Harness-Gold" "Riverbraid-Integration-Gold" "Riverbraid-Interface-Gold" "Riverbraid-Judicial-Gold" "Riverbraid-Lite" "Riverbraid-Manifest-Gold" "Riverbraid-Memory-Gold" "Riverbraid-Refusal-Gold" "Riverbraid-Safety-Gold" "Riverbraid-Temporal-Gold" "Riverbraid-Vision-Gold")

STATE_FILE=".audit_state"
> $STATE_FILE

echo "Checking $TARGET_ROOT integrity across ${#PETALS[@]} petals..."

for repo in "${PETALS[@]}"; do
  # In CI, we need to clone siblings if they aren't present
  # But for a simple check against remote tags:
  SHA=$(git ls-remote https://github.com/Riverbraid/$repo.git refs/tags/v1.5.0 | cut -f1)
  
  if [ -n "$SHA" ]; then
    echo "$SHA" >> $STATE_FILE
    echo "  $repo: FOUND ($SHA)"
  else
    echo "  $repo: MISSING v1.5.0 TAG"
    exit 1
  fi
done

ACTUAL_ROOT=$(sort $STATE_FILE | sha256sum | cut -c1-6)
rm $STATE_FILE

echo "---"
echo "Target Root: $TARGET_ROOT"
echo "Actual Root: $ACTUAL_ROOT"

if [ "$ACTUAL_ROOT" == "$TARGET_ROOT" ]; then
  echo "VERIFIED: CLUSTER STATIONARY"
  exit 0
else
  echo "CRITICAL: CLUSTER DRIFT DETECTED"
  exit 1
fi
