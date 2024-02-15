//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A structure representing signs (+/−) used to format signed numeric types.
public struct SignedNumericSign: Sendable, Hashable, Codable {
    /// The string used to represent sign for positive values.
    public let positive: String

    /// The string used to represent sign for negative values.
    public let negative: String

    /// The string used to represent sign for zero values.
    public let zero: String

    /// Creates an instance of sign.
    ///
    /// - Parameters:
    ///   - positive: The string used to represent sign for positive values.
    ///   - negative: The string used to represent sign for negative values.
    ///   - zero: The string used to represent sign for zero values.
    public init(positive: String, negative: String, zero: String) {
        self.positive = positive
        self.negative = negative
        self.zero = zero
    }
}

// MARK: - Built-in

extension SignedNumericSign {
    /// Displays minus sign (`"−"`) for the negative values and empty string (`""`)
    /// for positive and zero values.
    ///
    /// ```swift
    /// // When the amount is positive then the sign is empty string ("").
    /// let amount = Money(120.30)
    ///     .sign(.default) // ← Specifying the sign
    ///
    /// print(amount) // "$120.30"
    ///
    /// // When the amount is negative then the sign is "−".
    /// let amount = Money(-120.30)
    ///     .sign(.default) // ← Specifying the sign
    ///
    /// print(amount) // "−$120.30"
    /// ```
    public static var `default`: Self {
        .init(positive: "", negative: .minusSign, zero: "")
    }

    /// Displays plus sign (`"+"`) for the positive values and empty string (`""`)
    /// for negative and zero values.
    ///
    /// ```swift
    /// // When the amount is positive then the sign is "+".
    /// let amount = Money(120.30)
    ///     .sign(.whenPositive) // ← Specifying the sign
    ///
    /// print(amount) // "+$120.30"
    ///
    /// // When the amount is negative then the sign is empty string ("").
    /// let amount = Money(-120.30)
    ///     .sign(.whenPositive) // ← Specifying the sign
    ///
    /// print(amount) // "$120.30"
    /// ```
    public static var whenPositive: Self {
        .init(positive: "+", negative: "", zero: "")
    }

    /// Displays plus sign (`"+"`) for the positive values, minus sign (`"−"`) for
    /// the negative values and empty string (`""`) for zero values.
    ///
    /// ```swift
    /// // When the amount is positive then the sign is "+".
    /// let amount = Money(120.30)
    ///     .sign(.both) // ← Specifying the sign
    ///
    /// print(amount) // "+$120.30"
    ///
    /// // When the amount is negative then the sign is "−".
    /// let amount = Money(-120.30)
    ///     .sign(.both) // ← Specifying the sign
    ///
    /// print(amount) // "-$120.30"
    /// ```
    public static var both: Self {
        .init(positive: "+", negative: .minusSign, zero: "")
    }

    /// Displays empty string (`""`) for positive, negative and zero values.
    ///
    /// ```swift
    /// // When the amount is positive then the sign is empty string ("").
    /// let amount = Money(120.30)
    ///     .sign(.none) // ← Specifying the sign
    ///
    /// print(amount) // "$120.30"
    ///
    /// // When the amount is negative then the sign is empty string ("").
    /// let amount = Money(-120.30)
    ///     .sign(.none) // ← Specifying the sign
    ///
    /// print(amount) // "$120.30"
    /// ```
    public static var none: Self {
        .init(positive: "", negative: "", zero: "")
    }
}

// MARK: - Helpers

extension Money {
    public typealias Sign = SignedNumericSign

    /// Returns the sign of the current amount.
    var currentSign: String {
        if amount == 0 {
            return sign.zero
        }

        return amount > 0 ? sign.positive : sign.negative
    }
}
