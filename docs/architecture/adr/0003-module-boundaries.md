# ADR 0003: Module and file placement boundaries

## Status

Accepted (2026-11-27)

## Context

Xcore uses folder conventions (`Swift/`, `SwiftUI/`, `Cocoa/`) without separate SPM targets. Without enforcement, dependency registration and UI coupling drift across folders and confuse parallel agent work.

## Decision

### Dependency registration location

- Any `DependencyKey` enum must live in:
  - `Sources/Xcore/Swift/Dependencies/**`, or
  - The documented exception: `Sources/Xcore/SwiftUI/Components/Pond/Pond.swift` (storage tied to SwiftUI environment).

### Dependency client files

- Files named `*Client.swift` that extend `DependencyValues` must live under `Swift/Dependencies/`.
- App-specific clients belong in the app target, following ADR 0002.

### Unimplemented diagnostics

- Dependency `unimplemented` variants use `reportIssue` with a `#"Unimplemented: @Dependency(\.key)"#` string (or method-qualified suffix).
- Other unimplemented test doubles (e.g. `UnimplementedAnalyticsProvider`) use `reportIssue` with `#"Unimplemented: Type.method"#`.
- Do not use `IssueReporting.unimplemented` in `Sources/Xcore`.

### UI coupling (documented, not fully automated)

- Prefer UIKit/AppKit APIs in `Cocoa/`, SwiftUI in `SwiftUI/`.
- `Swift/Components/` may import SwiftUI for types shared with views (e.g. `Money`); new UIKit-only code should not land there without justification.

## Consequences

- `audit_module_placement.sh` runs under `make audit-architecture`.
- New `DependencyKey` types in `Swift/Components` fail CI.
- Agents adding clients follow a single directory rule.

## Compliance

Automated: `BuildTools/Scripts/audit_module_placement.sh`