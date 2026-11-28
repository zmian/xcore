#!/usr/bin/env bash
# Validates DependencyKey enums under Sources/Xcore declare testValue (and previewValue when noop/empty exists).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SOURCES="$ROOT/Sources/Xcore"
ALLOWLIST_TEST=(
  # P-003: lifecycle client intentionally uses live in tests
  "Sources/Xcore/Swift/Dependencies/AppPhase/AppPhaseClient.swift"
)
ALLOWLIST_PREVIEW=(
  "Sources/Xcore/Swift/Dependencies/AppPhase/AppPhaseClient.swift"
)

key_files=()
while IFS= read -r line; do
  key_files+=("$line")
done < <(rg --no-heading -l '^\s*(private\s+)?enum\s+\w+.*:\s*DependencyKey' "$SOURCES" || true)

test_failures=()
preview_failures=()

for file in "${key_files[@]}"; do
  rel="${file#"$ROOT/"}"
  skip_test=false
  for allowed in "${ALLOWLIST_TEST[@]}"; do
    if [[ "$rel" == "$allowed" ]]; then
      skip_test=true
      break
    fi
  done
  if ! $skip_test && ! grep -q 'testValue' "$file"; then
    test_failures+=("$rel")
  fi

  client_dir="$(dirname "$file")"
  if rg -q 'public static var (noop|empty)' "$client_dir" --glob '*.swift' 2>/dev/null; then
    skip_preview=false
    for allowed in "${ALLOWLIST_PREVIEW[@]}"; do
      if [[ "$rel" == "$allowed" ]]; then
        skip_preview=true
        break
      fi
    done
    if ! $skip_preview && ! grep -q 'previewValue' "$file"; then
      preview_failures+=("$rel")
    fi
  fi
done

failed=false

if ((${#test_failures[@]} > 0)); then
  failed=true
  echo "DependencyKey audit failed — missing testValue:"
  printf '  - %s\n' "${test_failures[@]}"
fi

if ((${#preview_failures[@]} > 0)); then
  failed=true
  echo "DependencyKey audit failed — missing previewValue (noop/empty variant exists):"
  printf '  - %s\n' "${preview_failures[@]}"
fi

if $failed; then
  echo "See docs/architecture/adr/0001-dependency-client-registration.md"
  exit 1
fi

REGISTRY="$ROOT/docs/architecture/DEPENDENCY_REGISTRY.md"
APP_PHASE="$ROOT/Sources/Xcore/Swift/Dependencies/AppPhase/AppPhaseClient.swift"

if ! grep -q 'P-003' "$REGISTRY"; then
  echo "DEPENDENCY_REGISTRY.md must document P-003 AppPhase test/preview exception"
  exit 1
fi

if ! grep -q 'static let testValue: AppPhaseClient = \.live' "$APP_PHASE"; then
  echo "AppPhaseClient testValue must remain .live until P-003 resolves (update registry + allowlist if intentional)"
  exit 1
fi

if ! grep -q 'static let previewValue: AppPhaseClient = \.live' "$APP_PHASE"; then
  echo "AppPhaseClient previewValue must remain .live until P-003 resolves (update registry + allowlist if intentional)"
  exit 1
fi

if ! grep -q '| `appPhase`' "$REGISTRY" || ! grep -q 'Key default exceptions' "$REGISTRY"; then
  echo "DEPENDENCY_REGISTRY.md must list appPhase under Key default exceptions"
  exit 1
fi

echo "DependencyKey audit passed (${#key_files[@]} DependencyKey file(s))."