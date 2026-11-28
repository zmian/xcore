#!/usr/bin/env bash
# PRODUCT_GATES.md must stay in sync with pending gate SSOT docs.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GATES="$ROOT/docs/architecture/PRODUCT_GATES.md"
ARCH="$ROOT/docs/architecture"

required_pending=(
  "P-002:DATE_LEGACY_FORMAT.md"
  "P-003:APP_PHASE_CLIENT.md"
)
required_resolved=(
  "P-001:ADDRESS_SEARCH_CLIENT.md"
)

if [[ ! -f "$GATES" ]]; then
  echo "Missing PRODUCT_GATES.md"
  exit 1
fi

for entry in "${required_pending[@]}"; do
  id="${entry%%:*}"
  doc="${entry#*:}"
  if ! grep -q "| $id |" "$GATES"; then
    echo "PRODUCT_GATES.md must list pending gate $id"
    exit 1
  fi
  if ! grep -q "$doc" "$GATES"; then
    echo "PRODUCT_GATES.md must link $doc for $id"
    exit 1
  fi
  if [[ ! -f "$ARCH/$doc" ]]; then
    echo "Missing SSOT $ARCH/$doc for $id"
    exit 1
  fi
  if ! grep -q "$id" "$ARCH/$doc"; then
    echo "$doc must reference $id"
    exit 1
  fi
  if [[ "$id" == "P-003" ]]; then
    if ! rg -q 'UNCHECKED_SENDABLE' "$ARCH/$doc"; then
      echo "APP_PHASE_CLIENT.md must link UNCHECKED_SENDABLE docs (concurrency vs P-003)"
      exit 1
    fi
    if ! rg -q 'audit_product_gates' "$ARCH/$doc"; then
      echo "APP_PHASE_CLIENT.md must reference audit_product_gates.sh"
      exit 1
    fi
  fi
  if [[ "$id" == "P-002" ]]; then
    if ! rg -q 'ENTROPY_INVENTORY' "$ARCH/$doc"; then
      echo "DATE_LEGACY_FORMAT.md must link ENTROPY_INVENTORY.md"
      exit 1
    fi
    if ! rg -q 'audit_date_legacy_format' "$ARCH/$doc"; then
      echo "DATE_LEGACY_FORMAT.md must reference audit_date_legacy_format.sh"
      exit 1
    fi
  fi
done

for entry in "${required_resolved[@]}"; do
  id="${entry%%:*}"
  doc="${entry#*:}"
  if ! grep -q "$id" "$GATES"; then
    echo "PRODUCT_GATES.md must list resolved gate $id"
    exit 1
  fi
  if [[ ! -f "$ARCH/$doc" ]]; then
    echo "Missing SSOT $ARCH/$doc for resolved $id"
    exit 1
  fi
done

echo "Product gates audit passed (${#required_pending[@]} pending, ${#required_resolved[@]} resolved)."