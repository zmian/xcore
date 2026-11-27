# Architecture optimization task pool

Tasks are independent unless marked **blocked by**. Status: `ready` | `in-progress` | `pending-confirmation` | `done`.

## Ready

| ID | Task | Rationale |
| --- | --- | --- |
| T-010 | Add `previewValue` to clients that have `.noop` but omit preview (`AudioPlayerClient`, `RequestReviewClient`, `AddressSearchClient`) | Align with SessionCounter / HapticFeedback pattern |
| T-011 | Document canonical `@Dependency` client template in ADR | Single source for new clients |
| T-012 | Audit `FeatureFlag` / `Analytics` / `ImageFetcher` composite APIs for redundant surface area | Deletion test on registration overloads |
| T-013 | SwiftLint opt-in rule or expanded audit for file placement (`Dependencies/` vs `Components/`) | Enforceable boundaries |

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