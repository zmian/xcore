# `@unchecked Sendable` — macOS CI evidence

SSOT for reduction attempts that **failed** `build-test-lint` on GitHub Actions (strict concurrency). Agents must not re-apply these patterns without a new lever (API redesign, not `LockIsolated` alone).

| ID | Site | Attempt | CI failure | Tasks |
| --- | --- | --- | --- | --- |
| E-001 | `Popup.TransitionStorage` | plain `Sendable` | `AnyTransition` not `Sendable` | T-088 |
| E-002 | `UserDefaultsPond` | plain `Sendable` | `UserDefaults` not `Sendable` | T-115 |
| E-003 | `AssociatedObjectKey` | plain `Sendable` | `UnsafeRawPointer` stored property | T-118 |
| E-004 | `ValuePublisher` | conditional `Sendable` | `CurrentValueSubject` stored property | T-119 |
| E-005 | `ValidationRule.regex(Regex)` | delete `RegexValidationPattern` | `Regex<Output>` capture in `@Sendable` closure | T-116, T-121 |
| E-006 | `Publisher.done` | `LockIsolated<Set<AnyCancellable>>` | `AnyCancellable` not `Sendable` in `@Sendable` closure | T-117, T-122 |

**Enforced:** `audit_unchecked_sendable_ci_holds.sh` (ADR 0009; canonical holders / annotations for E-003–E-006).