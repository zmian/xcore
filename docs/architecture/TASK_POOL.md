# Architecture optimization task pool

Tasks are independent unless marked **blocked by**. Status: `ready` | `in-progress` | `pending-confirmation` | `done`.

## Ready

| ID | Task | Rationale |
| --- | --- | --- |
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
| T-021 | UnimplementedAnalyticsProvider + repo-wide IssueReporting ban |
| T-022 | ADR 0005 metadata/theme SSOT; ImageFetcherCompositeTests; README |
| T-023 | AUDIT_INDEX + FeatureFlag composite dedupe test + ADR 0004 exception |
| T-024 | Remove ProminentButtonStyle `#warning`; DependencyKeyDefaultsTests |
| T-025 | GOVERNANCE_SUMMARY + pasteboard dependency default test |
| T-026 | DEPENDENCY_REGISTRY + audit script |
| T-027 | Theme `cornerRadius` SSOT; `AppConstants` forwarder; library call sites |
| T-028 | `audit_layout_ssot.sh` + CI wiring |
| T-029 | Theme `defaultSpacing` / `interItemHSpacing`; SPACING_SCALE.md |
| T-030 | Freeze `s1`…`s8` + `audit_spacing_scale.sh` |
| T-031 | `audit_composite_registration.sh` (ADR 0004) |
| T-032 | `COMPONENT_INDEX.md` + `audit_component_index.sh`; registry key names |