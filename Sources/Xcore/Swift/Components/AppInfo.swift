//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Namespace

/// A namespace for common utilities related to the application information.
public enum AppInfo: Sendable {}

// MARK: - isDebuggerAttached

extension AppInfo {
    /// A Boolean property indicating whether the LLDB debugger is attached to the
    /// application.
    ///
    /// - Note: LLDB is automatically attached when the app is running from Xcode.
    ///
    /// - SeeAlso: http://stackoverflow.com/a/33177600
    public static var isDebuggerAttached: Bool {
        var info = kinfo_proc()
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
}

// MARK: - Execution Target

extension AppInfo {
    /// An enumeration representing the execution target of the application.
    public enum ExecutionTarget {
        /// The application is running as a normal application (e.g., iOS app).
        case app

        /// The application is running as a ``WidgetKit`` extension.
        case widget
    }

    /// A property indicating the execution target of the binary.
    public static var target: ExecutionTarget {
        isWidgetExtension ? .widget : .app
    }

    /// A Boolean property indicating whether the execution target is a
    /// ``WidgetKit`` extension or a normal application target.
    ///
    /// - SeeAlso: https://stackoverflow.com/a/64073922
    public static var isWidgetExtension: Bool {
        guard
            let nsExtension = Bundle.main.infoDictionary?["NSExtension"] as? [String: String],
            let widget = nsExtension["NSExtensionPointIdentifier"]
        else {
            return false
        }

        return widget == "com.apple.widgetkit-extension"
    }

    /// A Boolean property indicating whether the execution target is an app
    /// extension or a normal application target.
    ///
    /// When you build an extension based on an Xcode template, you get an extension
    /// bundle that ends in `.appex`. See [Creating an App Extension].
    ///
    /// [Creating an App Extension]: https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionCreation.html
    public static var isAppExtension: Bool {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return Bundle.main.bundlePath.hasSuffix(".appex")
        #elseif os(macOS)
        return false
        #endif
    }
}

// MARK: - Distribution

extension AppInfo {
    /// An enumeration representing the application distribution channel.
    public enum Distribution {
        /// App was installed from the App Store.
        case appStore

        /// App was installed from TestFlight.
        case testFlight

        /// App was installed by some other mechanism (Ad-Hoc, Enterprise, etc.)
        case other
    }

    /// A property indicating the application distribution channel
    /// (e.g., the App Store, TestFlight or Ad-Hoc, Enterprise).
    public static var distribution: Distribution {
        #if targetEnvironment(simulator)
        return .other
        #else
        if hasEmbeddedMobileProvision {
            return .other
        } else if Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" {
            return .testFlight
        } else {
            return .appStore
        }
        #endif
    }

    /// A Boolean property indicating whether the app has embedded mobile provision
    /// file.
    private static var hasEmbeddedMobileProvision: Bool {
        Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil
    }
}

// MARK: - User Agent

extension AppInfo {
    /// Returns formatted string suitable to use as `User-Agent` header in
    /// networking requests.
    ///
    /// See the [User-Agent header documentation](https://tools.ietf.org/html/rfc7231#section-5.5.3).
    ///
    /// ```
    /// Template: "executable/appVersionNumber (appBundleId; build:appBuildNumber; deviceModel; osNameVersion) language_region"
    /// Example: App/1.0.0 (com.app.dev; build:1; iPhone14,2; iOS 15.2.0) en_US
    /// ```
    public static let userAgent: String = {
        let executable = Bundle.main.executable
        let appVersionNumber = Bundle.main.versionNumber
        let appBuildNumber = Bundle.main.buildNumber
        let appBundleId = Bundle.main.identifier
        let localeId = Locale.current.identifier
        let deviceModel = Device.current.model.identifier
        let osNameVersion = Bundle.main.osNameVersion
        return "\(executable)/\(appVersionNumber) (\(appBundleId); build:\(appBuildNumber); \(deviceModel); \(osNameVersion)) \(localeId)"
    }()
}

// MARK: - Traits

extension AppInfo {
    /// A list of application traits such as app version, device and OS version.
    public static var traits: [String: String] {
        [
            "app_version": Bundle.main.versionNumber,
            "app_build_number": Bundle.main.buildNumber,
            "app_bundle_id": Bundle.main.identifier,
            "device_name": Device.current.model.description,
            "device_model": Device.current.model.identifier,
            "device_family": Device.current.model.family,
            "os": Bundle.main.osNameVersion,
            "locale": Locale.current.identifier
        ]
    }
}
