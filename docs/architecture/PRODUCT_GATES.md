# Product gates (pending confirmation)

Central index for architecture work that needs product input before code removal or behavior change. Agents may expand audits/docs independently; **do not** close a gate without updating this file and the linked SSOT.

| ID | Topic | SSOT | Status |
| --- | --- | --- | --- |
| P-002 | Remove `Date.LegacyFormatStyle` | [DATE_LEGACY_FORMAT.md](./DATE_LEGACY_FORMAT.md) | Pending |
| P-003 | `AppPhaseClient` `testValue` / `previewValue` `.live` | [APP_PHASE_CLIENT.md](./APP_PHASE_CLIENT.md) | Pending |

## Resolved gates

| ID | Resolution | SSOT |
| --- | --- | --- |
| P-001 | `AddressSearchClient` → struct client (T-107) | [ADDRESS_SEARCH_CLIENT.md](./ADDRESS_SEARCH_CLIENT.md) |

## Enforcement

`audit_product_gates.sh` verifies this index matches the SSOT files referenced above.