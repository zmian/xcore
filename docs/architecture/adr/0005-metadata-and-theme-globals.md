# ADR 0005: Metadata and theme global state

## Status

Accepted (2026-11-27)

## Context

Xcore uses `UserInfoContainer` for typed metadata bags (analytics, errors, feature flags, pond keys) and `AppConstants` / `Theme.default` for shared layout and theme defaults. These use `nonisolated(unsafe)` mutable statics (see `CONCURRENCY_INVENTORY.md`). Agents need a single documented owner for each concern.

## Decision

### Typed metadata

- **`UserInfoContainer`** (`UserInfoKey.swift`) is the only pattern for `[Key: any Sendable]` metadata on domain types.
- Do not introduce parallel userInfo dictionaries or `[String: Any]` bags on public types.

### Feature flags

- **`FeatureFlag.provider`** (composite) is the single registration point; apps call `FeatureFlag.register` only.

### Layout and theme defaults

- **`AppConstants`** / `CGFloat` / `EdgeInsets` layout forwarders in `Constants.swift` delegate `cornerRadius`, `defaultSpacing`, `interItemHSpacing`, and `listRow` to `Theme.default`.
- **`Theme.default`** owns SwiftUI theme defaults, including those layout metrics.
- **`Theme.init`** default spacing uses frozen `CGFloat.s5` / `.s3` (not raw point literals); enforced by `audit_layout_ssot.sh` (T-139).
- Fixed scale `s1`…`s8` is frozen on `CGFloat` (`static let`); see `SPACING_SCALE.md` + `audit_spacing_scale.sh`.
- Parallel `make test` resets global spacing via `resetThemeSpacingSSOTForParallelTesting()` in `ThemeLayoutTests` (`@Suite(.serialized)`, T-153); see `TEST_CI_POLICY.md` + `audit_theme_test_isolation.sh` (T-135–T-137).
- `ThemeLayoutTests` uses frozen `CGFloat.s*` tokens for spacing/corner-radius mutations and `#expect` (no bare point literals); T-161–T-164.
- Masking and fraction/random defaults are frozen on `Character` / `Int` / `Double`; see `FORMATTING_DEFAULTS.md` + `audit_formatting_defaults.sh`.
- Mutating these at launch is supported for app branding; new globals must be added here (not scattered), and `CONCURRENCY_INVENTORY.md` updated when `nonisolated(unsafe)` count changes.

### Future injection (T-016)

Prefer `@Dependency` or constructor injection for *new* cross-cutting configuration. Migrating existing `AppConstants` mutators is optional and breaking-sensitive; document before moving.

## Consequences

- Entropy inventory tracks global hotspots.
- `audit_layout_ssot.sh` bans direct `AppConstants.cornerRadius` use outside `Constants.swift`.
- `audit_theme_test_isolation.sh` enforces parallel reset + scale tokens in `ThemeLayoutTests` (cross-checked by `audit_ci_test_policy.sh`).
- No automated ban on other `AppConstants` spacing mutations yet; concurrency audit tracks annotation count.