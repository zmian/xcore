# ADR 0004: Composite registration pattern

## Status

Accepted (2026-11-27)

## Context

Feature flags, image fetchers, and analytics all maintain ordered lists of pluggable providers/fetchers with duplicate-id prevention. Slight inconsistencies (e.g. deduping on init) create divergent behavior and agent confusion.

## Decision

Composites that register types with `id: String`:

1. **Initialize** with `elements.uniqued(\.id)` (first occurrence wins).
2. **`add`** skips when `contains(where: { $0.id == … })`.
3. **`remove`** targets by `id` via index lookup.
4. **Public registration** (e.g. `FeatureFlag.register`, `UIImage.Fetcher.register`) delegates to the composite; do not expose parallel registration globals.

`Analytics` is instance-scoped rather than static; same duplicate-id rules apply via `register` / `finalProviders`.

Event multiplexing for app lifecycle uses `EventsClient<Event>` with `AppPhaseClient` as a typealias — not a second event bus implementation.

## Exceptions

- **`CompositeImageTransform`** intentionally allows duplicate transform steps with the same `id` (e.g. applying alpha twice). Pipeline semantics differ from provider registration; do not apply init deduplication there.

## Consequences

- `CompositeImageFetcher` inits dedupe like `CompositeFeatureFlagProvider`.
- New registration-style composites in Xcore should copy this checklist; variadic `register` overloads are optional ergonomics only.

## Compliance

- Documented in `ENTROPY_INVENTORY.md`
- `audit_composite_registration.sh` checks init `uniqued(\.id)` and `add` guards; `CompositeImageTransform` exempt.
- Regression: composite init behavior covered by existing fetcher/feature tests where present; audits do not replace behavioral tests for fetch ordering