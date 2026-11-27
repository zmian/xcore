# Layer import boundaries

ADR 0003: UIKit/AppKit code lives under `Cocoa/`; SwiftUI under `SwiftUI/`. Cross-layer imports are exceptions, not defaults.

## Cocoa importing SwiftUI

**Total: 4** allowed files (`audit_cocoa_swiftui_imports.sh`).

| File | Rationale |
| --- | --- |
| `Cocoa/Components/HUD/UIHostingWindow.swift` | HUD hosts SwiftUI content |
| `Cocoa/Components/UIImage/ImageView.swift` | SwiftUI-backed image view bridge |
| `Cocoa/Extensions/UIColor+Extensions.swift` | `Color` / SwiftUI interop |
| `Cocoa/Extensions/UIFont/UIFont+Typeface.swift` | `Font` bridging for typeface |

New `import SwiftUI` under `Sources/Xcore/Cocoa/` requires updating this table and the audit allowlist.