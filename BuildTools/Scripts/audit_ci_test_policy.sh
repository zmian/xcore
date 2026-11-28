#!/usr/bin/env bash
# Ensures TEST_CI_POLICY.md matches CI test guards in Tests/.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
POLICY="$ROOT/docs/architecture/TEST_CI_POLICY.md"
LIVE_ADDRESS_TESTS="$ROOT/Tests/XcoreTests/Clients/LiveAddressSearchClientTests.swift"

live_runtime="$(
  rg -c 'disabled\(if: TestEnvironment\.isCI' "$ROOT/Tests" --glob '*.swift' 2>/dev/null \
    | rg -v 'LiveAddressSearchClientTests\.swift' \
    | awk -F: '{s+=$2} END {print s+0}'
)"
doc_runtime="$(rg -o 'Runtime CI skips: [0-9]+' "$POLICY" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$doc_runtime" ]]; then
  echo "Could not read Runtime CI skips from TEST_CI_POLICY.md"
  exit 1
fi

if [[ "$live_runtime" != "$doc_runtime" ]]; then
  echo "CI runtime skips: Tests have $live_runtime, TEST_CI_POLICY says $doc_runtime"
  exit 1
fi

if ! rg -q '#if !CI' "$LIVE_ADDRESS_TESTS"; then
  echo "LiveAddressSearchClientTests must be wrapped in #if !CI for compile-time CI exclusion"
  exit 1
fi

if ! rg -q 'struct LiveAddressSearchClientTests' "$LIVE_ADDRESS_TESTS"; then
  echo "LiveAddressSearchClientTests struct missing"
  exit 1
fi

table_rows="$(
  awk '/^## Runtime skips$/,/^## Workflow guards$/' "$POLICY" | rg -c '^\| `Tests/' || true
)"
if [[ "$table_rows" != "$doc_runtime" ]]; then
  echo "TEST_CI_POLICY runtime table has $table_rows rows, Runtime CI skips says $doc_runtime"
  exit 1
fi

for audit_script in "$ROOT"/BuildTools/Scripts/audit_*.sh; do
  [[ "$(basename "$audit_script")" == audit_ci_test_policy.sh ]] && continue
  if rg -q 'head -n -[0-9]' "$audit_script" 2>/dev/null; then
    echo "Audit script $(basename "$audit_script") must not use 'head -n -' (macOS CI / Bash 3.2)"
    exit 1
  fi
done

if ! rg -q 'resetThemeSpacingSSOTForParallelTesting' "$POLICY"; then
  echo "TEST_CI_POLICY.md must document resetThemeSpacingSSOTForParallelTesting (parallel Theme SSOT)"
  exit 1
fi

if ! rg -q 'audit_theme_test_isolation' "$POLICY"; then
  echo "TEST_CI_POLICY.md must reference audit_theme_test_isolation.sh"
  exit 1
fi

echo "CI test policy audit passed ($doc_runtime runtime skips, LiveAddress #if !CI, Theme reset documented)."