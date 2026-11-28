# Layer import boundaries

ADR 0003: UIKit/AppKit code lives under `Cocoa/`; SwiftUI under `SwiftUI/`. Cross-layer imports are exceptions, not defaults. Enforced by `audit_layer_imports.sh`.

## Cocoa importing SwiftUI

**Allowlist count: 4**

| File | Rationale |
| --- | --- |
| `Cocoa/Components/HUD/UIHostingWindow.swift` | HUD hosts SwiftUI content |
| `Cocoa/Components/UIImage/ImageView.swift` | SwiftUI-backed image view bridge |
| `Cocoa/Extensions/UIColor+Extensions.swift` | `Color` / SwiftUI interop |
| `Cocoa/Extensions/UIFont/UIFont+Typeface.swift` | `Font` bridging for typeface |

## Swift/Components importing UIKit

**Allowlist count: 3**

| File | Rationale |
| --- | --- |
| `Swift/Components/Assets/SystemAssetIdentifier.swift` | Asset catalog / symbol resolution |
| `Swift/Components/Combine/Publishers.swift` | UIKit notification publishers |
| `Swift/Components/Configuration/Configuration.swift` | UI appearance configuration hooks |

Update the relevant section, allowlist in `audit_layer_imports.sh`, and ADR 0003 before adding new cross-layer imports.