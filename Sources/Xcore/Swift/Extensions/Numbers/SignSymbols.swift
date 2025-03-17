//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension NumberFormatStyleConfiguration {
    /// A structure representing signs symbols (+/−) used to format signed numeric
    /// types.
    public struct SignSymbols: Sendable, Hashable, Codable {
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
}

// MARK: - Built-in

extension NumberFormatStyleConfiguration.SignSymbols {
    /// Displays minus sign (`"−"`) for the negative values and empty string (`""`)
    /// for positive and zero values.
    ///
    /// ```swift
    /// // When the amount is positive then the sign is empty string ("").
    /// let amount = Money(120.30)
    ///     .signSymbols(.default) // ← Specifying the sign
    ///
    /// print(amount) // "$120.30"
    ///
    /// // When the amount is negative then the sign is "−".
    /// let amount = Money(-120.30)
    ///     .signSymbols(.default) // ← Specifying the sign
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
    ///     .signSymbols(.onlyPositive) // ← Specifying the sign
    ///
    /// print(amount) // "+$120.30"
    ///
    /// // When the amount is negative then the sign is empty string ("").
    /// let amount = Money(-120.30)
    ///     .signSymbols(.onlyPositive) // ← Specifying the sign
    ///
    /// print(amount) // "$120.30"
    /// ```
    public static var onlyPositive: Self {
        .init(positive: "+", negative: "", zero: "")
    }

    /// Displays plus sign (`"+"`) for the positive values, minus sign (`"−"`) for
    /// the negative values and empty string (`""`) for zero values.
    ///
    /// ```swift
    /// // When the amount is positive then the sign is "+".
    /// let amount = Money(120.30)
    ///     .signSymbols(.both) // ← Specifying the sign
    ///
    /// print(amount) // "+$120.30"
    ///
    /// // When the amount is negative then the sign is "−".
    /// let amount = Money(-120.30)
    ///     .signSymbols(.both) // ← Specifying the sign
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
    ///     .signSymbols(.none) // ← Specifying the sign
    ///
    /// print(amount) // "$120.30"
    ///
    /// // When the amount is negative then the sign is empty string ("").
    /// let amount = Money(-120.30)
    ///     .signSymbols(.none) // ← Specifying the sign
    ///
    /// print(amount) // "$120.30"
    /// ```
    public static var none: Self {
        .init(positive: "", negative: "", zero: "")
    }
}

// MARK: - SignedNumeric

extension SignedNumeric where Self: Comparable {
    /// Returns the sign symbol of `self`.
    func signSymbol(_ signSymbols: NumberFormatStyleConfiguration.SignSymbols) -> String {
        if self == .zero {
            return signSymbols.zero
        }

        return self > .zero ? signSymbols.positive : signSymbols.negative
    }
}
