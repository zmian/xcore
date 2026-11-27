#!/usr/bin/env bash
# Single SSOT for numeric JSON encode-as-string default (ADR entropy reduction).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
FORMAT="$ROOT/Sources/Xcore/Swift/Extensions/Codable/FormatStyle"
DEFAULTS="$FORMAT/CodingFormatStyle+Defaults.swift"

unsafe_count="$(rg -c 'nonisolated\(unsafe\).*defaultEncodeAsString' "$FORMAT" --glob '*.swift' 2>/dev/null | awk -F: '{s+=$2} END {print s+0}')"
if [[ "$unsafe_count" != "1" ]]; then
  echo "Expected exactly 1 nonisolated(unsafe) defaultEncodeAsString in FormatStyle (found $unsafe_count)"
  rg -n 'defaultEncodeAsString' "$FORMAT" --glob '*.swift' || true
  exit 1
fi

if ! rg -q 'enum CodingFormatStyleDefaults' "$DEFAULTS"; then
  echo "Missing CodingFormatStyleDefaults"
  exit 1
fi

for file in CodingFormatStyle+Decimal.swift CodingFormatStyle+Double.swift; do
  if rg -q 'nonisolated\(unsafe\).*defaultEncodeAsString' "$FORMAT/$file" 2>/dev/null; then
    echo "Duplicate unsafe defaultEncodeAsString in $file"
    exit 1
  fi
done

echo "Coding defaults audit passed (SSOT on CodingFormatStyleDefaults)."