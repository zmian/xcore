//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Namespace

public enum AppInfo {}

// MARK: - isDebuggerAttached

extension AppInfo {
    /// A boolean value to determine whether the LLDB debugger is attached to the
    /// app.
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

// MARK: - isAppExtension

extension AppInfo {
    /// A boolean value to determine whether it is running inside an extension or an
    /// app.
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
    public enum Distribution {
        /// App has been installed from the App Store.
        case appStore

        /// App has been installed from TestFlight.
        case testFlight

        /// App has been installed by some other mechanism (Ad-Hoc, Enterprise, etc.)
        case other
    }

    /// A property to determine the app distribution channel.
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

    /// A boolean value to determine whether the app has embedded mobile provision
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
    /// ```
    /// Format:  "executable/appVersionNumber (appBundleId; build:appBuildNumber; deviceModel; osNameVersion) language_region"
    /// Example: App/1.0.0 (com.app.dev; build:1; iPhone13,3; iOS 15.1.0) en_US
    /// ```
    public static let userAgent: String = {
        let executable = Bundle.main.executable
        let appVersionNumber = Bundle.main.versionNumber
        let appBuildNumber = Bundle.main.buildNumber
        let appBundleId = Bundle.main.identifier
        let localeId = Locale.current.identifier
        let deviceModel = Device.current.model.identifier
        let osNameVersion = Bundle.main.osVersion
        return "\(executable)/\(appVersionNumber) (\(appBundleId); build:\(appBuildNumber); \(deviceModel); \(osNameVersion)) \(localeId)"
    }()
}

// MARK: - Traits

extension AppInfo {
    /// A list of app traits such as app version, device and OS.
    public static var traits: [String: String] {
        [
            "app_version": Bundle.main.versionNumber,
            "app_build_number": Bundle.main.buildNumber,
            "app_bundle_id": Bundle.main.identifier,
            "device_name": Device.current.model.description,
            "device_model": Device.current.model.identifier,
            "device_family": Device.current.model.family,
            "os": Bundle.main.osVersion,
            "locale": Locale.current.identifier
        ]
    }
}
