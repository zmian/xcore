//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Money {
    public struct Color: Hashable {
        /// The color to use when the amount is positive.
        public let positive: UIColor

        /// The color to use when the amount is negative.
        public let negative: UIColor

        /// The custom color to use when the amount is `0`.
        ///
        /// The default value is `nil`.
        public let zero: UIColor?

        public init(positive: UIColor, negative: UIColor, zero: UIColor? = nil) {
            self.positive = positive
            self.negative = negative
            self.zero = zero
        }

        public init(_ color: UIColor) {
            self.positive = color
            self.negative = color
            self.zero = nil
        }
    }
}

// MARK: - Built-in

extension Money.Color {
    public static var none: Self {
        .init(.clear)
    }

    public static var white: Self {
        .init(.white)
    }

    public static var black: Self {
        .init(.black)
    }
}
