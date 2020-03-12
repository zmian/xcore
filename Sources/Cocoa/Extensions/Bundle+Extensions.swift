//
// Bundle+Extensions.swift
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Bundle {
    /// Returns the `Bundle` object with which the specified class name is associated.
    ///
    /// The `Bundle` object that dynamically loaded `forClassName` (a loadable bundle),
    /// the `Bundle` object for the framework in which `forClassName` is defined, or the
    /// main bundle object if `forClassName` was not dynamically loaded or is not defined
    /// in a framework.
    ///
    /// This method creates and returns a new `Bundle` object if there is no existing
    /// bundle associated with `forClassName`. Otherwise, the existing instance is returned.
    public convenience init?(forClassName className: String) {
        guard let aClass = NSClassFromString(className) else {
            return nil
        }

        self.init(for: aClass)
    }
}

extension Bundle {
    private func info(forKey key: String) -> String {
        infoDictionary?[key] as? String ?? ""
    }

    private func info(forKey key: CFString) -> String {
        info(forKey: key as String)
    }

    /// The name of the executable in this bundle (if any).
    public var executable: String {
        info(forKey: kCFBundleExecutableKey)
    }

    /// The bundle identifier.
    public var identifier: String {
        info(forKey: kCFBundleIdentifierKey)
    }

    /// The version number of the bundle.
    public var versionNumber: String {
        info(forKey: "CFBundleShortVersionString")
    }

    /// The build number of the bundle.
    public var buildNumber: String {
        info(forKey: kCFBundleVersionKey)
    }

    /// Returns common bundle information.
    ///
    /// **Sample output:**
    ///
    /// ```swift
    /// iOS 12.1.0        // OS Version
    /// iPhone X          // Device
    /// Version 1.0 (300) // App Version and Build number
    /// ```
    public var info: String {
        var systemName = UIDevice.current.systemName

        if systemName == "iPhone OS" {
            systemName = "iOS"
        }

        return """
        \(systemName) \(UIDevice.current.systemVersion)
        \(UIDevice.current.modelType)
        Version \(versionNumber) (\(buildNumber))"
        """
    }
}

extension Bundle {
    /// Returns the first URL for the specified common directory in the user domain.
    public static func url(for directory: FileManager.SearchPathDirectory) -> URL? {
        FileManager.default.url(for: directory)
    }
}
