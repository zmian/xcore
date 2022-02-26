//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type that converts between values and their textual representations.
public protocol TextFieldFormatter {
    associatedtype Value: Hashable

    /// Returns the string representation of the value.
    ///
    /// **Sample Outout**
    ///
    /// ```swift
    /// // String
    /// "hello" → "hello"
    ///
    /// // Number
    /// "0"       → String("0")
    /// "55"      → String("55")
    /// "5523.33" → String("5523.33")
    ///
    /// // Phone Number
    /// "8006927753" → String("8006927753")
    /// ```
    ///
    /// - Parameter value: A value that is parsed to create the returned string.
    func string(from value: Value) -> String

    /// Returns the value representation of the string.
    ///
    /// **Sample Outout**
    ///
    /// ```swift
    /// // String
    /// "hello" → "hello"
    ///
    /// // Number
    /// String("0")       → Int("0")
    /// String("55")      → Double("55")
    /// String("5523.33") → Double("5523.33")
    ///
    /// // Phone Number
    /// String("8006927753") → Int("8006927753")
    /// ```
    ///
    /// - Parameter string: A string that is parsed to generate the returned value.
    func value(from string: String) -> Value

    /// Returns a formatted string that is suitable to display to the user.
    ///
    /// **Sample Outout**
    ///
    /// ```swift
    /// // String
    /// "hello" → "hello"
    ///
    /// // Currency
    /// "0"       → "$0.00"
    /// "55"      → "$55"
    /// "5523.33" → "$5,523.33"
    ///
    /// // Phone Number
    /// "8006927753" → "🇺🇸 +1 (800) 692-7753"
    /// ```
    ///
    /// - Parameter string: An input that should be formatted in a way that is
    ///   suitable to display to the user.
    func format(_ string: String) -> String?

    /// Returns an unformatted string removing any display only formatting that
    /// maybe have been applied in the `format(_:)` method.
    ///
    /// **Sample Outout**
    ///
    /// ```swift
    /// // String
    /// "hello" → "hello"
    ///
    /// // Currency
    /// "$0.00"     → "0"
    /// "$55"       → "55"
    /// "$5,523.33" → "5523.33"
    ///
    /// // Phone Number
    /// "🇺🇸 +1 (800) 692-7753" → "18006927753"
    /// ```
    ///
    /// - Parameter string: An input that should be undo any of the formatting that
    ///   is applied in the `format(_:)` method.
    func unformat(_ string: String) -> String
}

// MARK: - Type Erasure

public struct AnyTextFieldFormatter: TextFieldFormatter {
    private let _string: (AnyHashable) -> String
    private let _value: (String) -> AnyHashable
    private let _format: (String) -> String?
    private let _unformat: (String) -> String

    init<F: TextFieldFormatter>(_ formatter: F) {
        _string = {
            formatter.string(from: $0.base as! F.Value)
        }

        _value = {
            AnyHashable(formatter.value(from: $0))
        }

        _format = {
            formatter.format($0)
        }

        _unformat = {
            formatter.unformat($0)
        }
    }

    public func string(from value: AnyHashable) -> String {
        _string(value)
    }

    public func value(from string: String) -> AnyHashable {
        _value(string)
    }

    public func format(_ string: String) -> String? {
        _format(string)
    }

    public func unformat(_ string: String) -> String {
        _unformat(string)
    }
}
