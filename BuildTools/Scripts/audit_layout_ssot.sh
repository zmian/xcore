#!/usr/bin/env bash
# Enforces ADR 0005: corner radius canonical on Theme; AppConstants forwards only.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SOURCES="$ROOT/Sources/Xcore"
CONSTANTS="$SOURCES/Swift/Helpers/Constants.swift"
THEME="$SOURCES/SwiftUI/Components/Theme/Theme.swift"

for prop in cornerRadius defaultSpacing interItemHSpacing; do
  if ! rg -q "public var ${prop}: CGFloat" "$THEME"; then
    echo "Theme must declare public ${prop} (ADR 0005)."
    exit 1
  fi
done

if ! rg -q 'public var listRowInsets: EdgeInsets' "$THEME"; then
  echo "Theme must declare listRowInsets (ADR 0005)."
  exit 1
fi

for prop in cornerRadius defaultSpacing interItemHSpacing; do
  if rg -q "nonisolated\\(unsafe\\).*var ${prop}" "$CONSTANTS" 2>/dev/null; then
    echo "${prop} must forward to Theme, not use nonisolated(unsafe)."
    exit 1
  fi
done

if rg -q 'nonisolated\\(unsafe\\).*var listRow' "$CONSTANTS" 2>/dev/null; then
  echo "EdgeInsets.listRow must forward to Theme, not use nonisolated(unsafe)."
  exit 1
fi

direct_use_count="$(rg -l 'AppConstants\.cornerRadius' "$SOURCES" --glob '*.swift' 2>/dev/null | rg -vc 'Swift/Helpers/Constants\.swift$' || true)"
if [[ "$direct_use_count" -gt 0 ]]; then
  echo "AppConstants.cornerRadius is a compatibility forwarder only; use Theme.cornerRadius or @Environment(\\.theme)."
  rg -n 'AppConstants\.cornerRadius' "$SOURCES" --glob '*.swift' | rg -v 'Swift/Helpers/Constants\.swift' || true
  exit 1
fi

if ! rg -q 'defaultSpacing: CGFloat = \.s5' "$THEME"; then
  echo "Theme init defaultSpacing must use CGFloat.s5 (SPACING_SCALE.md)"
  exit 1
fi

if ! rg -q 'interItemHSpacing: CGFloat = \.s3' "$THEME"; then
  echo "Theme init interItemHSpacing must use CGFloat.s3 (SPACING_SCALE.md)"
  exit 1
fi

echo "Layout SSOT audit passed (Theme layout metrics canonical)."