# Architecture decision records

| ADR | Title |
| --- | --- |
| [0001](./0001-dependency-client-registration.md) | Dependency client registration + registry |
| [0002](./0002-dependency-client-template.md) | Struct dependency client template |
| [0003](./0003-module-boundaries.md) | Module placement and unimplemented copy |
| [0004](./0004-composite-registration.md) | Composite provider/fetcher registration |
| [0005](./0005-metadata-and-theme-globals.md) | Metadata, theme, layout SSOT |
| [0006](./0006-concurrency-and-associated-keys.md) | Zero `nonisolated(unsafe)`; LockIsolated; UInt8 associated keys |
| [0007](./0007-unchecked-sendable-inventory.md) | `@unchecked Sendable` inventory + preference order |
| [0008](./0008-product-gates-index.md) | `PRODUCT_GATES.md` index + audits for P-00x gates |

Add a new ADR when introducing cross-cutting rules agents must not rediscover.