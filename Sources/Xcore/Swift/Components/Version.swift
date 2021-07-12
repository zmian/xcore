//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type that can be used to represent a version and compared using the
/// relational operators `<`, `<=`, `>=`, and `>`.
///
/// **Usage**
///
/// ```swift
/// // Sample code to add an extension to compare operating system version
/// // using semantic versioning.
///
/// extension Device {
///     /// A strongly typed current version of the operating system.
///     ///
///     /// ```swift
///     /// // Accurate version checks.
///     /// if Device.current.osVersion <= "7" {
///     ///     // Less than or equal to iOS 7
///     ///     ...
///     /// }
///     ///
///     /// if Device.current.osVersion > "8" {
///     ///     // Greater than iOS 8
///     ///     ...
///     /// }
///     /// ```
///     public var osVersion: Version {
///         Version(rawValue: systemVersion)
///     }
/// }
/// ```
public struct Version: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Version: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
}

extension Version: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension Version: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        rawValue
    }
}

extension Version: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension Version: Comparable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue.compare(rhs.rawValue, options: .numeric) == .orderedSame
    }

    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue.compare(rhs.rawValue, options: .numeric) == .orderedAscending
    }
}

// MARK: - OperatingSystemVersion

extension OperatingSystemVersion: CustomStringConvertible {
    /// Returns system version formatted in accordance with Semantic Versioning.
    ///
    /// `<major>.<minor>.<patch>`
    ///
    /// ```
    /// 1     -> 1.0.0
    /// 1.0   -> 1.0.0
    /// 1.1   -> 1.1.0
    /// 1.0.2 -> 1.0.2
    /// ```
    public var semanticDescription: String {
        "\(majorVersion).\(minorVersion).\(patchVersion)"
    }

    public var description: String {
        semanticDescription
    }
}
