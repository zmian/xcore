# Spacing scale (layout SSOT)

Canonical spacing tokens for Xcore UI. **Theme-owned** metrics forward through `CGFloat` for source compatibility.

## Theme-owned (mutable at launch)

| Key | Default | `CGFloat` forwarder |
| --- | --- | --- |
| `cornerRadius` | 15 | `AppConstants.cornerRadius` |
| `defaultSpacing` | 20 (was `.s5`) | `CGFloat.defaultSpacing` |
| `interItemHSpacing` | 12 (was `.s3`) | `CGFloat.interItemHSpacing` |
| `listRowInsets` | uniform `defaultSpacing` | `EdgeInsets.listRow` |

Enforced by `audit_layout_ssot.sh` (`Theme.init` defaults use `CGFloat.s5` / `.s3`), `audit_spacing_scale.sh` (s3/s5 parity), and `audit_theme_test_isolation.sh` ([`TEST_CI_POLICY.md`](./TEST_CI_POLICY.md)). Prefer `@Environment(\.theme)` in SwiftUI.

## Fixed scale (`CGFloat.s1`…`s8`)

| Token | Points |
| --- | --- |
| `s1` | 4 |
| `s2` | 8 |
| `s3` | 12 |
| `s4` | 16 |
| `s5` | 20 |
| `s6` | 24 |
| `s7` | 28 |
| `s8` | 32 |

Frozen as `public static let` on `CGFloat` in `Constants.swift`. Enforced by `audit_spacing_scale.sh`.