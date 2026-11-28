# `@unchecked Sendable` inventory

Living snapshot of deliberate Sendable erasure in `Sources/Xcore`. **Total: 14 annotations** (regenerate with `make audit-architecture`).

Agents: prefer `LockIsolated`, frozen `static let`, or `ReferenceBox` before adding new `@unchecked Sendable`. Never combine with `nonisolated(unsafe)` (ADR 0006).

## Canonical primitives (conditional conformance)

| Location | Role |
| --- | --- |
| `ReferenceBox.swift` | `ReferenceBox` / `MutableReferenceBox` when `Value: Sendable` |
| `Weak.swift` | `Weak` when `Value: Sendable` |
| `ValuePublisher.swift` | `ValuePublisher` when `Output: Sendable` |

## Dependency clients (live + handlers)

| Location | Role |
| --- | --- |
| `PushNotificationsClient+Live.swift` | `NSObject` live client |
| `PushNotificationsClient.swift` | `NotificationReceivedHandler` (non-Sendable closure storage) |
| `SessionCounterClient+Live.swift` | Live client with locked storage |
| `AppPhaseClient.swift` | `AppPhase` enum payloads |

## Components (shared mutable or UIKit bridges)

| Location | Role |
| --- | --- |
| `Analytics.swift` | Open analytics hub |
| `Money.swift` | `Appearance` styling box |
| `Popup.swift` | `TransitionStorage` (`AnyTransition`) |
| `CodingFormatStyle+Formatter.swift` | `FormatterCodingFormatStyle` bridges `Formatter` |
| `PondKey.swift` / `Pond+UserDefaults.swift` | Pond storage variants |

**Resolved (Round 68):** `ImageDownloaderCancelToken` uses `@Sendable` closure; `CompositeImageFetcher` and `MockAnalyticsProvider` are `Sendable` via `LockIsolated` (T-083).

**Resolved (Round 69):** `CAMediaTimingFunction` presets use frozen `static let`; `SessionAwareCache` is `Sendable` via `LockIsolated` session state (T-084).

Regressions: `BuildTools/Scripts/audit_unchecked_sendable_inventory.sh` compares live count to the total above.