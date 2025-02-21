<p align="center">
<picture>
  <source srcset="Resources/xcore_logo_dark.svg" media="(prefers-color-scheme: dark)"/>
  <img src="Resources/xcore_logo.svg" alt="Xcore logo" height=80>
</picture>
</p>
<h1></h1>

Xcore is a collection of hundreds of Swift extensions and components designed to minimize boilerplate to accomplish common tasks with ease. It is a framework to efficiently build and scale apps without compromising quality, maintainability and developer productivity. Check out the included example project and [documentation](https://zmian.github.io/xcore) to see how.

## Contents

- [Requirements](#requirements)
- [Makefile](#makefile)
- [Installation](#installation)

## Requirements

- iOS 17.0+
- Xcode 16.2+
- Swift 6.0+

**Additional Requirements**

- [Swift Package Manager](https://swift.org/package-manager/)
- [SwiftLint][swiftlint-link]
- [SwiftFormat][swiftformat-link]

## Makefile

We use make file to provide some useful shortcuts. Run any of the below commands at the project root level.

- `make test` Runs all tests
- `make lint` Runs SwiftLint
- `make format` Runs SwiftFormat

## Installation

Xcore is available through Swift Package Manager. To integrate it into a project, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/zmian/xcore", branch: "main")
    ],
    ...
)
```

<!-- TODO: Fix DocC script -->
<!-- ## Documentation -->
<!-- You can find [the documentation here](https://zmian.github.io/xcore). -->

## Author

- [Zeeshan Mian](https://github.com/zmian) ([@zmian](https://twitter.com/zmian))

## License

Xcore is released under the MIT license. [See LICENSE](https://github.com/zmian/xcore/blob/main/LICENSE) for details.

[swiftlint-link]: https://github.com/realm/SwiftLint
[swiftformat-link]: https://github.com/nicklockwood/SwiftFormat
