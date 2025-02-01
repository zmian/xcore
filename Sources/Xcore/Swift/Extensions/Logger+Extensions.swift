//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import OSLog

extension Logger {
    /// The string that identifies the subsystem that emits signposts.
    ///
    /// It's the same value as your app’s bundle identifier to ensure a unique
    /// identifier.
    ///
    /// The bundle identifier is retrieved from the `CFBundleIdentifier` key in the
    /// app's bundle property list (e.g., `com.example.ios`).
    ///
    /// For more information, see ``CFBundleIdentifier``.
    public static let subsystem = AppInfo.bundleId

    /// A general-purpose logger for application-wide logging.
    ///
    /// **Category:** `"main"`
    public static let main = Logger(subsystem: subsystem, category: "main")

    /// A logger dedicated to Xcore framework-related logs.
    ///
    /// **Category:** `"xcore"`
    static let xc = Logger(subsystem: subsystem, category: "xcore")

    /// A logger for tracking analytics-related events.
    ///
    /// **Category:** `"analytics"`
    static let analytics = Logger(subsystem: subsystem, category: "analytics")
}

/// An enumeration representing logging levels ordered by severity.
///
/// The least severe level is `.debug`, while the most severe is `.critical`.
public enum LogLevel: String, Hashable, Codable, Sendable {
    case debug
    case info
    case notice
    case warn
    case error
    case critical
}
