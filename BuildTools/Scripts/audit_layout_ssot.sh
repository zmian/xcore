#!/usr/bin/env bash
# Enforces ADR 0005: corner radius canonical on Theme; AppConstants forwards only.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SOURCES="$ROOT/Sources/Xcore"
CONSTANTS="$SOURCES/Swift/Helpers/Constants.swift"
THEME="$SOURCES/SwiftUI/Components/Theme/Theme.swift"

if ! rg -q 'public var cornerRadius: CGFloat' "$THEME"; then
  echo "Theme must declare public cornerRadius (ADR 0005)."
  exit 1
fi

if rg -q 'nonisolated\(unsafe\).*cornerRadius' "$CONSTANTS" 2>/dev/null; then
  echo "AppConstants.cornerRadius must not use nonisolated(unsafe); forward to Theme."
  exit 1
fi

direct_use_count="$(rg -l 'AppConstants\.cornerRadius' "$SOURCES" --glob '*.swift' 2>/dev/null | rg -vc 'Swift/Helpers/Constants\.swift$' || true)"
if [[ "$direct_use_count" -gt 0 ]]; then
  echo "AppConstants.cornerRadius is a compatibility forwarder only; use Theme.cornerRadius or @Environment(\\.theme)."
  rg -n 'AppConstants\.cornerRadius' "$SOURCES" --glob '*.swift' | rg -v 'Swift/Helpers/Constants\.swift' || true
  exit 1
fi

echo "Layout SSOT audit passed (Theme.cornerRadius canonical)."