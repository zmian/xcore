//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Bundle {
    /// Returns the `Bundle` object with which the specified class name is
    /// associated.
    ///
    /// The `Bundle` object that dynamically loaded `forClassName` (a loadable
    /// bundle), the `Bundle` object for the framework in which `forClassName` is
    /// defined, or the main bundle object if `forClassName` was not dynamically
    /// loaded or is not defined in a framework.
    ///
    /// This method creates and returns a new `Bundle` object if there is no
    /// existing bundle associated with `forClassName`; otherwise, the existing
    /// instance is returned.
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

    /// The version number of the bundle (e.g., `"1.0"`).
    public var versionNumber: String {
        info(forKey: "CFBundleShortVersionString")
    }

    /// The build number of the bundle (e.g., `"300"`).
    public var buildNumber: String {
        info(forKey: kCFBundleVersionKey)
    }

    /// The version and build number of the bundle (e.g., `"1.0 (300)"`).
    public var versionBuildNumber: String {
        "\(versionNumber) (\(buildNumber))"
    }

    /// The OS version (e.g., `"iOS 15.0.1"`).
    public var osVersion: String {
        let name = Device.current.osName
        let version = Device.current.osVersion
        return "\(name) \(version.semanticDescription)"
    }

    /// The device language.
    public var deviceLanguage: String {
        preferredLocalizations.first ?? ""
    }

    /// Returns common bundle information.
    ///
    /// **Sample output:**
    ///
    /// ```swift
    /// iOS 15.0.1        // OS Version
    /// iPhone X          // Device
    /// Version 1.0 (300) // App Version and Build number
    /// ```
    public var info: String {
        """
        \(osVersion)
        \(Device.current.model.name)
        Version \(versionBuildNumber)"
        """
    }
}

extension Bundle {
    /// Returns the first URL for the specified common directory in the user domain.
    public static func url(for directory: FileManager.SearchPathDirectory) -> URL? {
        FileManager.default.url(for: directory)
    }
}
