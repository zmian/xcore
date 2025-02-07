//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A generic identifier that wraps a string value for type-safe identification.
///
/// `Identifier<Type>` provides a lightweight wrapper around a `String` that
/// associates an identifier with a specific type. This ensures that identifiers
/// for different types (e.g., User, Post) are not accidentally interchanged.
///
/// **Usage**
///
/// ```swift
/// let userId: Identifier<User> = "user-12345"
/// print(userId.rawValue) // "user-12345"
/// ```
public struct Identifier<Type>: RawRepresentable {
    /// The underlying string value of the identifier.
    public let rawValue: String

    /// Creates a new identifier with the given raw string value.
    ///
    /// - Parameter rawValue: The string value to be used as the identifier.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Identifier: ExpressibleByStringLiteral {
    /// Creates a new identifier from a string literal.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let identifier: Identifier<Int> = "unique-id"
    /// ```
    ///
    /// - Parameter value: The string literal to use as the identifier.
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}

extension Identifier: CustomStringConvertible {
    /// A Boolean property indicating whether the identifier is expressed as a
    /// textual value.
    public var description: String {
        rawValue
    }
}

extension Identifier: CustomPlaygroundDisplayConvertible {
    /// A textual representation of the identifier for Swift Playgrounds.
    public var playgroundDescription: Any {
        rawValue
    }
}

extension Identifier: Sendable {}
extension Identifier: Hashable {}
extension Identifier: Codable {}
