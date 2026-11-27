# Architecture audit index

Run from repo root: **`make audit-architecture`** (no Xcode). Wired in `.github/workflows/ci.yml`.

| Script | Enforces |
| --- | --- |
| `BuildTools/Scripts/audit_dependency_keys.sh` | Every `DependencyKey` has `testValue`; `previewValue` when `noop`/`empty` exists (see ADR 0001–0002). |
| `BuildTools/Scripts/audit_concurrency_inventory.sh` | `nonisolated(unsafe)` count matches `CONCURRENCY_INVENTORY.md`. |
| `BuildTools/Scripts/audit_module_placement.sh` | `DependencyKey` under `Swift/Dependencies/` (Pond excepted); no `IssueReporting`; canonical `Unimplemented:` strings (ADR 0003). |
| `BuildTools/Scripts/audit_compiler_warnings.sh` | `#warning` count matches `ENTROPY_INVENTORY.md`. |

Related docs: `PROGRESS.md`, `TASK_POOL.md`, `ARCHITECTURE_MAP.md`, `adr/*`.

Behavioral regression: macOS `make build` / `make test` (includes composite registration tests).