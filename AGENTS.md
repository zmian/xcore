# AGENTS

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
- No Xcode in your environment? Say so and give the exact `make` commands to run.

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

## Platform & API Standards

- Target **iOS 26+ / Xcode 26+ / Swift 6.3** only. Use current SDK and SwiftUI APIs.
- Prefer the latest framework patterns over legacy or deprecated approaches.
- Do not add backwards-compatibility shims, `@available` fallbacks, or old API
  workarounds unless the task explicitly asks for them.
- Do not compromise on quality, correctness, or documentation for speed.
- Public API changes should include the same level of inline docs as surrounding
  code (usage examples, parameter docs, links where helpful).

## Repo-Specific Preferences

- Keep fixes direct. Avoid wrappers or extra abstraction unless they are
  clearly required.
- Breaking API or behavior changes are acceptable when they improve correctness
  or modernity. Do not preserve legacy behavior by default.
- For SwiftUI and concurrency warnings, prefer a minimal fix that matches the
  framework API contract instead of adding unsafe workarounds.

## Package Layout

Xcore is one Swift package target: `import Xcore`. Folders (`Swift/`, `SwiftUI/`,
`Cocoa/`) organize code; they are not separate modules.

- Do not propose splitting into submodules as a default refactor.
- Builds are fast enough for this repo; link-time dead code stripping keeps
  unused APIs out of app binaries.
- Revisit splitting only for measured build-time pain or an explicit new public
  product requirement.

## AnyCodable

- Keep `zmian/AnyCodable` on `master`. Do not pin it unless asked.
- Do not replace it with an in-repo type (e.g. `JSONValue`) or rework
  `CodingFormatStyle` unless asked.
- Do not remove `@_exported import AnyCodable` from `Xcore.swift`.
