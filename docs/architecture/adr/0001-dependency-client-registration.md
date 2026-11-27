# ADR 0001: Canonical `@Dependency` client registration

## Status

Accepted (2026-11-27)

## Context

Xcore exposes many services through Point-Free's `swift-dependencies` (`DependencyValues`). Clients live under `Sources/Xcore/Swift/Dependencies/` (and a few in SwiftUI, e.g. `Pond`).

An architecture scan found inconsistent `DependencyKey` implementations: most clients define `liveValue`, `testValue`, and often `previewValue`, while `PasteboardClient`, `OpenURLClient`, `ImageColorClient`, and `QRCodeClient` defined only `liveValue`. Tests using `withDependencies` without overrides could accidentally hit live pasteboard or URL opening behavior.

## Decision

1. **Every production `DependencyKey` in `Sources/Xcore` must declare `testValue`.**
2. **Default test value** is the client's `.unimplemented` variant when one exists; otherwise `.noop` or a documented exception.
3. **When a client exposes `.noop`, also declare `previewValue: .noop`** for SwiftUI previews (matches SessionCounter, HapticFeedback, PushNotifications).
4. **Exceptions** are listed in `BuildTools/Scripts/audit_dependency_keys.sh` with a comment explaining why.

## Consequences

- Safer tests: default test context does not perform live side effects.
- New clients must follow the same shape (documented in code review + audit script).
- `AppPhaseClient` retains `testValue: .live` until product confirms otherwise (exception P-003).

## Compliance

- Automated: `make audit-architecture` / `BuildTools/Scripts/audit_dependency_keys.sh`
- CI: runs audit on every PR alongside build/test/lint