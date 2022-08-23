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
    public func string(from number: Int?) -> String? {
        guard let number else {
            return nil
        }

        return string(from: NSNumber(value: number))
    }

    /// Returns a string containing the formatted value of the provided
    /// single-precision, floating-point value.
    ///
    /// - Parameter number: An floating-point value that is parsed to create the
    ///   returned string.
    /// - Returns: A string containing the formatted value of floating-point value
    ///   using the receiver’s current settings.
    public func string(from number: Float?) -> String? {
        guard let number else {
            return nil
        }

        return string(from: NSNumber(value: number))
    }

    /// Returns a string containing the formatted value of the provided double or
    /// decimal
    /// number.
    ///
    /// - Parameter number: A decimal number that is parsed to create the returned
    ///   string.
    /// - Returns: A string containing the formatted value of decimal number using
    ///   the receiver’s current settings.
    public func string<Number: DoubleOrDecimalProtocol>(from number: Number?) -> String? {
        guard let number else {
            return nil
        }

        return string(from: number.nsNumber)
    }
}

// MARK: - Fraction Length

extension NumberFormatter {
    /// The minimum and maximum number of digits after the decimal separator.
    public var fractionLength: ClosedRange<Int> {
        get { minimumFractionDigits...maximumFractionDigits }
        set {
            minimumFractionDigits = newValue.lowerBound
            maximumFractionDigits = newValue.upperBound
        }
    }
}

@available(iOS 15.0, *)
extension NumberFormatStyleConfiguration.SignDisplayStrategy {
    /// Displays plus sign (`"+"`) for the positive values, minus sign (`"−"`) for
    /// the negative values and empty string (`""`) for zero values.
    ///
    /// - SeeAlso: `always(includingZero: false)`
    public static var both: Self {
        always(includingZero: false)
    }
}
