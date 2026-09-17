# Contextual UI APIs and warning fixes

These changes replace process-wide UI assumptions with explicit view or scene
context. No compiler warnings are disabled.

| Previous API | Replacement |
| --- | --- |
| `Device.screen` | `Device.current.screen(in: windowScene)` or `Screen(scene: windowScene)` on the main actor |
| `CGFloat.onePixel` | `CGFloat.onePixel(displayScale:)`; obtain the scale from SwiftUI's `displayScale` environment or a view's trait collection |
| `AppConstants.smallScreenSize` / `mediumScreenSize` | Pass the available layout size to `smallScreenSize(_:)` / `mediumScreenSize(_:)` |
| `AppConstants.aspect(_:axis:)` / `remaining(axis:)` | Pass the available layout size using `in:` |
| App-delegate URL forwarding | Forward SwiftUI `onOpenURL` to `.openURL(url)`, or configure `PhaseForwarderSceneDelegate` for UIKit scenes |
| `AppPhase.openURL` dictionary options | Optional `UIScene.OpenURLOptions`, retaining UIKit's scene options |

Borders and separators resolve their default one-pixel width from the environment
at rendering time. Explicit widths remain measured in points. Popup width is a
maximum constrained by its container, rather than a value derived from a global
screen.

`SimplePhotoPicker` ties loading to selection and view lifetime. Its `onFailure`
closure reports load/decode failures (the default logs them); cancellation does
not report an error or deliver a stale image. `UIImageView.setImage` now calls its
completion with `nil` on failure, enabling its documented fallback behavior, and
ignores superseded requests.

Region-validation messages now use localized country names and locale-aware lists.
MapKit's deprecated `placemark.postalAddress` access remains pending a data-source
or API decision: its documented replacement does not provide equivalent structured
postal fields. It is not suppressed. A Foundation address-detector migration was
rejected after live tests demonstrated lost administrative-area and apartment data.

Biometric kind comes from LocalAuthentication; unavailable biometrics are no
longer guessed from display dimensions.

References: [MapKit address representations](https://sosumi.ai/documentation/mapkit/mkaddressrepresentations),
[scene URL options](https://sosumi.ai/documentation/uikit/uiscene/openurloptions),
and [Swift isolated conformances](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0470-isolated-conformances.md).
