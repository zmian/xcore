//
// Currency+Components+Style.swift
//
// Copyright © 2017 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

extension Currency.Components {
    /// An enumeration that represent formatting styles for currency components.
    public indirect enum Style: Equatable {
        case none
        case removeCentsIfZero
        case removeCents
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
