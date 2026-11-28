# Swift/Extensions index

**Foundation/stdlib extensions** under `Sources/Xcore/Swift/Extensions/`.  
Domain components live in `COMPONENT_INDEX.md`; cross-cutting primitives in `HELPERS_INDEX.md`.

**Total: 4** domain folders (`audit_extensions_index.sh`).  
**Root files: 24** single-file extensions at the directory root (same audit).

| Folder | Responsibility |
| --- | --- |
| `Codable/` | JSON/codable helpers, `Failable`, `CodingFormatStyle` family |
| `Numbers/` | Decimal/double math, format styles, `NumberFormatter` |
| `String/` | Parsing, formatting, localization, safe subscripts |
| `URL/` | Redirect resolution, security-scoped resources, sensitive query items |

## Root extensions (same directory)

`Array+Extensions`, `Bool+Extensions`, `Bundle+Extensions`, `CaseIterable+Extensions`, `CharacterSet+Extensions`, `Collection+Extensions`, `Collection+Safe`, `Collection+Sort`, `Data+Extensions`, `Dictionary+Extensions`, `Error+Extensions`, `Geometry+Extensions`, `HTTPCookieStorage+Extensions`, `KeychainAccess+Extensions`, `Locale+Extensions`, `Logger+Extensions`, `MainActor+Extensions`, `Mutex+Extensions`, `Optional+Extensions`, `OptionSet+Extensions`, `ProcessInfo+Extensions`, `Range+Extensions`, `Result+Extensions`, `UUID`.

Place new **grouped** APIs in a folder; add a row when introducing a new top-level folder.