//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - OptionalTypeMarker

public protocol OptionalTypeMarker {
    /// A boolean value that determines whether the wrapped value is `nil`.
    var isNil: Bool { get }
}

extension Optional: OptionalTypeMarker {
    public var isNil: Bool {
        switch self {
            case .none:
                return true
            case .some:
                return false
        }
    }

    /// A boolean value that determines whether the wrapped value is not `nil`.
    ///
    /// Useful in KeyPaths to allow for negation.
    public var isNotNil: Bool {
        !isNil
    }
}

// MARK: - OptionalType

// Credit: https://stackoverflow.com/a/45462046

public protocol OptionalType {
    associatedtype Wrapped
    var wrapped: Wrapped? { get }
}

extension Optional: OptionalType {
    public var wrapped: Wrapped? {
        self
    }
}

// MARK: - isEqual

extension Optional {
    func isEqual(_ other: Self) -> Bool where Wrapped == [String: Encodable] {
        switch (self, other) {
            case (.none, .none):
                return true
            case let (.none, .some(value)):
                // nil or empty are the same
                return value.isEmpty
            case let (.some(value), .none):
                return value.isEmpty
            case let (.some(lhs), .some(rhs)):
                return lhs.isEqual(rhs)
        }
    }
}

extension Dictionary where Key == String, Value == Encodable {
    func isEqual(_ other: Self) -> Bool {
        if isEmpty, other.isEmpty {
            // Fast pass
            return true
        }

        return JSONHelpers.stringify(self).sha256() == JSONHelpers.stringify(other).sha256()
    }

    /// Returns nil if the dictionary is empty; otherwise, unmodified `self`.
    public func nilIfEmpty() -> [Key: Value]? {
        isEmpty ? nil : self
    }
}

extension Optional where Wrapped == String {
    /// Returns `true` iff `self` `nil` or contains no characters and blank spaces
    /// (e.g., \n, “ “).
    public var isNilOrBlank: Bool {
        switch self {
            case .none:
                return true
            case let .some(wrapped):
                return wrapped.isBlank
        }
    }
}
