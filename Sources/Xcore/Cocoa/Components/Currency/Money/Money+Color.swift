//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Money {
    /// A structure representing colors used to display money.
    public struct Color: Hashable {
        /// The color to use when the amount is positive.
        public let positive: UIColor

        /// The color to use when the amount is negative.
        public let negative: UIColor

        /// The custom color to use when the amount is `0`.
        public let zero: UIColor

        public init(positive: UIColor, negative: UIColor, zero: UIColor) {
            self.positive = positive
            self.negative = negative
            self.zero = zero
        }

        public init(_ color: UIColor) {
            self.positive = color
            self.negative = color
            self.zero = color
        }
    }
}

// MARK: - Built-in

extension Money.Color {
    /// A color representing absent of value.
    ///
    /// This instance can be used to indicate to the formatter to ignore color.
    public static var none: Self {
        .init(.clear)
    }
}
