#!/usr/bin/env bash
# Ensures COCOA_SUPPORTING_INDEX.md matches Cocoa/Blocks and Cocoa/Protocols.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INDEX="$ROOT/docs/architecture/COCOA_SUPPORTING_INDEX.md"
BLOCKS="$ROOT/Sources/Xcore/Cocoa/Blocks"
PROTOCOLS="$ROOT/Sources/Xcore/Cocoa/Protocols"

live_blocks="$(find "$BLOCKS" -maxdepth 1 -name '*.swift' | wc -l | tr -d ' ')"
live_protocols="$(find "$PROTOCOLS" -maxdepth 1 -name '*.swift' | wc -l | tr -d ' ')"
doc_blocks="$(rg -o 'Blocks files: [0-9]+' "$INDEX" | head -1 | rg -o '[0-9]+' || true)"
doc_protocols="$(rg -o 'Protocols files: [0-9]+' "$INDEX" | head -1 | rg -o '[0-9]+' || true)"

if [[ -z "$doc_blocks" || -z "$doc_protocols" ]]; then
  echo "Could not read Blocks/Protocols totals from COCOA_SUPPORTING_INDEX.md"
  exit 1
fi

if [[ "$live_blocks" != "$doc_blocks" || "$live_protocols" != "$doc_protocols" ]]; then
  echo "Cocoa supporting index out of date: blocks $live_blocks/$doc_blocks, protocols $live_protocols/$doc_protocols"
  exit 1
fi

blocks_rows="$(awk '/^## Blocks/,/^## Protocols/' "$INDEX" | rg '^\| `[^`]+` \|' | wc -l | tr -d ' ')"
protocol_rows="$(awk '/^## Protocols/,0' "$INDEX" | rg '^\| `[^`]+` \|' | wc -l | tr -d ' ')"

if [[ "$blocks_rows" != "$doc_blocks" || "$protocol_rows" != "$doc_protocols" ]]; then
  echo "COCOA_SUPPORTING_INDEX table rows do not match declared totals"
  exit 1
fi

echo "Cocoa supporting index audit passed ($live_blocks blocks, $live_protocols protocols)."