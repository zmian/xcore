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
    /// An enumeration representing the execution environment of the application.
    ///
    /// Identify whether the app is running as a standalone application, an app
    /// extension (such as a Share or Siri extension), or a WidgetKit extension.
    ///
    /// **Use Cases:**
    /// - Modify behavior based on execution context.
    /// - Prevent restricted operations in extensions.
    /// - Apply different UI configurations for widgets.
    ///
    /// **Execution Targets:**
    ///
    /// | Environment          | Output          |
    /// |----------------------|-----------------|
    /// | iOS/macOS App        | `.app`          |
    /// | Share/Siri Extension | `.appExtension` |
    /// | Widget Extension     | `.widget`       |
    public enum ExecutionTarget: Sendable, Hashable {
        /// The application is running as a **standard iOS/macOS app**.
        case app

        /// The application is running as an **App Extension**.
        ///
        /// - **Examples**: Share Extensions, Siri Extensions, Today Extensions.
        case appExtension

        /// The application is running as a **WidgetKit extension**.
        ///
        /// - **Example**: A home-screen widget built using `WidgetKit`.
        case widget
    }

    /// A property indicating the **current execution target** of the binary.
    ///
    /// Identify whether the app is running as a standalone application, an app
    /// extension (such as a Share or Siri extension), or a WidgetKit extension.
    ///
    /// **Use Cases:**
    /// - Modify behavior based on execution context.
    /// - Prevent restricted operations in extensions.
    /// - Apply different UI configurations for widgets.
    ///
    /// **Execution Targets:**
    ///
    /// | Environment          | Output          |
    /// |----------------------|-----------------|
    /// | iOS/macOS App        | `.app`          |
    /// | Share/Siri Extension | `.appExtension` |
    /// | Widget Extension     | `.widget`       |
    ///
    /// **Usage**
    ///
    /// ```swift
    /// switch AppInfo.executionTarget {
    ///     case .app:
    ///         print("Running as a full application.")
    ///     case .appExtension:
    ///         print("Running as an app extension.")
    ///     case .widget:
    ///         print("Running as a WidgetKit extension.")
    /// }
    /// ```
    ///
    /// - Returns: The current execution target of the binary.
    public static var executionTarget: ExecutionTarget {
        if isWidgetExtension {
            return .widget
        }

        if isAppExtension {
            return .appExtension
        }

        return .app
    }

    /// A Boolean property indicating whether the execution target is a
    /// ``WidgetKit`` extension or a normal application target.
    ///
    /// - SeeAlso: https://stackoverflow.com/a/64073922
    private static var isWidgetExtension: Bool {
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
    private static var isAppExtension: Bool {
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
    public enum Distribution: Sendable {
        /// The app was installed from the **App Store**.
        case appStore

        /// The app was installed from **TestFlight**.
        case testFlight

        /// The app was installed by some other mechanism (e.g., Ad-Hoc, Enterprise, or
        /// local development).
        case other
    }

    /// A property indicating the application distribution channel.
    ///
    /// Determines whether the app is running as a **production App Store release**,
    /// a **TestFlight beta version**, or via another installation method such as
    /// **Enterprise or Ad-Hoc deployment**.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// switch AppInfo.distribution {
    ///     case .appStore:
    ///         print("Running as an official App Store release.")
    ///     case .testFlight:
    ///         print("Running as a TestFlight beta version.")
    ///     case .other:
    ///         print("Running via an alternative distribution method.")
    /// }
    /// ```
    ///
    /// - Returns: The current application distribution channel.
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
    ///
    /// - Returns: `true` if the app was distributed via **Ad-Hoc, Enterprise, or
    ///   local build**.
    private static var hasEmbeddedMobileProvision: Bool {
        Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil
    }
}

// MARK: - Bundle ID

extension AppInfo {
    /// The app's bundle identifier.
    ///
    /// The bundle identifier is defined by the `CFBundleIdentifier` key in the
    /// app's bundle property list (e.g., `com.example.ios`).
    ///
    /// For more information, see ``CFBundleIdentifier``.
    static var bundleId: String {
        (Bundle.app.bundleIdentifier ?? "").replacing(".intents", with: "")
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
    /// Example: App/1.0.0 (com.app.dev; build:1; iPhone14,2; iOS 16.2.0) en_US
    /// ```
    @MainActor
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
    @MainActor
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
