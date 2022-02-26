//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type that converts between values and their textual representations.
public protocol TextFieldFormatter {
    associatedtype Value: Hashable

    /// Transform the value to a string.
    ///
    /// **Sample Outout**
    ///
    /// ```swift
    /// // String
    /// "hello" → "hello"
    ///
    /// // Number
    /// "0"      → String("0")
    /// "55"     → String("55")
    /// "552333" → String("552333")
    ///
    /// // Phone Number
    /// "8006927753" → String("8006927753")
    /// ```
    ///
    /// - Parameter value: A value that is parsed to create the returned string.
    func transformToString(_ value: Value) -> String

    /// Transform the string to the value.
    ///
    /// **Sample Outout**
    ///
    /// ```swift
    /// // String
    /// "hello" → "hello"
    ///
    /// // Number
    /// String("0") → Int("0")
    /// String("55") → Double("55")
    /// String("552333") → Double("552333")
    ///
    /// // Phone Number
    /// String("8006927753") → Int("8006927753")
    /// ```
    ///
    /// - Parameter string: A string that is parsed to generate the returned value.
    func transformToValue(_ string: String) -> Value

    /// Returns a formatted string that is suitable to display to the user.
    ///
    /// **Sample Outout**
    ///
    /// ```swift
    /// // Number
    /// "0"      → "$0.00"
    /// "55"     → "$55"
    /// "552333" → "$5,523.33"
    ///
    /// // Phone Number
    /// "8006927753" → "(800) 692-7753"
    /// ```
    ///
    /// - Parameter string: An input that should be formatted in a way that is
    ///   suitable to display to the user.
    func displayValue(from string: String) -> String?

    /// Returns an unformatted string removing any display only formatting that
    /// maybe have been applied in the `displayValue(from:)` method.
    ///
    /// **Sample Outout**
    ///
    /// ```swift
    /// // Number
    /// "$0.00"     → "0"
    /// "$55"       → "55"
    /// "$5,523.33" → "552333"
    ///
    /// // Phone Number
    /// "(800) 692-7753" → "8006927753"
    /// ```
    ///
    /// - Parameter string: An input that should be undo any of the formatting that
    ///   is applied in the `displayValue(from:)` method.
    func sanitizeDisplayValue(from string: String) -> String
}

// MARK: - Type Erasure

public struct AnyTextFieldFormatter: TextFieldFormatter {
    private let _transformToString: (AnyHashable) -> String
    private let _transformToValue: (String) -> AnyHashable
    private let _displayValue: (String) -> String?
    private let _sanitizeDisplayValue: (String) -> String

    init<F: TextFieldFormatter>(_ formatter: F) {
        _transformToString = {
            formatter.transformToString($0.base as! F.Value)
        }

        _transformToValue = {
            AnyHashable(formatter.transformToValue($0))
        }

        _displayValue = {
            formatter.displayValue(from: $0)
        }

        _sanitizeDisplayValue = {
            formatter.sanitizeDisplayValue(from: $0)
        }
    }

    public func transformToString(_ value: AnyHashable) -> String {
        _transformToString(value)
    }

    public func transformToValue(_ string: String) -> AnyHashable {
        _transformToValue(string)
    }

    public func displayValue(from string: String) -> String? {
        _displayValue(string)
    }

    public func sanitizeDisplayValue(from string: String) -> String {
        _sanitizeDisplayValue(string)
    }
}
