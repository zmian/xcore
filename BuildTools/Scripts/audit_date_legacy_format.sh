#!/usr/bin/env bash
# Ensures Date.LegacyFormatStyle usage stays at the documented single call site (P-002).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DOC="$ROOT/docs/architecture/DATE_LEGACY_FORMAT.md"
FORMATTED="$ROOT/Sources/Xcore/Swift/Components/DatesTimers/Date/Format/Date+Formatted.swift"
LEGACY_FILE="$ROOT/Sources/Xcore/Swift/Components/DatesTimers/Date/Format/Date+LegacyFormatStyle.swift"
SOURCES="$ROOT/Sources/Xcore"

expected_outside=1

if [[ ! -f "$DOC" || ! -f "$LEGACY_FILE" ]]; then
  echo "DATE_LEGACY_FORMAT.md or Date+LegacyFormatStyle.swift missing"
  exit 1
fi

if ! grep -q 'P-002' "$DOC"; then
  echo "DATE_LEGACY_FORMAT.md must reference P-002"
  exit 1
fi

live_outside=0
while IFS= read -r file; do
  [[ "$file" == *"Date+LegacyFormatStyle.swift" ]] && continue
  count="$(rg -c '\.legacy' "$file" 2>/dev/null | awk -F: '{print $NF}' || echo 0)"
  live_outside=$((live_outside + count))
done < <(rg -l '\.legacy' "$SOURCES" --glob '*.swift' 2>/dev/null || true)

[[ "$live_outside" == "$expected_outside" ]] || {
  echo "Expected $expected_outside .legacy call site(s) outside LegacyFormatStyle; found $live_outside"
  exit 1
}

if ! rg -q '\.legacy' "$FORMATTED"; then
  echo "Date+Formatted.swift must retain the canonical .legacy relative dateTime path"
  exit 1
fi

echo "Date legacy format audit passed ($live_outside external call site, P-002 documented)."