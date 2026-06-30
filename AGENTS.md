# AGENTS

iOS 26+ / Xcode 26+ Swift package + Example app. Use the Makefile and
`Xcore.xcworkspace` — not ad-hoc `swift` / `xcodebuild` commands.

## Verify

```bash
make build          # compile
make test           # full suite
make test TEST_ONLY=XcoreTests/SomeTests/someTest
make lint
make format
make clean          # if builds act weird
```

- Use `make build` for compile/API changes; `make test TEST_ONLY=...` only for
  relevant tests. Not `swift test`.
- Tests run via `Example` scheme in `Xcore.xcworkspace`, not the `Xcore` scheme.
- Do not run parallel `make` / `xcodebuild` on the same checkout.
- No Xcode in your environment? Say so and give the exact `make` commands to run.

## Code

- iOS 26 / Xcode 26 / Swift 6.3 only. Current APIs. No backwards-compat shims
  unless asked.
- Direct fixes. Match existing docs for public API changes.
- Breaking changes OK when asked or clearly better. No legacy preservation by default.

## Do not suggest

- Splitting Xcore into submodules (one target by design; folders are enough).
- Replacing, pinning, or removing `@_exported import AnyCodable` (`zmian/AnyCodable`
  `master` fork — intentional for `CodingFormatStyle`).
