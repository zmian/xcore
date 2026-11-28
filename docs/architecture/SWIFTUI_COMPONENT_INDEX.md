# SwiftUI/Components index

Domain folders under `Sources/Xcore/SwiftUI/Components/`.  
Loose files at the same level (e.g. `BoundedView.swift`, `Separator.swift`) are shared UI primitives.

**Total: 21** (`audit_swiftui_component_index.sh`).

| Folder | Responsibility |
| --- | --- |
| `Button` | Button styles, timer/mail/filter controls |
| `CoverViews` | Full-screen cover placeholders |
| `DataStatusView` | Loading / empty / error presentation |
| `Device` | Environment device metadata |
| `DynamicTextField` | Formattable fields and styles |
| `Environment` | SwiftUI environment keys |
| `InternalViews` | Package-private view helpers |
| `Label` | Label styles |
| `LabeledContent` | Settings-style labeled rows |
| `List` | List row styles |
| `PageView` | Paging / story views |
| `Pond` | Typed storage (`@Dependency` allowlisted) |
| `Popup` | Alerts, toasts, windows |
| `ProgressViewStyle` | Progress indicators |
| `Readers` | `EnvironmentReader` utilities |
| `Shapes` | Custom shapes |
| `Sheets` | Fitted sheet content |
| `Theme` | `Theme` model and defaults (ADR 0005) |
| `Toggle` | Toggle/checkbox styles |
| `ToolbarContent` | Toolbar helpers |
| `WebView` | `WKWebView` wrapper |

Add a row before landing substantial new UI domains.