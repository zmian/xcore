# Production `DependencyValues` registry

Authoritative list of dependency keys shipped in the **Xcore** package (app-defined clients are out of scope).  
`make audit-architecture` verifies this count matches `DependencyKey` enums in `Sources/Xcore`.

**Total: 14**

| Key | Type | Location |
| --- | --- | --- |
| `addressSearch` | `AddressSearchClient` | `Swift/Dependencies/AddressSearch/` |
| `appMonitoring` | `AppMonitoring` | `Swift/Dependencies/AppMonitoring/` |
| `appPhase` | `AppPhaseClient` (`EventsClient<AppPhase>`) | `Swift/Dependencies/AppPhase/` |
| `appStatus` | `AppStatusClient` | `Swift/Dependencies/AppStatus/` |
| `audioPlayer` | `AudioPlayerClient` | `Swift/Dependencies/AudioPlayerClient/` |
| `hapticFeedback` | `HapticFeedbackClient` | `Swift/Dependencies/HapticFeedback/` |
| `imageColor` | `ImageColorClient` | `Swift/Dependencies/` |
| `openURL` | `OpenURLClient` | `Swift/Dependencies/` |
| `pasteboard` | `PasteboardClient` | `Swift/Dependencies/` |
| `pond` | `Pond` | `SwiftUI/Components/Pond/` (allowlisted placement) |
| `pushNotifications` | `PushNotificationsClient` | `Swift/Dependencies/PushNotificationsClient/` |
| `qrCode` | `QRCodeClient` | `Swift/Dependencies/` |
| `requestReview` | `RequestReviewClient` | `Swift/Dependencies/RequestReview/` |
| `sessionCounter` | `SessionCounterClient` | `Swift/Dependencies/SessionCounter/` |

## Patterns

- **Struct clients:** default shape per ADR 0002.
- **Struct client:** all 14 keys use closure struct shape (ADR 0002), including `addressSearch`.
- **Typealias client:** `appPhase` over `EventsClient` (ADR 0004).
- **Template:** `EventsClient<Event>` — host apps register their own keys (documented in source).

## Key default exceptions

| Key | `testValue` | `previewValue` | Notes |
| --- | --- | --- | --- |
| `appPhase` | `.live` | `.live` | Lifecycle/event hub for delegate forwarding and timing tests (**P-003**). Allowlisted in `audit_dependency_keys.sh`; do not switch to `.unimplemented` without product confirmation. |