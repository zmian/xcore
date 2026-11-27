#!/usr/bin/env bash
# Ensures CGFloat.s1…s8 match docs/architecture/SPACING_SCALE.md (frozen scale).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CONSTANTS="$ROOT/Sources/Xcore/Swift/Helpers/Constants.swift"

declare -A expected=(
  [s1]=4 [s2]=8 [s3]=12 [s4]=16 [s5]=20 [s6]=24 [s7]=28 [s8]=32
)

for token in s1 s2 s3 s4 s5 s6 s7 s8; do
  want="${expected[$token]}"
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

echo "Spacing scale audit passed (s1…s8 frozen)."