# Formatting defaults (SSOT)

Frozen numeric and masking defaults in `Constants.swift`. Apps that need different values should use explicit parameters at call sites, not mutate globals.

| Symbol | Type | Value | Consumers |
| --- | --- | --- | --- |
| `mask` | `Character` | `•` | `String` masked formatting |
| `defaultFractionDigits` | `Int` | 2 | Money, number format styles |
| `maxFractionDigits` | `Int` | 100 | High-precision fraction formatters |
| `defaultRandomUpperBound` | `Int` | 100 | `String.random(length:)` default |
| `defaultRandomUpperBound` | `Double` | 100 | `Double.random` upper bound |

Enforced by `audit_formatting_defaults.sh`.