//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type that converts between values and their textual representations.
public protocol TextFieldFormatter {
    associatedtype Value: Hashable

    /// Returns a string containing the formatted value of the given value.
    ///
    /// - Parameter value: A value that is parsed to create the returned string.
   func string(from value: Value) -> String

    /// Returns a value created by parsing the given string.
    ///
    /// - Parameter string: A string that is parsed to generate the returned value.
    func value(from string: String) -> Value

    /// Specify whether the input can be changed to the given string.
    ///
    /// - Parameter string: A changed string that will be applied.
    /// - Returns: `true` if the given string should be changed; otherwise, `false`
    ///   to keep the old string.
    func shouldChange(to string: String) -> Bool
}

// MARK: - Type Erasure

public struct AnyTextFieldFormatter: TextFieldFormatter {
    private let _string: (AnyHashable) -> String
    private let _value: (String) -> AnyHashable
    private let _shouldChange: (String) -> Bool

    init<F: TextFieldFormatter>(_ formatter: F) {
        _string = {
            formatter.string(from: $0.base as! F.Value)
        }

        _value = {
            AnyHashable(formatter.value(from: $0))
        }

        _shouldChange = {
            formatter.shouldChange(to: $0)
        }
    }

    public func string(from value: AnyHashable) -> String {
        _string(value)
    }

    public func value(from string: String) -> AnyHashable {
        _value(string)
    }

    public func shouldChange(to string: String) -> Bool {
        _shouldChange(string)
    }
}
