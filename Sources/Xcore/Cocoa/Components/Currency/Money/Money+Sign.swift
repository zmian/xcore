//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Money {
    /// A structure representing signs (+/-) used to display money.
    public struct Sign: Hashable {
        /// The string used to represent a positive sign for positive values.
        public let positive: String

        /// The string used to represent a negative sign for negative values.
        public let negative: String

        public init(positive: String, negative: String) {
            self.positive = positive
            self.negative = negative
        }
    }
}

// MARK: - Built-in

extension Money.Sign {
    /// ```swift
    /// // When the amount is positive then the output is "".
    /// let amount = Money(120.30)
    ///     .sign(.default) // ← Specifying sign output
    ///
    /// print(amount) // "$120.30"
    ///
    /// // When the amount is negative then the output is "-".
    /// let amount = Money(-120.30)
    ///     .sign(.default) // ← Specifying sign output
    ///
    /// print(amount) // "-$120.30"
    /// ```
    public static var `default`: Self {
        .init(positive: "", negative: "-")
    }

    /// ```swift
    /// // When the amount is positive then the output is "+".
    /// let amount = Money(120.30)
    ///     .sign(.both) // ← Specifying sign output
    ///
    /// print(amount) // "+$120.30"
    ///
    /// // When the amount is negative then the output is "-".
    /// let amount = Money(-120.30)
    ///     .sign(.both) // ← Specifying sign output
    ///
    /// print(amount) // "-$120.30"
    /// ```
    public static var both: Self {
        .init(positive: "+", negative: "-")
    }

    /// ```swift
    /// // When the amount is positive then the output is "".
    /// let amount = Money(120.30)
    ///     .sign(.none) // ← Specifying sign output
    ///
    /// print(amount) // "$120.30"
    ///
    /// // When the amount is negative then the output is "".
    /// let amount = Money(-120.30)
    ///     .sign(.none) // ← Specifying sign output
    ///
    /// print(amount) // "$120.30"
    /// ```
    public static var none: Self {
        .init(positive: "", negative: "")
    }
}
