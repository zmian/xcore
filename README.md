<p align="center">
<img src="Resources/xcore_logo.svg" alt="Xcore logo" height=80>
</p>
<p align="center">
    <a href="https://travis-ci.org/zmian/xcore"><img src="https://travis-ci.org/zmian/xcore.svg?branch=main" alt="Main Branch Build Status"></a>
  <a href="http://cocoapods.org/pods/Xcore"><img src="https://img.shields.io/cocoapods/v/Xcore.svg?style=flat" alt="CocoaPods Version Number"></a>
  <a href="http://cocoapods.org/pods/Xcore"><img src="https://img.shields.io/cocoapods/p/Xcore.svg?style=flat" alt="Supported Platform"></a>
    <a href="http://cocoapods.org/pods/Xcore"><img src="https://img.shields.io/cocoapods/l/Xcore.svg?style=flat" alt="License"></a>
</p>
<h1></h1>

Xcore is a collection of hundreds of Swift extensions and components designed to minimize boilerplate to accomplish common tasks with ease. It is a framework to efficiently build and scale apps without compromising quality, maintainability and developer productivity. Check out the included example project and [documentation](https://zmian.github.io/xcore) to see how.

## Contents
- [Requirements](#requirements)
- [Makefile](#makefile)
- [Installation](#installation)
- [Documentation](#documentation)

## Requirements
* iOS 14.0+
* Xcode 13.0+
* Swift 5.5+

**Additional Requirements**

* [Swift Package Manager](https://swift.org/package-manager/)
* [SwiftLint][swiftlint-link]
* [SwiftFormat][swiftformat-link]

## Makefile
We use make file to provide some useful shortcuts. Run any of the below commands at the project root level.

- `make test` Runs all tests
- `make lint` Runs SwiftLint
- `make format` Runs SwiftFormat

## Installation

### Swift Package Manager
Xcore is available through Swift Package Manager. To integrate it into a project, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(name: "Xcore", url: "https://github.com/zmian/xcore", .branch("main"))
    ],
    ...
)
```

### CocoaPods

Xcore is available through [CocoaPods](http://cocoapods.org). To integrate Xcore into your Xcode project using CocoaPods, simply add the following line to your `Podfile`:

```ruby
pod 'Xcore'
```

**Latest version**

```ruby
pod 'Xcore', :git => 'https://github.com/zmian/xcore'
```

### Third-Party Extensions

Xcore provides extensions for various third-party frameworks. They are behind `#if canImport`[flag](https://github.com/apple/swift-evolution/blob/master/proposals/0075-import-test.md) to avoid linking these frameworks as hard dependencies.

To enable these extension in your own project, simply add the following script in your `podfile`:

```ruby
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if target.name == "Xcore" then
                # Exposing Carthage frameworks
                #
                # Expose `Vendor` (Carthage) directory to Xcore so we can get conditional extensions.
                config.build_settings['FRAMEWORK_SEARCH_PATHS'] ||= ['$(inherited)', '${PODS_ROOT}/../Vendor']

                # Exposing CocoaPods frameworks
                #
                # Or expose `SnapKit` pod to Xcore so we can get conditional extensions.
                config.build_settings['FRAMEWORK_SEARCH_PATHS'] ||= ['$(inherited)', '${PODS_CONFIGURATION_BUILD_DIR}/SnapKit']
                # Link `SnapKit` framework to Xcore so the conditional canImport flag works.
                config.build_settings['OTHER_LDFLAGS'] ||= ['$(inherited)', '-framework "SnapKit"']
            end
        end
    end
end
```

Replace `'${PODS_ROOT}/../Vendor'` with location of your frameworks directory.

**Note:** This script can also make your Carthage dependencies visible to Xcore so you can use these conditional extensions.

## Documentation

You can find [the documentation here](https://zmian.github.io/xcore).

Documentation is generated with [jazzy](https://github.com/realm/jazzy) and hosted on [GitHub-Pages](https://pages.github.com). To regenerate documentation, run `./Scripts/build_docs.sh` from the root directory in the repo.

## Author

- [Zeeshan Mian](https://github.com/zmian) ([@zmian](https://twitter.com/zmian))

## License

Xcore is released under the MIT license. [See LICENSE](https://github.com/zmian/xcore/blob/main/LICENSE) for details.

[swiftlint-link]: https://github.com/realm/SwiftLint
[swiftformat-link]: https://github.com/nicklockwood/SwiftFormat
