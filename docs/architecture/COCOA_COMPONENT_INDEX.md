# Cocoa layer index

Authoritative map of **domain folders** under `Sources/Xcore/Cocoa/Components/`.  
Sibling areas (`Blocks/`, `Extensions/`, `Protocols/`) are documented below but not included in **Total**.

**Total: 3** domain folders (`audit_cocoa_component_index.sh`).

| Folder | Responsibility |
| --- | --- |
| `HUD` | Blocking HUD overlay + hosting window |
| `Swizzle` | Method swizzling helpers and manager |
| `UIImage` | Fetcher pipeline, representable plugins, transforms (ADR 0004 composites) |

## Root primitives (`Components/`)

`AnimationRunLoop`, `PassthroughView`, `SpacerView`, `UIAccessibility+ReturnFocus`, `UIAnimator`, `WKWeakDelegate`, `XCView`.

## Sibling areas

| Area | Role |
| --- | --- |
| Blocks | Block-based targets — [COCOA_SUPPORTING_INDEX.md](./COCOA_SUPPORTING_INDEX.md) |
| Extensions | UIKit / AVFoundation extensions — [COCOA_EXTENSIONS_INDEX.md](./COCOA_EXTENSIONS_INDEX.md) |
| Protocols | Associated-object pattern — [COCOA_SUPPORTING_INDEX.md](./COCOA_SUPPORTING_INDEX.md) |

Place new **image / HUD / swizzle** domains under `Components/`; add a table row before merging substantial features.