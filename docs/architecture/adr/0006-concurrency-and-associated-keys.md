# ADR 0006: Concurrency storage and associated-object keys

## Status

Accepted (PR #153).

## Context

Swift 6 strict concurrency required widespread `nonisolated(unsafe)` across globals, UIKit bridges, and associated-object key storage. That eroded agent-safe invariants and was tracked in `CONCURRENCY_INVENTORY.md`.

## Decision

1. **`Sources/Xcore` budget:** **0** `nonisolated(unsafe)` annotations. `audit_concurrency_inventory.sh` and `GOVERNANCE_METRICS.md` enforce the total.
2. **Mutable shared state:** Prefer `LockIsolated` with public get/set when a frozen `static let` is insufficient (dependency registries, theme defaults, mocks).
3. **Non-Sendable UIKit/AVFoundation handles:** Hold instances in `LockIsolated` or an `@unchecked Sendable` box with no `nonisolated(unsafe)` field.
4. **Associated-object keys:** Use `private enum AssociatedKey { static let name = AssociatedObjectKey() }` and pass `AssociatedKey.name` to `associatedObject` / `setAssociatedObject`. Do not use mutable `UInt8` globals, string-literal keys, or `nonisolated(unsafe)` on key storage.

## Consequences

- `audit_associated_object_keys.sh` rejects `nonisolated(unsafe)` and string-literal keys in `AssociatedKey` enums.
- New associated values must follow `ExtensibleByAssociatedObject` documentation in `ExtensibleByAssociatedObject.swift`.
- Product/breaking refactors (e.g. `AddressSearchClient` shape) remain in `TASK_POOL.md` under **Pending confirmation**.