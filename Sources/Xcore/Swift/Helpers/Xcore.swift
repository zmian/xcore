//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
@_exported import AnyCodable
@_exported import KeychainAccess
@_exported import Dependencies

// MARK: - Bundle

extension Bundle {
    private class XcoreMarker {}
    public static var xcore: Bundle {
        #if SWIFT_PACKAGE
        return .myModule
        #else
        return .init(for: XcoreMarker.self)
        #endif
    }
}

extension AnyCodable {
    public static func from(_ value: Any) -> Self {
        self.init(value)
    }
}

#if SWIFT_PACKAGE
// Fix for package depending on other packages fix
// =============================================================================
#warning("TODO: TODO: Check previews under Xcode 14 to see if this is fixed?")
private let moduleName = "Xcore"

private class CurrentBundleFinder {}

// Unable to find Bundle in package target tests or SwiftUI Previews when
// package depends on another package containing resources accessed via
// Bundle.module.
//
// - SeeAlso: https://forums.swift.org/t/unable-to-find-bundle-in-package-target-tests-when-package-depends-on-another-package-containing-resources-accessed-via-bundle-module/43974/2
extension Foundation.Bundle {
    /// Returns the resource bundle associated with the current Swift module.
    fileprivate static var myModule: Bundle = {
        let bundleName = "Xcore_\(moduleName)"
        let localBundleName = "LocalPackages_\(moduleName)"

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: CurrentBundleFinder.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,

            // Bundle should be present here when running previews from a different package (this is the path to "…/Debug-iphonesimulator/").
            Bundle(for: CurrentBundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent(),
            Bundle(for: CurrentBundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent()
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }

            let localBundlePath = candidate?.appendingPathComponent(localBundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }

        fatalError("Unable to find bundle named \(moduleName).")
    }()
}
// =============================================================================
#endif
