# Cocoa supporting areas (Blocks & Protocols)

UIKit integration primitives outside `Cocoa/Components/`.  
Components: [COCOA_COMPONENT_INDEX.md](./COCOA_COMPONENT_INDEX.md).

**Blocks files: 4** · **Protocols files: 1** (`audit_cocoa_supporting_index.sh`).

## Blocks (`Cocoa/Blocks/`)

Block-based target/action wiring for controls, gestures, and mail compose.

| File | Role |
| --- | --- |
| `UIControl+Blocks.swift` | Control target-action with closures |
| `UIGestureRecognizer+Blocks.swift` | Gesture handlers with associated storage |
| `MFMailComposeViewController+Blocks.swift` | Mail compose completion blocks |
| `TargetActionBlockRepresentable.swift` | Shared representable for block actions |

## Protocols (`Cocoa/Protocols/`)

| File | Role |
| --- | --- |
| `ExtensibleByAssociatedObject.swift` | Associated-object key pattern for extensions |