# Legacy date formatting (P-002)

SSOT for `Date.LegacyFormatStyle` until product confirms removal.

## Why it exists

`Date.Formatted.Style.dateTime` with `doesRelativeDateFormatting: true` and a **non-omitted time** still needs `DateFormatter`-style relative phrasing (e.g. “Today at 9:41 AM”). Swift’s `Date.FormatStyle` does not cover that combination; `Date+Formatted.swift` routes that path through `.legacy`.

## Canonical usage in Xcore

| Location | Role |
| --- | --- |
| `Date+Formatted.swift` | Single production call: relative `dateTime` + time component |
| `Date+LegacyFormatStyle.swift` | Implementation (marked for eventual deletion in-source) |

**Budget:** **1** `.legacy` formatting call site in `Sources/Xcore` outside `Date+LegacyFormatStyle.swift` (enforced by `audit_date_legacy_format.sh`).

## Removal criteria (P-002)

1. Confirm no downstream apps rely on `.legacy` or `Date.LegacyFormatStyle` directly.
2. Replace relative+time path with a Foundation API that matches output, or accept behavior change.
3. Delete `Date+LegacyFormatStyle.swift` and update `ENTROPY_INVENTORY` + this doc.

## Related

- [ENTROPY_INVENTORY.md](./ENTROPY_INVENTORY.md) — modern vs legacy formatting row
- [TASK_POOL.md](./TASK_POOL.md) — **P-002**