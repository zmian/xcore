#!/usr/bin/env bash
# Ensures CGFloat.s1…s8 match docs/architecture/SPACING_SCALE.md (frozen scale).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CONSTANTS="$ROOT/Sources/Xcore/Swift/Helpers/Constants.swift"
SCALE_DOC="$ROOT/docs/architecture/SPACING_SCALE.md"

tokens=(s1 s2 s3 s4 s5 s6 s7 s8)
expected=(4 8 12 16 20 24 28 32)

for index in "${!tokens[@]}"; do
  token="${tokens[$index]}"
  want="${expected[$index]}"
  if rg -q "nonisolated\\(unsafe\\).*var ${token}" "$CONSTANTS" 2>/dev/null; then
    echo "${token} must be a frozen constant (public static let), not nonisolated(unsafe) var."
    exit 1
  fi
  if ! line="$(rg -o "static let ${token}: Self = [0-9]+" "$CONSTANTS" 2>/dev/null | head -1)"; then
    echo "Missing frozen definition for CGFloat.${token}"
    exit 1
  fi
  got="$(echo "$line" | rg -o '[0-9]+$')"
  if [[ "$got" != "$want" ]]; then
    echo "CGFloat.${token} is ${got}, SPACING_SCALE.md expects ${want}"
    exit 1
  fi
done

if [[ ! -f "$SCALE_DOC" ]]; then
  echo "Missing docs/architecture/SPACING_SCALE.md"
  exit 1
fi

s3="$(rg -o 'static let s3: Self = [0-9]+' "$CONSTANTS" | head -1 | rg -o '[0-9]+$')"
s5="$(rg -o 'static let s5: Self = [0-9]+' "$CONSTANTS" | head -1 | rg -o '[0-9]+$')"

doc_s3="$(awk -F'|' '/\| `s3` \|/ { gsub(/^ +| +$/, "", $3); print $3; exit }' "$SCALE_DOC")"
doc_s5="$(awk -F'|' '/\| `s5` \|/ { gsub(/^ +| +$/, "", $3); print $3; exit }' "$SCALE_DOC")"

theme_default="$(awk -F'|' '/\| `defaultSpacing` \|/ { gsub(/^ +| +$/, "", $3); print $3; exit }' "$SCALE_DOC" | awk '{print $1}')"
theme_inter="$(awk -F'|' '/\| `interItemHSpacing` \|/ { gsub(/^ +| +$/, "", $3); print $3; exit }' "$SCALE_DOC" | awk '{print $1}')"

[[ "$s3" == "$doc_s3" && "$s3" == "$theme_inter" ]] || {
  echo "s3 ($s3) must match SPACING_SCALE frozen row ($doc_s3) and theme default ($theme_inter)"
  exit 1
}

[[ "$s5" == "$doc_s5" && "$s5" == "$theme_default" ]] || {
  echo "s5 ($s5) must match SPACING_SCALE frozen row ($doc_s5) and theme default ($theme_default)"
  exit 1
}

for token in s3 s5; do
  if ! rg -B8 "static let ${token}: Self" "$CONSTANTS" | rg -q 'SPACING_SCALE\.md'; then
    echo "CGFloat.${token} public docs must reference SPACING_SCALE.md (T-150)"
    exit 1
  fi
done

if ! rg -q 'SPACING_SCALE\.md' "$ROOT/Sources/Xcore/SwiftUI/Components/Theme/Theme.swift"; then
  echo "Theme.swift spacing properties must reference SPACING_SCALE.md"
  exit 1
fi

echo "Spacing scale audit passed (s1…s8 frozen; s3/s5 aligned with theme defaults)."