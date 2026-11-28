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

## Runtime skips

| File | Test | Reason |
| --- | --- | --- |
| `Tests/XcoreTests/URLTests.swift` | `resolvingRedirectedLink` | External redirect / WebKit |
| `Tests/XcoreTests/DateTests.swift` | `formatted_relative_until_month` | Runner date/locale formatting |
| `Tests/XcoreTests/Clients/AppPhaseOperationTests.swift` | `operationExecutesAfterDelay` | Simulator timing |
| `Tests/XcoreTests/Clients/AppPhaseOperationTests.swift` | `operationCancelledBeforeExecution` | Simulator timing |

## Workflow guards

- `Makefile`: `-parallel-testing-enabled NO` when `CI` is set.
- `.github/workflows/ci.yml`: job timeout 45 minutes; Test step timeout 30 minutes.

Related: T-050, T-051 in `TASK_POOL.md`.