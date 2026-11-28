# ADR 0007: `@unchecked Sendable` inventory

## Status

Accepted (PR #153).

## Context

After eliminating `nonisolated(unsafe)` (ADR 0006), remaining concurrency erasure uses `@unchecked Sendable` on classes, structs, and conditional conformances. Without a catalog, agents reintroduce ad hoc patterns.

## Decision

1. **Inventory:** `UNCHECKED_SENDABLE_INVENTORY.md` lists every `@unchecked Sendable` site in `Sources/Xcore` with a one-line role; `audit_unchecked_sendable_inventory.sh` keeps the total in sync.
2. **Budget:** New annotations require updating the inventory and `GOVERNANCE_METRICS.md` in the same change.
3. **Preference order:** (a) make the type properly `Sendable`, (b) `LockIsolated` storage on a `Sendable` façade, (c) `ReferenceBox` / `MutableReferenceBox` / `Weak` for conditional cases, (d) `@unchecked Sendable` only when Foundation/UIKit types or legacy closure storage block (a)–(c). See ADR 0009 when macOS CI disproves (a)–(b) for specific sites.
4. **Ban:** Do not pair `@unchecked Sendable` with `nonisolated(unsafe)` mutable fields.

## Consequences

- `GOVERNANCE_METRICS` and `REGISTRY_CATALOG` include the unchecked count alongside concurrency and `#warning` budgets.
- Reduction rounds update the inventory downward; increases are reviewed like public API growth.