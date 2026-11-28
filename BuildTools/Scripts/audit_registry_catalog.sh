#!/usr/bin/env bash
# REGISTRY_CATALOG.md inventory budgets match GOVERNANCE_METRICS.md and live inventories.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CATALOG="$ROOT/docs/architecture/REGISTRY_CATALOG.md"
METRICS="$ROOT/docs/architecture/GOVERNANCE_METRICS.md"
ENTROPY="$ROOT/docs/architecture/ENTROPY_INVENTORY.md"
CONCURRENCY="$ROOT/docs/architecture/CONCURRENCY_INVENTORY.md"
UNCHECKED="$ROOT/docs/architecture/UNCHECKED_SENDABLE_INVENTORY.md"

metric_value() {
  awk -F'|' -v lbl="$1" 'index($2, lbl) > 0 {gsub(/^ +| +$/, "", $3); print $3; exit}' "$METRICS"
}

entropy_catalog="$(awk -F'|' '/ENTROPY_INVENTORY/ {gsub(/^ +| +$/, "", $3); print $3; exit}' "$CATALOG" | rg -o '^[0-9]+' || true)"
warning_metric="$(metric_value '#warning in Sources/Xcore')"
entropy_total="$(rg -o 'Total: [0-9]+' "$ENTROPY" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$entropy_catalog" || -z "$warning_metric" || -z "$entropy_total" ]]; then
  echo "Could not read #warning budgets from catalog, metrics, or ENTROPY_INVENTORY"
  exit 1
fi

if [[ "$entropy_catalog" != "$warning_metric" || "$entropy_catalog" != "$entropy_total" ]]; then
  echo "REGISTRY_CATALOG #warning: catalog $entropy_catalog, metrics $warning_metric, ENTROPY $entropy_total"
  exit 1
fi

concurrency_catalog="$(awk -F'|' '/CONCURRENCY_INVENTORY/ {gsub(/^ +| +$/, "", $3); print $3; exit}' "$CATALOG" | rg -o '^[0-9]+' || true)"
concurrency_metric="$(metric_value 'nonisolated(unsafe) in Sources/Xcore')"
concurrency_total="$(rg -o 'Total: [0-9]+' "$CONCURRENCY" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$concurrency_catalog" || -z "$concurrency_metric" || -z "$concurrency_total" ]]; then
  echo "Could not read concurrency budgets from catalog, metrics, or CONCURRENCY_INVENTORY"
  exit 1
fi

if [[ "$concurrency_catalog" != "$concurrency_metric" || "$concurrency_catalog" != "$concurrency_total" ]]; then
  echo "REGISTRY_CATALOG concurrency: catalog $concurrency_catalog, metrics $concurrency_metric, CONCURRENCY $concurrency_total"
  exit 1
fi

unchecked_catalog="$(awk -F'|' '/UNCHECKED_SENDABLE_INVENTORY/ {gsub(/^ +| +$/, "", $3); print $3; exit}' "$CATALOG" | rg -o '^[0-9]+' || true)"
unchecked_metric="$(metric_value '@unchecked Sendable in Sources/Xcore')"
unchecked_total="$(rg -o 'Total: [0-9]+' "$UNCHECKED" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$unchecked_catalog" || -z "$unchecked_metric" || -z "$unchecked_total" ]]; then
  echo "Could not read @unchecked Sendable budgets from catalog, metrics, or UNCHECKED_SENDABLE_INVENTORY"
  exit 1
fi

if [[ "$unchecked_catalog" != "$unchecked_metric" || "$unchecked_catalog" != "$unchecked_total" ]]; then
  echo "REGISTRY_CATALOG @unchecked Sendable: catalog $unchecked_catalog, metrics $unchecked_metric, UNCHECKED $unchecked_total"
  exit 1
fi

if ! rg -q 'UNCHECKED_SENDABLE_CI_EVIDENCE\.md' "$CATALOG"; then
  echo "REGISTRY_CATALOG.md must list UNCHECKED_SENDABLE_CI_EVIDENCE.md (ADR 0009)"
  exit 1
fi

SUMMARY="$ROOT/docs/architecture/GOVERNANCE_SUMMARY.md"
ARCH_MAP="$ROOT/docs/architecture/ARCHITECTURE_MAP.md"

for script in audit_spacing_scale audit_theme_test_isolation; do
  if ! rg -q "${script}" "$SUMMARY"; then
    echo "GOVERNANCE_SUMMARY.md must reference ${script}.sh (layout SSOT chain)"
    exit 1
  fi
done

if ! rg -q 'audit_theme_test_isolation' "$ARCH_MAP"; then
  echo "ARCHITECTURE_MAP.md must reference audit_theme_test_isolation.sh for layout ownership"
  exit 1
fi

echo "Registry catalog inventory budgets passed (#warning $entropy_catalog, concurrency $concurrency_catalog, unchecked $unchecked_catalog)."