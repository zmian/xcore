#!/usr/bin/env bash
# Ensures ThemeLayoutTests resets global spacing SSOT before scale assertions (parallel CI).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
POLICY="$ROOT/docs/architecture/TEST_CI_POLICY.md"
TEST_FILE="$ROOT/Tests/XcoreTests/Components/ThemeLayoutTests.swift"

if [[ ! -f "$TEST_FILE" ]]; then
  echo "ThemeLayoutTests.swift missing"
  exit 1
fi

if ! rg -q 'func resetThemeSpacingSSOTForParallelTesting' "$TEST_FILE"; then
  echo "ThemeLayoutTests must define resetThemeSpacingSSOTForParallelTesting()"
  exit 1
fi

reset_func="$(
  sed -n '/func resetThemeSpacingSSOTForParallelTesting/,/^}/p' "$TEST_FILE" | sed '$d'
)"

echo "$reset_func" | rg -q 'Theme\.defaultSpacing = 20' || {
  echo "resetThemeSpacingSSOTForParallelTesting must set Theme.defaultSpacing = 20"
  exit 1
}

echo "$reset_func" | rg -q 'Theme\.interItemHSpacing = 12' || {
  echo "resetThemeSpacingSSOTForParallelTesting must set Theme.interItemHSpacing = 12"
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

echo "Theme test isolation audit passed (spacing scale reset documented and enforced)."