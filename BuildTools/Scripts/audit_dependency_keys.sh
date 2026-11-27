#!/usr/bin/env bash
# Validates DependencyKey enums under Sources/Xcore declare testValue unless allowlisted.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SOURCES="$ROOT/Sources/Xcore"
ALLOWLIST=(
  # Documented in docs/architecture/adr/0001-dependency-client-registration.md (P-003)
  "Sources/Xcore/Swift/Dependencies/AppPhase/AppPhaseClient.swift"
)

mapfile -t key_files < <(rg --no-heading -l '^\s*(private\s+)?enum\s+\w+.*:\s*DependencyKey' "$SOURCES" || true)

failures=()

for file in "${key_files[@]}"; do
  rel="${file#"$ROOT/"}"
  skip=false
  for allowed in "${ALLOWLIST[@]}"; do
    if [[ "$rel" == "$allowed" ]]; then
      skip=true
      break
    fi
  done
  if $skip; then
    continue
  fi

  if ! grep -q 'testValue' "$file"; then
    failures+=("$rel")
  fi
done

if ((${#failures[@]} > 0)); then
  echo "DependencyKey audit failed — missing testValue:"
  printf '  - %s\n' "${failures[@]}"
  echo "See docs/architecture/adr/0001-dependency-client-registration.md"
  exit 1
fi

echo "DependencyKey audit passed (${#key_files[@]} DependencyKey file(s))."