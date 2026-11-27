# Architecture optimization task pool

Tasks are independent unless marked **blocked by**. Status: `ready` | `in-progress` | `pending-confirmation` | `done`.

## Ready

| ID | Task | Rationale |
| --- | --- | --- |
| T-016 | Reduce mutable globals in `Constants.swift` / `FeatureFlag.provider` via injection | Concurrency inventory hotspots |
| T-019 | Resolve tracked `#warning` items (see ENTROPY_INVENTORY) | Deletion / modernization |

## Pending confirmation

| ID | Task | Question |
| --- | --- | --- |
| P-001 | Converge `AddressSearchClient` from protocol to struct client | Breaking for conformers outside repo? |
| P-002 | Remove `Date.LegacyFormatStyle` per in-file note | Any apps still depend on legacy phrasing? |
| P-003 | `AppPhaseClient` testValue uses `.live` | Keep for integration tests or switch to `.unimplemented`? |

## Done

| ID | Task |
| --- | --- |
| T-001 | Governance docs + worktree setup |
| T-002 | Normalize `testValue` / `previewValue` on four dependency clients |
| T-003 | `audit_dependency_keys.sh` + CI wiring |
| T-010 | `previewValue` on AudioPlayer, RequestReview, AddressSearch, Pond |
| T-011 | ADR 0002 dependency client template |
| T-012 | Composite registration API deletion test (no removals) |
| T-015 | `CONCURRENCY_INVENTORY.md` + count audit script |
| T-013 | `audit_module_placement.sh` + ADR 0003 |
| T-014 | `AGENTS.md` architecture governance section |
| T-017 | Canonical `Unimplemented:` messages in all `Swift/Dependencies` clients |
| T-018 | Pond unimplemented messages + audit scope |
| T-020 | ENTROPY_INVENTORY + ADR 0004 composite registration; ImageFetcher init dedupe |