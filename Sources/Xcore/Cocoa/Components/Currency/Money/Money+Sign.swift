//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Money {
    /// A structure representing signs (+/-) used to display money.
    public struct Sign: Hashable {
        /// The string used to represent a plus sign.
        public let plus: String

        /// The string used to represent a minus sign.
        public let minus: String

        public init(plus: String, minus: String) {
            self.plus = plus
            self.minus = minus
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
        .init(plus: "", minus: "-")
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
        .init(plus: "+", minus: "-")
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
        .init(plus: "", minus: "")
    }
}
