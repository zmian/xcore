#!/usr/bin/env bash
# Enforces where DependencyKey types and dependency clients may live.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SOURCES="$ROOT/Sources/Xcore"

DEPENDENCY_KEY_ALLOWLIST=(
  "Sources/Xcore/SwiftUI/Components/Pond/Pond.swift"
)

failures=()

mapfile -t key_files < <(rg --no-heading -l '^\s*(private\s+)?enum\s+\w+.*:\s*DependencyKey' "$SOURCES" || true)

for file in "${key_files[@]}"; do
  rel="${file#"$ROOT/"}"
  if [[ "$rel" == Sources/Xcore/Swift/Dependencies/* ]]; then
    continue
  fi
  allowed=false
  for path in "${DEPENDENCY_KEY_ALLOWLIST[@]}"; do
    if [[ "$rel" == "$path" ]]; then
      allowed=true
      break
    fi
  done
  if ! $allowed; then
    failures+=("DependencyKey outside Swift/Dependencies: $rel")
  fi
done

while IFS= read -r -d '' file; do
  rel="${file#"$ROOT/"}"
  if [[ "$rel" == Sources/Xcore/Swift/Dependencies/* ]]; then
    continue
  fi
  if [[ "$rel" == *Client*.swift ]] && grep -q 'extension DependencyValues' "$file"; then
    failures+=("Dependency client not under Swift/Dependencies: $rel")
  fi
done < <(find "$SOURCES" -name '*Client*.swift' -print0 2>/dev/null)

if rg -q 'IssueReporting\.' "$SOURCES/Swift/Dependencies" --glob '*.swift' 2>/dev/null; then
  rg -n 'IssueReporting\.' "$SOURCES/Swift/Dependencies" --glob '*.swift' || true
  failures+=("Use reportIssue for unimplemented dependency clients (see ADR 0002)")
fi

if ((${#failures[@]} > 0)); then
  echo "Module placement audit failed:"
  printf '  - %s\n' "${failures[@]}"
  echo "See docs/architecture/adr/0003-module-boundaries.md"
  exit 1
fi

echo "Module placement audit passed."