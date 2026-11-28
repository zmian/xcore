# ADR 0002: `@Dependency` client file template

## Status

Accepted (2026-11-27)

## Context

Xcore dependency clients should look identical across the module so agents and humans can add services without reinventing structure. ADR 0001 covers key registration; this ADR standardizes the full file shape.

## Decision

### Placement

- Platform / service clients: `Sources/Xcore/Swift/Dependencies/<Name>/`
- UI-adjacent storage (`Pond`): `Sources/Xcore/SwiftUI/Components/Pond/` (existing)
- App hosts define app-specific clients in the app target using the same template (see `EventsClient` doc comment).

### Struct client template

```swift
/// DocC-style overview + Usage example with @Dependency.
public struct ExampleClient: Sendable {
    public let perform: @Sendable () -> Void

    public init(perform: @escaping @Sendable () -> Void) {
        self.perform = perform
    }
}

// MARK: - Variants

extension ExampleClient {
    public static var noop: Self { .init(perform: {}) }

    public static var unimplemented: Self {
        .init {
            reportIssue(#"Unimplemented: @Dependency(\.example)"#)
        }
    }

    // Use `reportIssue`, not `IssueReporting.unimplemented` (see ADR 0003).

    public static var live: Self {
        .init { /* real implementation */ }
    }
}

// MARK: - Dependency

extension DependencyValues {
    private enum ExampleClientKey: DependencyKey {
        static let liveValue: ExampleClient = .live
        static let testValue: ExampleClient = .unimplemented
        static let previewValue: ExampleClient = .noop
    }

    public var example: ExampleClient {
        get { self[ExampleClientKey.self] }
        set { self[ExampleClientKey.self] = newValue }
    }
}
```

### Protocol client (exceptional)

Protocol-based dependency clients are not used in Xcore production keys (`AddressSearchClient` converged to struct — T-107).

### Variants

| Variant | Purpose |
| --- | --- |
| `live` | Production behavior |
| `unimplemented` | Tests and missing overrides (`testValue`) |
| `noop` / `empty` | Previews and passive defaults (`previewValue`) |

## Consequences

- Audits in `audit_dependency_keys.sh` enforce `testValue` and, when `noop`/`empty` exists nearby, `previewValue`.
- New clients that copy this template pass CI without additional checklist steps.