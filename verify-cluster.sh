#!/bin/bash
# Riverbraid Cluster Sentinel v1.5.1 (Remote-First)
TARGET_ROOT="01a777"
ORG="Riverbraid"
PETALS=("Action-Gold" "Audio-Gold" "Cognition" "Core" "Crypto-Gold" "GPG-Gold" "Golds" "Harness-Gold" "Integration-Gold" "Interface-Gold" "Judicial-Gold" "Lite" "Manifest-Gold" "Memory-Gold" "Refusal-Gold" "Safety-Gold" "Temporal-Gold" "Vision-Gold")

STATE_FILE=".audit_state"
> $STATE_FILE

echo "Auditing $TARGET_ROOT integrity across ${#PETALS[@]} petals via GitHub API..."

for petal in "${PETALS[@]}"; do
  # Use gh CLI to get the tag SHA without cloning
  REPO_NAME="Riverbraid-$petal"
  # Adjusting for repos that don't follow the 'Riverbraid-' prefix if necessary
  [[ "$petal" == "Riverbraid-"* ]] && REPO_NAME="$petal"
  
  SHA=$(gh api repos/$ORG/$REPO_NAME/git/ref/tags/v1.5.0 --template '{{.object.sha}}' 2>/dev/null)
  
  if [ -n "$SHA" ]; then
    echo "$SHA" >> $STATE_FILE
    echo "  $REPO_NAME: VALID ($SHA)"
  else
    echo "  $REPO_NAME: FAILED (Tag v1.5.0 not found or Unauthorized)"
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
