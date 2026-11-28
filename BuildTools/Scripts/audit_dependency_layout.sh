#!/usr/bin/env bash
# Ensures DEPENDENCY_LAYOUT.md matches Swift/Dependencies on disk.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LAYOUT="$ROOT/docs/architecture/DEPENDENCY_LAYOUT.md"
DEPS="$ROOT/Sources/Xcore/Swift/Dependencies"

live_subfolders="$(find "$DEPS" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
live_root="$(find "$DEPS" -maxdepth 1 -name '*Client.swift' ! -name 'EventsClient.swift' | wc -l | tr -d ' ')"
doc_subfolders="$(rg -o 'Total subfolders: [0-9]+' "$LAYOUT" | head -1 | rg -o '[0-9]+' || true)"
doc_root="$(rg -o 'Total production root clients: [0-9]+' "$LAYOUT" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$doc_subfolders" || -z "$doc_root" ]]; then
  echo "Could not read totals from DEPENDENCY_LAYOUT.md"
  exit 1
fi

if [[ "$live_subfolders" != "$doc_subfolders" ]]; then
  echo "Dependency layout subfolders: $live_subfolders on disk, doc says $doc_subfolders"
  exit 1
fi

if [[ "$live_root" != "$doc_root" ]]; then
  echo "Dependency layout root clients: $live_root on disk, doc says $doc_root"
  exit 1
fi

subfolder_rows="$(awk '/^## Subfolders/,/^## Root-level/' "$LAYOUT" | rg '^\| `[^`]+/` \|' | wc -l | tr -d ' ')"
root_rows="$(awk '/^## Root-level/,/^## Templates/' "$LAYOUT" | rg '^\| `[^`]+` \|' | wc -l | tr -d ' ')"

if [[ "$subfolder_rows" != "$doc_subfolders" ]]; then
  echo "DEPENDENCY_LAYOUT subfolder table has $subfolder_rows rows, Total says $doc_subfolders"
  exit 1
fi

if [[ "$root_rows" != "$doc_root" ]]; then
  echo "DEPENDENCY_LAYOUT root client table has $root_rows rows, Total says $doc_root"
  exit 1
fi

echo "Dependency layout audit passed ($live_subfolders subfolders, $live_root root clients)."