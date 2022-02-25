//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension NumberFormatter {
    /// Returns a string containing the formatted value of the provided integer.
    ///
    /// - Parameter number: An integer that is parsed to create the returned string.
    /// - Returns: A string containing the formatted value of integer using the
    ///   receiver’s current settings.
    public func string(from number: Int) -> String? {
        string(from: NSNumber(value: number))
    }

    /// Returns a string containing the formatted value of the provided
    /// single-precision, floating-point value.
    ///
    /// - Parameter number: An floating-point value that is parsed to create the
    ///   returned string.
    /// - Returns: A string containing the formatted value of floating-point value
    ///   using the receiver’s current settings.
    public func string(from number: Float) -> String? {
        string(from: NSNumber(value: number))
    }

    /// Returns a string containing the formatted value of the provided
    /// double-precision, floating-point value.
    ///
    /// - Parameter number: An floating-point value that is parsed to create the
    ///   returned string.
    /// - Returns: A string containing the formatted value of floating-point value
    ///   using the receiver’s current settings.
    public func string(from number: Double) -> String? {
        string(from: NSNumber(value: number))
    }

    /// Returns a string containing the formatted value of the provided decimal
    /// number.
    ///
    /// - Parameter number: A decimal number that is parsed to create the returned
    ///   string.
    /// - Returns: A string containing the formatted value of decimal number using
    ///   the receiver’s current settings.
    public func string(from number: Decimal) -> String? {
        string(from: NSDecimalNumber(decimal: number))
    }
}
