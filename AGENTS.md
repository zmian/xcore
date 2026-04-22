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
