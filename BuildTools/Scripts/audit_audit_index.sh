#!/usr/bin/env bash
# Ensures AUDIT_INDEX.md lists exactly the scripts wired in Makefile audit-architecture.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MAKEFILE="$ROOT/Makefile"
INDEX="$ROOT/docs/architecture/AUDIT_INDEX.md"

mapfile -t makefile_scripts < <(rg -o 'audit_[a-z0-9_]+\.sh' "$MAKEFILE" | sort -u)
mapfile -t index_scripts < <(rg -o 'audit_[a-z0-9_]+\.sh' "$INDEX" | sort -u)

missing_in_index=()
for script in "${makefile_scripts[@]}"; do
  if ! printf '%s\n' "${index_scripts[@]}" | rg -q "^${script}$"; then
    missing_in_index+=("$script")
  fi
  if [[ ! -f "$ROOT/BuildTools/Scripts/$script" ]]; then
    echo "Missing script: BuildTools/Scripts/$script"
    exit 1
  fi
done

if ((${#missing_in_index[@]} > 0)); then
  echo "Makefile audit scripts not documented in AUDIT_INDEX.md:"
  printf '  %s\n' "${missing_in_index[@]}"
  exit 1
fi

extra_in_index=()
for script in "${index_scripts[@]}"; do
  if ! printf '%s\n' "${makefile_scripts[@]}" | rg -q "^${script}$"; then
    extra_in_index+=("$script")
  fi
done

if ((${#extra_in_index[@]} > 0)); then
  echo "AUDIT_INDEX.md documents scripts not wired in Makefile:"
  printf '  %s\n' "${extra_in_index[@]}"
  exit 1
fi

echo "Audit index catalog passed (${#makefile_scripts[@]} scripts)."