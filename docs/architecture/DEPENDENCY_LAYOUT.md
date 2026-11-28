# Swift/Dependencies layout

All production `@Dependency` keys (except `pond`) live under `Sources/Xcore/Swift/Dependencies/`.  
Canonical key list: [DEPENDENCY_REGISTRY.md](./DEPENDENCY_REGISTRY.md).

**Total subfolders: 9** · **Total production root clients: 4** (`audit_dependency_layout.sh`).

## Subfolders (domain clients)

| Folder | Keys |
| --- | --- |
| `AddressSearch/` | `addressSearch` |
| `AppMonitoring/` | `appMonitoring` |
| `AppPhase/` | `appPhase` |
| `AppStatus/` | `appStatus` |
| `AudioPlayerClient/` | `audioPlayer` |
| `HapticFeedback/` | `hapticFeedback` |
| `PushNotificationsClient/` | `pushNotifications` |
| `RequestReview/` | `requestReview` |
| `SessionCounter/` | `sessionCounter` |

## Root-level client files

| File | Key |
| --- | --- |
| `ImageColorClient.swift` | `imageColor` |
| `OpenURLClient.swift` | `openURL` |
| `PasteboardClient.swift` | `pasteboard` |
| `QRCodeClient.swift` | `qrCode` |

## Templates (not production keys)

| File | Role |
| --- | --- |
| `EventsClient.swift` | Host apps define typed event clients (see ADR 0002) |

Exception: `pond` → `SwiftUI/Components/Pond/` (ADR 0003).