//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A representation of a key path using a raw string value and a separator.
///
/// This structure provides a flexible way to handle key paths as strings,
/// supporting customization of the separator for dynamic use cases.
///
/// **Usage**
///
/// ```swift
/// let keyPath = KeyPathRepresentation("user.profile.name")
/// print(keyPath) // Prints "user.profile.name"
/// print(keyPath.components) // Prints ["user", "profile", "name"]
/// ```
public struct KeyPathRepresentation: Sendable, Hashable {
    public let rawValue: String
    public let separator: String

    /// Initializes a new key path representation.
    ///
    /// - Parameters:
    ///   - rawValue: The raw string representation of the key path.
    ///   - separator: The character used to separate key path components.
    ///     Defaults to `"."`.
    public init(_ rawValue: String, separator: String = ".") {
        self.rawValue = rawValue
        self.separator = separator
    }

    /// Returns the components of the key path as an array of strings.
    public var components: [String] {
        rawValue.split(separator: separator).map(String.init)
    }

    /// Appends a new segment to the key path.
    ///
    /// - Parameter segment: The segment to append.
    /// - Returns: A new `KeyPathRepresentation` with the appended segment.
    public func appending(_ segment: String) -> KeyPathRepresentation {
        let newPath = rawValue.isEmpty ? segment : "\(rawValue)\(separator)\(segment)"
        return KeyPathRepresentation(newPath, separator: separator)
    }

    /// Checks if the key path contains a specific segment.
    ///
    /// - Parameter segment: The segment to check for.
    /// - Returns: `true` if the key path contains the segment; otherwise, `false`.
    public func contains(segment: String) -> Bool {
        components.contains(segment)
    }
}

// MARK: - String Literal Conformance

extension KeyPathRepresentation: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

// MARK: - CustomStringConvertible

extension KeyPathRepresentation: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

// MARK: - CustomPlaygroundDisplayConvertible

extension KeyPathRepresentation: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        rawValue
    }
}
