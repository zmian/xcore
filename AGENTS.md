# AGENTS

This repo targets the latest iOS, Xcode, and Swift releases plus an example app.

## Verification

Run verification from the repo root through the Makefile. Do not use `swift test`
or ad-hoc `xcodebuild`.

- `make build` — compile the `Example` scheme in `Xcore.xcworkspace`.
- `make test` — run the full suite through the `Example` scheme.
- `make test TEST_ONLY=XcoreTests/SomeTests/someTest` — run one relevant test.
- `make run` — build, install, and launch the example app.
- `make build-docc` — generate DocC static site output under `.build/docc`.
- `make lint` / `make format-check` — SwiftLint / SwiftFormat checks.
- `make format` — apply SwiftFormat.
- `make clean` — reset derived data and repo-local build state.

Rules:

- Use `make build` for compile errors, warnings, and API-shape changes.
- Use `make test TEST_ONLY=...` only for tests directly tied to the change.
- Do not use unrelated tests as a proxy.
- Do not run multiple `make` / `xcodebuild` jobs in the same checkout.
- If verification fails strangely after interruption or concurrency, run
  `make clean` and retry.
- If Xcode is unavailable, say so and list the exact `make` commands to run.

The Makefile sets `DEVELOPER_DIR` to `/Applications/Xcode.app/Contents/Developer`
and uses `Xcore.xcworkspace` + the `Example` scheme. That is the supported path.

## Code Standards

- Use the latest iOS, Xcode, Swift, and SwiftUI APIs.
- Do not add backwards-compatibility shims, `@available` fallbacks, or legacy API
  workarounds unless explicitly requested.
- Keep fixes direct. Add abstraction only when it removes real complexity.
- Public API changes need docs matching nearby public API docs.
- Breaking API or behavior changes are allowed when they improve correctness or
  modernity. Do not preserve legacy behavior by default.
- For SwiftUI and concurrency warnings, follow the framework API contract; do not
  add unsafe workarounds.

## Architecture governance

Ongoing entropy reduction is tracked under `docs/architecture/` — start with
`docs/architecture/GOVERNANCE_SUMMARY.md` and `docs/architecture/REGISTRY_CATALOG.md`.
Registries: `DEPENDENCY_REGISTRY.md`, `COMPONENT_INDEX.md`, `SWIFTUI_COMPONENT_INDEX.md`.
Before adding a `@Dependency` client, read `docs/architecture/adr/0002-dependency-client-template.md`.
Concurrency: no `nonisolated(unsafe)` in `Sources/Xcore`; associated keys use `UInt8` tokens (`adr/0006-concurrency-and-associated-keys.md`). New `@unchecked Sendable` requires `UNCHECKED_SENDABLE_INVENTORY.md` (`adr/0007-unchecked-sendable-inventory.md`).

Verification without Xcode: `make audit-architecture` (**32** checks; see
`docs/architecture/AUDIT_INDEX.md`). macOS CI needs Homebrew `ripgrep`; audit shell scripts
target Bash 3.2 (no `mapfile` / `declare -A`).

## Fixed Decisions

- Xcore is one Swift package target: `import Xcore`. Folders (`Swift/`,
  `SwiftUI/`, `Cocoa/`) are organization only. Do not propose submodule splits
  unless asked or backed by measured build-time pain.
- Keep `zmian/AnyCodable` on `master`. Do not pin it, replace it with an in-repo
  type, remove `@_exported import AnyCodable`, or rework `CodingFormatStyle`
  unless a built-in Swift/Foundation feature is clearly better than the current
  AnyCodable implementation.
