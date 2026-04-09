#!/bin/bash
mkdir -p .git/hooks
cat <<'HOOK' > .git/hooks/pre-commit
#!/bin/sh
if command -v gitleaks >/dev/null 2>&1; then
  gitleaks protect --verbose --staged
else
  echo "Warning: gitleaks not found. Skipping local secret scan."
fi
HOOK
chmod +x .git/hooks/pre-commit
echo "Pre-commit hook installed."
