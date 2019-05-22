<p align="center">
<img src="Resources/xcoreLogo.svg" alt="Xcore logo" height=100>
</p>
<p align="center">
    <a href="https://travis-ci.org/zmian/xcore.swift"><img src="https://travis-ci.org/zmian/xcore.swift.svg?branch=master" alt="Master Branch Build Status"></a>
  <a href="http://cocoapods.org/pods/Xcore"><img src="https://img.shields.io/cocoapods/v/Xcore.svg?style=flat" alt="CocoaPods Version Number"></a>
  <a href="http://cocoapods.org/pods/Xcore"><img src="https://img.shields.io/cocoapods/p/Xcore.svg?style=flat" alt="Supported Platform"></a>
    <a href="http://cocoapods.org/pods/Xcore"><img src="https://img.shields.io/cocoapods/l/Xcore.svg?style=flat" alt="License"></a>
</p>
<h1></h1>

Xcore is a collection of pure Swift and Cocoa Touch classes, extensions and components for rapid and safe iOS development. It provides a vast library of customizations and extensions to get tasks done with ease and bugs free. Check out the included example project and [documentation](https://zmian.github.io/xcore.swift) to see how.

## Requirements
* iOS 11.0+
* Xcode 10.2+
* Swift 5.0+

## Installation

### CocoaPods

Xcore is available through [CocoaPods](http://cocoapods.org). To integrate Xcore into your Xcode project using CocoaPods, simply add the following line to your `Podfile`:

```ruby
pod 'Xcore'
```

**Latest version**

```ruby
pod 'Xcore', :git => 'https://github.com/zmian/xcore.swift'
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

You can find [the documentation here](https://zmian.github.io/xcore.swift). 

Documentation is generated with [jazzy](https://github.com/realm/jazzy) and hosted on [GitHub-Pages](https://pages.github.com). To regenerate documentation, run `./scripts/build_docs.sh` from the root directory in the repo.

## Author

- [Zeeshan Mian](https://github.com/zmian) ([@zmian](https://twitter.com/zmian))

## License

Xcore is released under the MIT license. [See LICENSE](https://github.com/zmian/xcore.swift/blob/master/LICENSE) for details.
