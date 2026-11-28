#!/usr/bin/env bash
# Ensures CGFloat.s1…s8 match docs/architecture/SPACING_SCALE.md (frozen scale).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CONSTANTS="$ROOT/Sources/Xcore/Swift/Helpers/Constants.swift"

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

echo "Spacing scale audit passed (s1…s8 frozen)."