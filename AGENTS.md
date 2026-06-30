# AGENTS

## Scope

These notes are for agents working in this repository.

The repo is an iOS 26+ / Xcode 26+ Swift package plus example app. Prefer the
repo Makefile and workspace-based Xcode flow over ad-hoc commands.

## Primary Verification Path

Use the Makefile from the repo root.

- `make build`
  Builds the `Example` scheme in `Xcore.xcworkspace`.
- `make test`
  Runs the full test suite through the `Example` scheme.
- `make test TEST_ONLY=XcoreTests/SomeTests/someTest`
  Runs a single targeted test.
- `make run`
  Builds, installs, and launches the example app in the configured simulator.
- `make clean`
  Clears derived data and repo-local workspace state used by the Make targets.
- `make lint`
  Runs SwiftLint.
- `make format`
  Runs SwiftFormat.

## Verification Rules

- Prefer `make build` for compile errors, warnings, and API-shape changes that
  are not tied to one specific test.
- Prefer `make test TEST_ONLY=...` only when the test is directly relevant to
  the behavior being changed.
- Do not use an unrelated test target as a proxy just because it is convenient.
- Prefer `make test` over `swift test` for real verification in this repo.

## Why Makefile First

- The Makefile forces `DEVELOPER_DIR` to `/Applications/Xcode.app/Contents/Developer`.
  This matters on machines where `xcode-select` points at Command Line Tools.
- Tests run through `Xcore.xcworkspace` and the `Example` scheme.
- The `Xcore` scheme is not the correct default verification path for tests.
- `swift test` is not the reliable fallback for this repo.

## Test Output Notes

- `make test` uses `xcodebuild test -quiet`.
- This suppresses Xcode boilerplate such as package-resolution chatter and
  command invocation noise.
- Test progress is intentionally preserved.
- The Makefile also strips known Xcode metadata noise such as:
  `[MT] IDERunDestination: Supported platforms for the buildables in the current scheme is empty.`
- Test lines are normalized to remove simulator-specific suffixes while keeping
  the suite/test name and duration.

Example:

```text
Test suite 'URLTests' started
Test case 'URLTests/resolvingRedirectedLink()' passed (12.001 seconds)
```

## Concurrency / Execution Notes

- Do not run multiple `make` or `xcodebuild` verification commands in parallel
  against the same checkout.
- Parallel runs can corrupt or confuse package-resolution and derived-data state.
- If verification starts failing in weird ways after interrupted or concurrent
  builds, run `make clean` and retry.

## Repo-Specific Preferences

- Keep fixes direct. Avoid wrappers or extra abstraction unless they are
  clearly required.
- Preserve existing public API shape when possible.
- For SwiftUI and concurrency warnings, prefer a minimal fix that matches the
  framework API contract instead of adding unsafe workarounds.

## Architecture: Single-Module Design

Xcore intentionally ships as **one Swift package target** (`Xcore`) and **one
library product** (`import Xcore`). Do not propose splitting the package into
submodules (for example `XcoreCore`, `XcoreSwiftUI`, `XcoreUIKit`) unless there
is measured, repo-specific pain — not as a default refactor suggestion.

### Why one module

- **Single import** matches how the library is documented and consumed.
- **Folder layout already separates concerns** — `Sources/Xcore/Swift/`,
  `Sources/Xcore/SwiftUI/`, and `Sources/Xcore/Cocoa/` organize code without
  package-boundary overhead.
- **No current compile-time crisis** — the target is ~400 Swift sources; clean
  and incremental builds have been acceptable in practice on Xcode 26+.
  Splitting adds cross-target visibility rules, duplicate public surface
  decisions, and migration cost for little gain unless build times regress
  measurably.
- **This is a utility kit, not a tiered SDK** — consumers adopt Xcore as a
  whole; optional sub-products would add API and release complexity without a
  stated requirement.

### Binary size (fact check)

Do **not** recommend module splitting to reduce app binary size.

When an app links Xcore, **dead code stripping** (link-time, enabled by default
for Release app targets) removes unreferenced machine code from the linked
result. Unused APIs from Xcore are not a reason, by themselves, to split the
package.

Nuances worth knowing (so advice stays accurate):

- Stripping happens at **link time in the app**, based on what the app actually
  references — not because Xcore is split into multiple targets.
- Swift **`public`** symbols are treated more conservatively than `internal`
  symbols at link time; Apple has been improving link-time internalization for
  static linking. Even so, splitting Xcore into multiple modules does not change
  the basic model for an app that imports the full library.
- **SPM dependencies** (`SDWebImage`, `KeychainAccess`, etc.) are declared on the
  Xcore package. Internal target splits do not remove those dependencies unless
  separate public products with different dependency lists are introduced — that
  is a much larger product decision, not a routine refactor.
- If Xcore were distributed as a **dynamic framework**, the framework binary is
  shipped as a unit; that packaging choice is separate from how many targets exist
  inside the repo.

### When splitting would be worth revisiting

Only if concrete, measured problems appear, such as:

- Clean or incremental build times become a recurring bottleneck on real
  hardware (profile with `xcodebuild` timing before proposing splits).
- A **new public product** is required (for example a core-only library with no
  UIKit/SwiftUI dependencies) with an explicit consumer and release plan.
- Enforced layering cannot be maintained with folders and code review alone.

Until then, treat the monolithic module as **intentional design**, not tech debt.
