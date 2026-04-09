#!/bin/bash
# Riverbraid Cluster Sentinel v1.5.2 (Protocol-First)
TARGET_ROOT="01a777"
ORG="Riverbraid"
PETALS=("Action-Gold" "Audio-Gold" "Cognition" "Core" "Crypto-Gold" "GPG-Gold" "Golds" "Harness-Gold" "Integration-Gold" "Interface-Gold" "Judicial-Gold" "Lite" "Manifest-Gold" "Memory-Gold" "Refusal-Gold" "Safety-Gold" "Temporal-Gold" "Vision-Gold")

STATE_FILE=".audit_state"
> $STATE_FILE

echo "Auditing $TARGET_ROOT across ${#PETALS[@]} petals via Git Protocol..."

for petal in "${PETALS[@]}"; do
    REPO_NAME="Riverbraid-$petal"
    # Authenticate the git command using the token provided in the environment
    # This works for both public and private repos in the same ORG
    URL="https://x-access-token:${GITHUB_TOKEN}@github.com/${ORG}/${REPO_NAME}.git"
    
    # Get the SHA of the tag directly from the remote
    # We use awk to handle the '^{}' suffix that Git adds to annotated tags
    SHA=$(git ls-remote --tags "$URL" "refs/tags/v1.5.0" | awk '{print $1}' | tail -n 1)

    if [ -n "$SHA" ] && [ "${#SHA}" -eq 40 ]; then
        echo "$SHA" >> "$STATE_FILE"
        echo "  $REPO_NAME: VALID ($SHA)"
    else
        echo "  $REPO_NAME: FAILED (Tag v1.5.0 unreachable or invalid)"
        exit 1
    fi
done

ACTUAL_ROOT=$(sort "$STATE_FILE" | sha256sum | cut -c1-6)
rm "$STATE_FILE"

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
