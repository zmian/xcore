//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Bundle Initialization

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
    ///
    /// - Parameter className: The name of the class whose bundle is requested.
    public convenience init?(forClassName className: String) {
        guard let aClass = NSClassFromString(className) else {
            return nil
        }

        self.init(for: aClass)
    }
}

// MARK: - Bundle Info Retrieval

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

    /// The human-readable name of the bundle.
    ///
    /// This key is often found in the `InfoPlist.strings` since it is usually
    /// localized.
    public var name: String {
        info(forKey: kCFBundleNameKey)
    }

    /// The version number of the bundle (e.g., `"1.0"`).
    public var versionNumber: String {
        info(forKey: "CFBundleShortVersionString")
    }

    /// The build number of the bundle (e.g., `"300"`).
    public var buildNumber: String {
        info(forKey: kCFBundleVersionKey)
    }

    /// The combined version and build number of the bundle (e.g., `"1.0 (300)"`).
    public var versionBuildNumber: String {
        "\(versionNumber) (\(buildNumber))"
    }

    /// The OS version (e.g., `"iOS 16.2.0"`).
    public var osNameVersion: String {
        let name = Device.current.osName
        let version = Device.current.osVersion
        return "\(name) \(version.semanticDescription)"
    }

    /// The primary language of the device.
    public var deviceLanguage: String {
        preferredLocalizations.first ?? ""
    }

    /// Returns a summary of common bundle information.
    ///
    /// **Sample output:**
    ///
    /// ```swift
    /// iOS 16.2.0        // OS Version
    /// Z's iPhone        // Device name
    /// Version 1.0 (300) // App Version and Build number
    /// ```
    public var info: String {
        """
        \(osNameVersion)
        \(Device.current.model.name)
        Version \(versionBuildNumber)
        """
    }
}

// MARK: - URL

extension Bundle {
    /// Returns the first URL for the specified common directory in the user domain.
    ///
    /// - Parameter directory: The directory type (e.g., `.documentDirectory`).
    /// - Returns: A URL representing the specified directory, or `nil` if unavailable.
    public static func url(for directory: FileManager.SearchPathDirectory) -> URL? {
        FileManager.default.url(for: directory)
    }

    /// Returns the file URL for the resource identified by the specified file
    /// name and extension.
    ///
    /// - Parameter filename: The file name including its extension
    ///   (e.g., `"colors.json"`).
    /// - Returns: A file URL for the resource, or `nil` if not found.
    public func url(filename: String) -> URL? {
        url(
            forResource: filename.lastPathComponent.deletingPathExtension,
            withExtension: filename.pathExtension
        )
    }

    /// Returns the full pathname for the resource identified by the specified file
    /// name and extension.
    ///
    /// - Parameter filename: The file name including its extension
    ///   (e.g., `"colors.json"`).
    /// - Returns: The full pathname for the resource, or `nil` if not found.
    public func path(filename: String) -> String? {
        path(
            forResource: filename.lastPathComponent.deletingPathExtension,
            ofType: filename.pathExtension
        )
    }
}

// MARK: - App Bundle

extension Bundle {
    /// Returns the app's main bundle.
    ///
    /// If the execution target is an app extension, this property attempts to
    /// retrieve the host app's bundle instead of the extension's bundle.
    public static var app: Bundle {
        guard AppInfo.executionTarget == .appExtension else {
            return .main
        }

        return .init(
            url: Bundle.main.bundleURL
                .deletingLastPathComponent()
                .deletingLastPathComponent()
        ) ?? .main
    }
}
