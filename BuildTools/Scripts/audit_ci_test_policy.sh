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

compile_live="$(
  rg -l '#if !CI' "$ROOT/Tests" --glob '*.swift' 2>/dev/null | wc -l | tr -d ' '
)"
doc_compile="$(rg -o 'Compile-excluded suites: [0-9]+' "$POLICY" | head -1 | rg -o '[0-9]+' || true)"
if [[ -z "$doc_compile" ]]; then
  echo "Could not read Compile-excluded suites from TEST_CI_POLICY.md"
  exit 1
fi
if [[ "$compile_live" != "$doc_compile" ]]; then
  echo "Compile-excluded suites: Tests have $compile_live files with #if !CI, TEST_CI_POLICY says $doc_compile"
  exit 1
fi

compile_rows="$(
  awk '/^## Compile exclusion/,/^## Global Theme SSOT/' "$POLICY" | rg -c '^\| `Tests/' || true
)"
if [[ "$compile_rows" != "$doc_compile" ]]; then
  echo "TEST_CI_POLICY compile table has $compile_rows rows, Compile-excluded suites says $doc_compile"
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

if ! rg -q '@Suite\(\.serialized\)' "$POLICY"; then
  echo "TEST_CI_POLICY.md must document ThemeLayoutTests @Suite(.serialized)"
  exit 1
fi

serialized_live="$(
  rg -l '@Suite\(\.serialized\)' "$ROOT/Tests" --glob '*.swift' 2>/dev/null | wc -l | tr -d ' '
)"
doc_serialized="$(rg -o 'Serialized suites: [0-9]+' "$POLICY" | head -1 | rg -o '[0-9]+' || true)"
if [[ -z "$doc_serialized" ]]; then
  echo "Could not read Serialized suites count from TEST_CI_POLICY.md"
  exit 1
fi
if [[ "$serialized_live" != "$doc_serialized" ]]; then
  echo "Serialized suites: Tests have $serialized_live, TEST_CI_POLICY says $doc_serialized"
  exit 1
fi

serialized_rows="$(
  awk '/^## Serialized test suites$/,/^## Runtime skips$/' "$POLICY" | rg -c '^\| `Tests/' || true
)"
if [[ "$serialized_rows" != "$doc_serialized" ]]; then
  echo "TEST_CI_POLICY serialized table has $serialized_rows rows, Serialized suites says $doc_serialized"
  exit 1
fi

while IFS= read -r suite_file; do
  [[ -z "$suite_file" ]] && continue
  rel="${suite_file#"$ROOT"/}"
  if ! rg -qF "$rel" "$POLICY"; then
    echo "TEST_CI_POLICY.md must list serialized suite $rel"
    exit 1
  fi
done < <(rg -l '@Suite\(\.serialized\)' "$ROOT/Tests" --glob '*.swift' 2>/dev/null | sort)

echo "CI test policy audit passed ($doc_compile compile-excluded, $doc_runtime runtime skips, $doc_serialized serialized suites, Theme reset documented)."