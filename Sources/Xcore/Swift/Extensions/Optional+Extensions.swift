//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - OptionalProtocol

// Credit: https://stackoverflow.com/a/45462046

public protocol OptionalProtocol {
    associatedtype Wrapped
    var wrapped: Wrapped? { get }
}

extension Optional: OptionalProtocol {
    public var wrapped: Wrapped? {
        self
    }

    /// A Boolean property indicating whether the wrapped value is `nil`.
    public var isNil: Bool {
        self == nil
    }

    /// A Boolean property indicating whether the wrapped value is not `nil`.
    ///
    /// Useful in ``KeyPath``s to allow for negation.
    public var isNotNil: Bool {
        !isNil
    }
}

// MARK: - isEqual

extension Optional<EncodableDictionary> {
    func isEqual(_ other: Self) -> Bool {
        switch (self, other) {
            case (.none, .none):
                true
            case let (.none, .some(value)):
                // nil or empty are the same
                value.isEmpty
            case let (.some(value), .none):
                value.isEmpty
            case let (.some(lhs), .some(rhs)):
                lhs.isEqual(rhs)
        }
    }
}

extension Dictionary<String, Encodable & Sendable> {
    func isEqual(_ other: Self) -> Bool {
        if isEmpty, other.isEmpty {
            // Fast pass
            return true
        }

        return JSONHelpers.encodeToString(self).sha256() == JSONHelpers.encodeToString(other).sha256()
    }

    /// Returns nil if the dictionary is empty; otherwise, unmodified `self`.
    public func nilIfEmpty() -> [Key: Value]? {
        isEmpty ? nil : self
    }
}

extension String? {
    /// Returns `true` iff `self` `nil` or contains no characters and blank spaces
    /// (e.g., \n, “ “).
    public var isNilOrBlank: Bool {
        switch self {
            case .none: true
            case let .some(wrapped): wrapped.isBlank
        }
    }
}

extension Optional {
    /// Converts `self` to a boolean.
    ///
    /// Useful when converting `Binding<Item?>` into `Binding<Bool>` to pass to
    /// `SwiftUI` modifier that requires Boolean binding.
    ///
    /// Instead of manually converting to Boolean binding:
    ///
    /// ```swift
    /// .popup(
    ///     isPresented: .init {
    ///         item.wrappedValue != nil
    ///     } set: { isPresented in
    ///         if !isPresented {
    ///             item.wrappedValue = nil
    ///         }
    ///     }) {
    ///     if let item = item.wrappedValue {
    ///         content(item)
    ///     }
    /// }
    /// ```
    ///
    /// You can use the simple boolean property:
    ///
    /// ```swift
    /// .popup(isPresented: item.isPresented) {
    ///     item.wrappedValue.map(content)
    /// }
    /// ```
    var isPresented: Bool {
        get { self != nil }
        set { if !newValue { self = nil } }
    }
}
