#!/usr/bin/env bash
# Enforces macOS-CI-proven @unchecked holds (UNCHECKED_SENDABLE_CI_EVIDENCE.md).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SOURCES="$ROOT/Sources/Xcore"
EVIDENCE="$ROOT/docs/architecture/UNCHECKED_SENDABLE_CI_EVIDENCE.md"

if [[ ! -f "$EVIDENCE" ]]; then
  echo "Missing UNCHECKED_SENDABLE_CI_EVIDENCE.md"
  exit 1
fi

fail=0

if ! rg -q 'RegexValidationPattern' "$SOURCES/Swift/Components/Validation/ValidationRule+Rules.swift"; then
  echo "Missing RegexValidationPattern holder (CI E-005; see UNCHECKED_SENDABLE_CI_EVIDENCE.md)"
  fail=1
fi

if ! rg -q 'class DoneSubscriberCancellables: @unchecked Sendable' "$SOURCES/Swift/Components/Combine/Publisher+Extensions.swift"; then
  echo "Missing DoneSubscriberCancellables @unchecked (CI E-006)"
  fail=1
fi

if rg -q 'LockIsolated\(Set<AnyCancellable>\)' "$SOURCES/Swift/Components/Combine/Publisher+Extensions.swift"; then
  echo "Publisher.done must not use LockIsolated<Set<AnyCancellable>> (CI E-006)"
  fail=1
fi

if ! rg -q 'struct AssociatedObjectKey: @unchecked Sendable' "$SOURCES/Cocoa/Protocols/ExtensibleByAssociatedObject.swift"; then
  echo "AssociatedObjectKey must remain @unchecked Sendable (CI E-003)"
  fail=1
fi

if ! rg -q 'struct UserDefaultsPond: Pond, @unchecked Sendable' "$SOURCES/SwiftUI/Components/Pond/Variants/Pond+UserDefaults.swift"; then
  echo "UserDefaultsPond must remain @unchecked Sendable (CI E-002)"
  fail=1
fi

if ! rg -q 'extension ValuePublisher: @unchecked Sendable' "$SOURCES/Swift/Components/Combine/ValuePublisher.swift"; then
  echo "ValuePublisher must keep @unchecked conditional Sendable (CI E-004)"
  fail=1
fi

if [[ "$fail" -ne 0 ]]; then
  exit 1
fi

echo "Unchecked Sendable CI holds audit passed (6 evidence rows enforced)."