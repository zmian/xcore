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

if ! rg -q 'func spacingScaleMatchesDocumentation' "$TEST_FILE"; then
  echo "spacingScaleMatchesDocumentation test missing"
  exit 1
fi

spacing_func="$(
  sed -n '/func spacingScaleMatchesDocumentation/,/^    @Test func listRowInsetsFollowDefaultSpacing/p' "$TEST_FILE" | sed '$d'
)"

echo "$spacing_func" | rg -q 'Theme\.defaultSpacing = 20' || {
  echo "spacingScaleMatchesDocumentation must reset Theme.defaultSpacing to 20 before assertions"
  exit 1
}

echo "$spacing_func" | rg -q 'Theme\.interItemHSpacing = 12' || {
  echo "spacingScaleMatchesDocumentation must reset Theme.interItemHSpacing to 12 before assertions"
  exit 1
}

if ! rg -q 'spacingScaleMatchesDocumentation' "$POLICY"; then
  echo "TEST_CI_POLICY.md must document spacingScaleMatchesDocumentation Theme reset"
  exit 1
fi

if ! rg -q 'listRowInsetsFollowDefaultSpacing' "$POLICY"; then
  echo "TEST_CI_POLICY.md must document listRowInsetsFollowDefaultSpacing Theme reset"
  exit 1
fi

default_spacing_func="$(
  sed -n '/func defaultSpacingForwardsToDefaultTheme/,/^    @Test func spacingScaleMatchesDocumentation/p' "$TEST_FILE" | sed '$d'
)"

echo "$default_spacing_func" | rg -q 'Theme\.defaultSpacing = 20' || {
  echo "defaultSpacingForwardsToDefaultTheme must reset Theme.defaultSpacing to 20 before assertions"
  exit 1
}

echo "$default_spacing_func" | rg -q 'Theme\.interItemHSpacing = 12' || {
  echo "defaultSpacingForwardsToDefaultTheme must reset Theme.interItemHSpacing to 12 before assertions"
  exit 1
}

list_row_func="$(
  sed -n '/func listRowInsetsFollowDefaultSpacing/,/^    }/p' "$TEST_FILE"
)"

echo "$list_row_func" | rg -q 'Theme\.defaultSpacing = 20' || {
  echo "listRowInsetsFollowDefaultSpacing must reset Theme.defaultSpacing to 20 before assertions"
  exit 1
}

echo "$list_row_func" | rg -q 'Theme\.interItemHSpacing = 12' || {
  echo "listRowInsetsFollowDefaultSpacing must reset Theme.interItemHSpacing to 12 before assertions"
  exit 1
}

echo "Theme test isolation audit passed (spacing scale reset documented and enforced)."