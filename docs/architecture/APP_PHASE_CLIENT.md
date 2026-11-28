# App phase client (P-003)

SSOT for `AppPhaseClient` (`EventsClient<AppPhase>`) and its **live** dependency defaults in tests.

## Shape

| Item | Value |
| --- | --- |
| Type | `typealias AppPhaseClient = EventsClient<AppPhase>` |
| Dependency key | `appPhase` |
| `liveValue` | `.live` |
| `testValue` | **`.live`** (exception) |
| `previewValue` | **`.live`** (exception) |

## Why test uses `.live`

`AppPhase` drives lifecycle integration (delegate forwarding, delayed operations, stream receivers). Tests that assert real phase transitions need a functional hub:

| Test file | Behavior under test |
| --- | --- |
| `AppPhaseClientTests` | Send/receive phase events through `.live` |
| `AppPhaseOperationTests` | `AppPhaseOperation` executes on `.background` / `.willEnterForeground` (timing skips on CI) |

Defaulting to `.unimplemented` would force every suite to override `appPhase`, add noise to `DependencyKeyDefaultsTests`, and break stream semantics tests that expect delivery.

## Concurrency (not P-003)

`AppPhase` is `@unchecked Sendable` because cases carry UIKit launch-option payloads (`UNCHECKED_SENDABLE_INVENTORY.md`, `UNCHECKED_SENDABLE_ROADMAP.md`). **P-003** governs dependency `testValue` / `previewValue` only; removing `@unchecked` is a separate lever (payload redesign), not resolved by switching defaults to `.unimplemented`.

## Product gate (P-003)

Switching `testValue` / `previewValue` to `.unimplemented` is allowed only when:

1. All phase tests use explicit `withDependencies { $0.appPhase = … }` overrides documented here.
2. `DependencyKeyDefaultsTests` expectations are updated.
3. `DEPENDENCY_REGISTRY.md` exception row and `audit_dependency_keys.sh` allowlist are removed in the same change.

## Enforcement

- `audit_dependency_keys.sh` — requires `testValue` / `previewValue` `.live` and registry **P-003** row.
- `audit_dependency_client_shapes.sh` — sole `EventsClient` typealias client.

## Related

- [DEPENDENCY_REGISTRY.md](./DEPENDENCY_REGISTRY.md) — Key default exceptions
- [TEST_CI_POLICY.md](./TEST_CI_POLICY.md) — `AppPhaseOperationTests` CI timing skips