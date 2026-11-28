#!/usr/bin/env bash
# Ensures dependency client shape drift (protocol / typealias / struct) matches ENTROPY_INVENTORY.md.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INVENTORY="$ROOT/docs/architecture/ENTROPY_INVENTORY.md"
DEPS="$ROOT/Sources/Xcore/Swift/Dependencies"
ADDRESS_SEARCH_DOC="$ROOT/docs/architecture/ADDRESS_SEARCH_CLIENT.md"
ADDRESS_SEARCH_DIR="$DEPS/AddressSearch"

expected_protocol=0
expected_typealias=1

doc_protocol="$(
  awk -F'|' '/^\| Protocol \+ conformers \|/ { gsub(/^ +| +$/, "", $3); print $3; exit }' "$INVENTORY"
)"
doc_typealias="$(
  awk -F'|' '/^\| Typealias over `EventsClient` \|/ { gsub(/^ +| +$/, "", $3); print $3; exit }' "$INVENTORY"
)"

if [[ -z "$doc_protocol" || -z "$doc_typealias" ]]; then
  echo "Could not read dependency client shape counts from ENTROPY_INVENTORY.md"
  exit 1
fi

[[ "$doc_protocol" == "$expected_protocol" ]] || {
  echo "ENTROPY_INVENTORY protocol client count must be $expected_protocol (got $doc_protocol)"
  exit 1
}

[[ "$doc_typealias" == "$expected_typealias" ]] || {
  echo "ENTROPY_INVENTORY EventsClient typealias count must be $expected_typealias (got $doc_typealias)"
  exit 1
}

live_protocol=0
while IFS= read -r _; do
  live_protocol=$((live_protocol + 1))
done < <(rg --no-heading 'public protocol \w+Client' "$DEPS" --glob '*.swift' || true)

[[ "$live_protocol" == "$expected_protocol" ]] || {
  echo "Expected $expected_protocol public protocol client(s) under Swift/Dependencies; found $live_protocol"
  exit 1
}

live_typealias=0
while IFS= read -r line; do
  [[ "$line" == *"EventsClient.swift:"* ]] && continue
  live_typealias=$((live_typealias + 1))
done < <(rg --no-heading 'typealias \w+Client = EventsClient' "$DEPS" --glob '*.swift' || true)

[[ "$live_typealias" == "$expected_typealias" ]] || {
  echo "Expected $expected_typealias EventsClient typealias client(s); found $live_typealias"
  exit 1
}

if ! rg -q 'typealias AppPhaseClient = EventsClient' "$DEPS/AppPhase/AppPhaseClient.swift"; then
  echo "AppPhaseClient must remain the EventsClient typealias client"
  exit 1
fi

if [[ ! -f "$ADDRESS_SEARCH_DOC" ]]; then
  echo "Missing docs/architecture/ADDRESS_SEARCH_CLIENT.md"
  exit 1
fi

if ! rg -q 'public struct AddressSearchClient: Sendable' "$DEPS/AddressSearch/Client/AddressSearchClient.swift"; then
  echo "AddressSearchClient must be a public struct client (ADR 0002)"
  exit 1
fi

if rg -q '(class|struct) \w+: AddressSearchClient' "$ADDRESS_SEARCH_DIR" --glob '*.swift' 2>/dev/null; then
  echo "AddressSearchClient protocol conformers are forbidden (use struct client variants)"
  exit 1
fi

echo "Dependency client shapes audit passed (protocol $live_protocol, EventsClient typealias $live_typealias, AddressSearchClient struct)."