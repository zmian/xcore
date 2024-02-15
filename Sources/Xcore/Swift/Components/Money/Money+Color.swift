//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Money {
    /// A structure representing colors used to format money.
    public struct Color: Sendable, Hashable {
        /// The color for positive values.
        public let positive: SwiftUI.Color

        /// The color for negative values.
        public let negative: SwiftUI.Color

        /// The color for zero (`0`) values.
        public let zero: SwiftUI.Color

        /// Creates an instance of color.
        ///
        /// - Parameters:
        ///   - positive: The color for positive values.
        ///   - negative: The color for negative values.
        ///   - zero: The color for zero (`0`) values.
        public init(
            positive: SwiftUI.Color,
            negative: SwiftUI.Color,
            zero: SwiftUI.Color
        ) {
            self.positive = positive
            self.negative = negative
            self.zero = zero
        }

        /// Creates an instance of color.
        ///
        /// - Parameter color: The color for positive, negative and zero values.
        public init(_ color: SwiftUI.Color) {
            self.positive = color
            self.negative = color
            self.zero = color
        }
    }
}
