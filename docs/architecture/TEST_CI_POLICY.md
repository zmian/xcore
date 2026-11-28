# CI test policy

Hosted macOS CI (`make test` with `-DCI`) must not run integration tests that depend on live geocoding, external HTTP/WebKit redirects, or simulator timing.

## Summary

| Mechanism | Count | Notes |
| --- | ---: | --- |
| `#if !CI` compile exclusion | 1 suite | `LiveAddressSearchClientTests` (5 methods) |
| `@Test(.disabled(if: TestEnvironment.isCI))` | 4 | See table below |

**Runtime CI skips: 4** (`audit_ci_test_policy.sh`).

## Compile exclusion (`#if !CI`)

| File | Reason |
| --- | --- |
| `Tests/XcoreTests/Clients/LiveAddressSearchClientTests.swift` | Live `AddressSearchClient` geocoding |

## Global Theme SSOT (parallel tests)

`Theme.defaultSpacing` and `Theme.interItemHSpacing` are process-wide SSOT values. Under parallel `make test`, another test can mutate them before `ThemeLayoutTests` runs.

| File | Test | Guard |
| --- | --- | --- |
| `Tests/XcoreTests/Components/ThemeLayoutTests.swift` | `spacingScaleMatchesDocumentation` | Resets `Theme.defaultSpacing = 20` and `Theme.interItemHSpacing = 12` before `s1`…`s8` assertions (T-101). Enforced by `audit_theme_test_isolation.sh`. |
| `Tests/XcoreTests/Components/ThemeLayoutTests.swift` | `defaultSpacingForwardsToDefaultTheme` | Same Theme reset before forwarder assertions (T-131; parallel CI). |
| `Tests/XcoreTests/Components/ThemeLayoutTests.swift` | `listRowInsetsFollowDefaultSpacing` | Same Theme reset before mutating `defaultSpacing` (T-128; parallel CI). |

## Runtime skips

| File | Test | Reason |
| --- | --- | --- |
| `Tests/XcoreTests/URLTests.swift` | `resolvingRedirectedLink` | External redirect / WebKit |
| `Tests/XcoreTests/DateTests.swift` | `formatted_relative_until_month` | Runner date/locale formatting |
| `Tests/XcoreTests/Clients/AppPhaseOperationTests.swift` | `operationExecutesAfterDelay` | Simulator timing |
| `Tests/XcoreTests/Clients/AppPhaseOperationTests.swift` | `operationCancelledBeforeExecution` | Simulator timing |

## Workflow guards

- `Makefile`: per-test execution allowance (5 minutes) when `CI` is set; `make test` uses unfiltered `xcodebuild` output on CI.
- `.github/workflows/ci.yml`: job timeout 60 minutes; Test step timeout 45 minutes.
- **Install tools:** `brew install ripgrep swiftlint swiftformat` (audits require `rg` on the runner).
- **Architecture audit shell:** GitHub-hosted macOS uses **Bash 3.2** (`/bin/bash`). Audit scripts must not use `mapfile`, `declare -A`, or `head -n -` (see T-060, T-061, T-129). Enforced by `audit_ci_test_policy.sh`.

## Swift Testing + `swift-dependencies`

XCTest installs `testValue` automatically; **Swift Testing does not**. Regression pattern (`DependencyKeyDefaultsTests`):

1. Wrap the body in `withDependencies { $0 = .test }`.
2. Wrap calls that hit production `testValue` (`.unimplemented`) in `withExpectedIssue { … }`.
3. Avoid touching `UIPasteboard.general` in default tests (use `PasteboardClientTests` for live vs noop); simulators can hang under parallel testing.

Related: T-050, T-051, T-056–T-058 in `TASK_POOL.md`.