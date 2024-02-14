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
    /// The bundle identifier is defined by the `CFBundleIdentifier` key in the
    /// app's bundle information property list (e.g., `com.example.ios`).
    ///
    /// For more information, see ``CFBundleIdentifier``.
    public static let subsystem = AppInfo.bundleId

    /// All logs related to the app.
    public static let main = Logger(subsystem: subsystem, category: "main")

    /// All logs related to Xcore.
    static let xc = Logger(subsystem: subsystem, category: "xcore")

    /// All logs related to analytics.
    static let analytics = Logger(subsystem: subsystem, category: "analytics")
}

/// Log levels ordered by their severity, with `.debug` being the least severe
/// and `.critical` being the most severe.
public enum LogLevel: String, Hashable, Codable, Sendable {
    case debug
    case info
    case notice
    case warn
    case error
    case critical
}
