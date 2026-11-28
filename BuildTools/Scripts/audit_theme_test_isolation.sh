#!/usr/bin/env bash
# Ensures ThemeLayoutTests resets global spacing SSOT before scale assertions (parallel CI).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
POLICY="$ROOT/docs/architecture/TEST_CI_POLICY.md"
SCALE_DOC="$ROOT/docs/architecture/SPACING_SCALE.md"
TEST_FILE="$ROOT/Tests/XcoreTests/Components/ThemeLayoutTests.swift"

if [[ ! -f "$TEST_FILE" ]]; then
  echo "ThemeLayoutTests.swift missing"
  exit 1
fi

if ! rg -q 'func resetThemeSpacingSSOTForParallelTesting' "$TEST_FILE"; then
  echo "ThemeLayoutTests must define resetThemeSpacingSSOTForParallelTesting()"
  exit 1
fi

if ! rg -q '@Suite\(\.serialized\)' "$TEST_FILE"; then
  echo "ThemeLayoutTests must use @Suite(.serialized) (global Theme spacing mutations)"
  exit 1
fi

reset_func="$(
  sed -n '/func resetThemeSpacingSSOTForParallelTesting/,/^}/p' "$TEST_FILE" | sed '$d'
)"

if ! echo "$reset_func" | rg -q 'Theme\.defaultSpacing = \.s5'; then
  echo "resetThemeSpacingSSOTForParallelTesting must set Theme.defaultSpacing = .s5 (SPACING_SCALE.md)"
  exit 1
fi

if ! echo "$reset_func" | rg -q 'Theme\.interItemHSpacing = \.s3'; then
  echo "resetThemeSpacingSSOTForParallelTesting must set Theme.interItemHSpacing = .s3 (SPACING_SCALE.md)"
  exit 1
fi

if [[ ! -f "$SCALE_DOC" ]]; then
  echo "Missing docs/architecture/SPACING_SCALE.md"
  exit 1
fi

doc_default="$(awk -F'|' '/\| `defaultSpacing` \|/ { gsub(/^ +| +$/, "", $3); print $3; exit }' "$SCALE_DOC" | awk '{print $1}')"
doc_inter="$(awk -F'|' '/\| `interItemHSpacing` \|/ { gsub(/^ +| +$/, "", $3); print $3; exit }' "$SCALE_DOC" | awk '{print $1}')"

[[ "$doc_default" == "20" ]] || {
  echo "SPACING_SCALE.md defaultSpacing must be 20 (got ${doc_default:-empty})"
  exit 1
}

[[ "$doc_inter" == "12" ]] || {
  echo "SPACING_SCALE.md interItemHSpacing must be 12 (got ${doc_inter:-empty})"
  exit 1
}

for test_name in defaultSpacingForwardsToDefaultTheme spacingScaleMatchesDocumentation listRowInsetsFollowDefaultSpacing; do
  if [[ "$test_name" == listRowInsetsFollowDefaultSpacing ]]; then
    func_body="$(sed -n "/func ${test_name}/,/^    }$/p" "$TEST_FILE")"
  else
    func_body="$(sed -n "/func ${test_name}/,/^    @Test func /p" "$TEST_FILE" | sed '$d')"
  fi
  echo "$func_body" | rg -q 'resetThemeSpacingSSOTForParallelTesting' || {
    echo "${test_name} must call resetThemeSpacingSSOTForParallelTesting()"
    exit 1
  }
done

if ! rg -q 'resetThemeSpacingSSOTForParallelTesting' "$POLICY"; then
  echo "TEST_CI_POLICY.md must document resetThemeSpacingSSOTForParallelTesting"
  exit 1
fi

if rg -q '(Theme|CGFloat)\.defaultSpacing = [0-9]+' "$TEST_FILE"; then
  echo "ThemeLayoutTests must use spacing scale tokens (e.g. .s4/.s6), not bare point literals"
  rg -n '(Theme|CGFloat)\.defaultSpacing = [0-9]+' "$TEST_FILE" || true
  exit 1
fi

echo "Theme test isolation audit passed (spacing scale reset documented and enforced)."