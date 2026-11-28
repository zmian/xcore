# Legacy date formatting (P-002)

SSOT for `Date.LegacyFormatStyle` until product confirms removal.

## Why it exists

`Date.Formatted.Style.dateTime` with `doesRelativeDateFormatting: true` and a **non-omitted time** still needs `DateFormatter`-style relative phrasing (e.g. “Today at 9:41 AM”). Swift’s `Date.FormatStyle` does not cover that combination; `Date+Formatted.swift` routes that path through `.legacy`.

## Canonical usage in Xcore

| Location | Role |
| --- | --- |
| `Date+Formatted.swift` | Single production call: relative `dateTime` + time component |
| `Date+LegacyFormatStyle.swift` | Implementation (marked for eventual deletion in-source) |

**Budget:** **1** `.legacy` formatting call site in `Sources/Xcore` outside `Date+LegacyFormatStyle.swift`.

## Enforcement

- `audit_date_legacy_format.sh` — budgeted `.legacy` call sites + canonical `Date+Formatted.swift` path.
- `audit_product_gates.sh` — `PRODUCT_GATES.md` P-002 row links this doc.

## Product gate (P-002)

Removal is allowed only when:

1. No downstream apps rely on `.legacy` or `Date.LegacyFormatStyle` directly.
2. The relative+time path is replaced with a Foundation API that matches output, or a behavior change is accepted.
3. `Date+LegacyFormatStyle.swift` is deleted and `ENTROPY_INVENTORY` + this doc are updated.

## Related

- [ENTROPY_INVENTORY.md](./ENTROPY_INVENTORY.md) — modern vs legacy formatting row
- [TASK_POOL.md](./TASK_POOL.md) — **P-002**