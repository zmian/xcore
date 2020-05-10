//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Currency.Components {
    /// An enumeration that represent formatting styles for currency components.
    public indirect enum Style: Equatable {
        case none

        /// ```swift
        /// let amount = Decimal(120.30)
        /// // 120 - major unit
        /// // 30 - minor unit
        /// ```
        case removeMinorUnitIfZero

        /// ```swift
        /// let amount = Decimal(120.30)
        /// // 120 - major unit
        /// // 30 - minor unit
        /// ```
        case removeMinorUnit

        case abbreviationWith(threshold: Double, fallback: Style)

        /// Abbreviate `self` to smaller format.
        ///
        /// ```swift
        /// 987     // -> 987
        /// 1200    // -> 1.2K
        /// 12000   // -> 12K
        /// 120000  // -> 120K
        /// 1200000 // -> 1.2M
        /// 1340    // -> 1.3K
        /// 132456  // -> 132.5K
        /// ```
        ///
        /// - Parameters:
        ///   - threshold: A property to only apply abbreviation
        ///                if `self` is greater then given threshold.
        ///   - fallback: The formatting style to use when threshold isn't reached.
        /// - Returns: Abbreviated version of `self`.
        public static func abbreviation(threshold: Double, fallback: Style = .none) -> Style {
            var fallback = fallback
            if case .abbreviationWith = fallback {
                #if DEBUG
                fatalError(because: .unsupportedFallbackFormattingStyle)
                #else
                fallback = .none
                #endif
            }
            return .abbreviationWith(threshold: threshold, fallback: fallback)
        }
    }
}
