# Xcore architecture governance (agent quick start)

**Branch / PR:** ongoing on `cursor/architecture-governance-825b` ([#153](https://github.com/zmian/xcore/pull/153)).

## Before you edit

1. Read [ADR 0002](./adr/0002-dependency-client-template.md) when adding `@Dependency` clients.
2. Run `make audit-architecture` (Linux-safe) before push.
3. Update [TASK_POOL.md](./TASK_POOL.md) for pending product decisions; do not block on them.

## Single source of truth

Production dependency keys: [DEPENDENCY_REGISTRY.md](./DEPENDENCY_REGISTRY.md) (14 keys).

## Rules enforced in CI

| Rule | ADR |
| --- | --- |
| Dependency keys: `live` + `test` + `preview` when `noop` exists | 0001, 0002 |
| Keys live under `Swift/Dependencies/` (except `Pond`) | 0003 |
| `reportIssue` for unimplemented; no `IssueReporting` | 0003 |
| Registration composites dedupe by `id` | 0004 |
| Metadata: `UserInfoContainer`, `AppConstants`, `FeatureFlag.provider` | 0005 |

## Inventories

- [ENTROPY_INVENTORY.md](./ENTROPY_INVENTORY.md) — parallel implementations, `#warning` budget (5)
- [CONCURRENCY_INVENTORY.md](./CONCURRENCY_INVENTORY.md) — `nonisolated(unsafe)` budget (62)
- [PROGRESS.md](./PROGRESS.md) — completed rounds

## macOS verification

`make build` · `make test` · `make lint` (Xcode required)