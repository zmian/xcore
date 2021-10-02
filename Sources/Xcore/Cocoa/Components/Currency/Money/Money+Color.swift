//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Money {
    /// A structure representing colors used to display money.
    public struct Color: Hashable {
        /// The color to use when the amount is positive.
        public let positive: SwiftUI.Color

        /// The color to use when the amount is negative.
        public let negative: SwiftUI.Color

        /// The custom color to use when the amount is `0`.
        public let zero: SwiftUI.Color

        public init(
            positive: SwiftUI.Color,
            negative: SwiftUI.Color,
            zero: SwiftUI.Color
        ) {
            self.positive = positive
            self.negative = negative
            self.zero = zero
        }

        public init(_ color: SwiftUI.Color) {
            self.positive = color
            self.negative = color
            self.zero = color
        }
    }
}

// MARK: - UIColor

extension Money.Color {
    @_disfavoredOverload
    public init(
        positive: UIColor,
        negative: UIColor,
        zero: UIColor
    ) {
        self.init(
            positive: .init(positive),
            negative: .init(negative),
            zero: .init(zero)
        )
    }

    @_disfavoredOverload
    public init(_ color: UIColor) {
        self.init(.init(color))
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
