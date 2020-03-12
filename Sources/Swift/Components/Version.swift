//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type that can be used to represent a version and compared using the
/// relational operators `<`, `<=`, `>=`, and `>`.
///
/// # Example Usage
///
/// ```swift
/// // Sample code to add an extension to compare operating system version
/// // using semantic versioning.
///
/// extension UIDevice {
///     /// A strongly typed current version of the operating system.
///     ///
///     /// ```swift
///     /// // Accurate version checks.
///     /// if UIDevice.current.osVersion <= "7" {
///     ///     // Less than or equal to iOS 7
///     ///     ...
///     /// }
///     ///
///     /// if UIDevice.current.osVersion > "8" {
///     ///     // Greater than iOS 8
///     ///     ...
///     /// }
///     /// ```
///     public var osVersion: Version {
///         return Version(rawValue: systemVersion)
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
