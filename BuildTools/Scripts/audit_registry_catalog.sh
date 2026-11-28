#!/usr/bin/env bash
# REGISTRY_CATALOG.md inventory budgets match GOVERNANCE_METRICS.md and live inventories.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CATALOG="$ROOT/docs/architecture/REGISTRY_CATALOG.md"
METRICS="$ROOT/docs/architecture/GOVERNANCE_METRICS.md"
ENTROPY="$ROOT/docs/architecture/ENTROPY_INVENTORY.md"
CONCURRENCY="$ROOT/docs/architecture/CONCURRENCY_INVENTORY.md"

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

echo "Registry catalog inventory budgets passed (#warning $entropy_catalog, concurrency $concurrency_catalog)."