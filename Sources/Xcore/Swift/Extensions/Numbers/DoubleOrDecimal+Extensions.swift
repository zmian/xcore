//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// An enumeration representing rules for formatting numbers to a string
/// representation.
public enum NumericsStringFormattingRule {
    /// Format the output to ensure 2 places.
    ///
    /// ```swift
    /// // trimZero: false (default)
    /// 1      → "1.00"
    /// 1.09   → "1.09"
    /// 1.9    → "1.90"
    /// 2.1345 → "2.13"
    /// 2.1355 → "2.14"
    ///
    /// // trimZero: true
    /// 1      → "1"
    /// 1.09   → "1.09"
    /// 1.9    → "1.90"
    /// 2.1345 → "2.13"
    /// 2.1355 → "2.14"
    /// ```
    case rounded(trimZero: Bool = false)

    /// Format the output to ensure 2 places.
    ///
    /// ```swift
    /// // trimZero: false (default)
    /// 1      → "1.00"
    /// 1.09   → "1.09"
    /// 1.9    → "1.90"
    /// 2.1345 → "2.13"
    /// 2.1355 → "2.14"
    /// ```
    public static var rounded: Self {
        rounded(trimZero: false)
    }

    /// Formats as percentage from a `0.0 - 1.0` scale as default.
    ///
    /// ```swift
    /// // scale: .zeroToHundred
    /// 1      → "1%"
    /// 1.09   → "1.09%"
    /// 1.9    → "1.9%"
    /// 2.1345 → "2.13%"
    /// 2.1355 → "2.14%"
    ///
    /// // scale: .zeroToOne (default), fractionLength: 0...0
    /// 0.019   → "2%"
    /// -0.0109 → "-1%"
    /// 0.02    → "2%"
    ///
    /// // scale: .zeroToOne (default), fractionLength: 0...2
    /// 0.019   → "1.9%"
    /// -0.0109 → "-1.09%"
    /// 0.02    → "2%"
    ///
    /// // scale: .zeroToOne (default), fractionLength: 2...2, showPlusSign: true
    /// 0.019   → "+1.90%"
    /// -0.0109 → "-1.09%"
    /// 0.02    → "+2.00%"
    ///
    /// // scale: .zeroToOne (default), minimumBound: 0.01
    /// 0.019   → "+1.90%"
    /// -0.0000109 → "<-0.01%"
    /// 0.0000109  → "<0.01"
    /// ```
    case percentage(
        scale: PercentageScale = .zeroToOne,
        /* minimumBound: any DoubleOrDecimalProtocol? = nil, Swift 5.7 */
        fractionLength: ClosedRange<Int> = .defaultFractionDigits
    )

    /// Formats as percentage from a `0.0 - 1.0` scale as default.
    ///
    /// ```swift
    /// // scale: .zeroToOne (default), fractionLength: 0...2
    /// 0.019   → "1.9%"
    /// -0.0109 → "-1.09%"
    /// 0.02    → "2%"
    /// ```
    public static var percentage: Self {
        percentage()
    }

    /// Formats as percentage from a `0.0 - 1.0` scale as default.
    ///
    /// ```swift
    /// // scale: zeroToHundred, fractionLength: 0
    /// 1      → "1%"
    /// 1.09   → "1%"
    /// 1.9    → "2%"
    /// 2.1345 → "2%"
    /// 2.1355 → "2%"
    ///
    /// // scale: zeroToOne (default), fractionLength: 0
    /// 0.019   → "2%"
    /// -0.0109 → "-1%"
    /// 0.02    → "2%"
    ///
    /// // scale: zeroToOne (default), fractionLength: 2, showPlusSign: true
    /// 0       → "+0.00%"
    /// 0.019   → "+1.90%"
    /// -0.0109 → "-1.09%"
    /// 0.02    → "+2.00%"
    ///
    /// // scale: zeroToOne (default), minimumBound: 0.0001, showPlusSign: true
    /// 0.019      → "+1.90%"
    /// -0.0000109 → "<-0.01%"
    /// 0.0000109  → "<0.01"
    /// ```
    public static func percentage(
        scale: PercentageScale = .zeroToOne,
        fractionLength: Int
    ) -> Self {
        percentage(
            scale: scale,
            fractionLength: fractionLength...fractionLength
        )
    }

    /// An enumeration representing the scale of the percentage.
    public enum PercentageScale {
        /// Percentage scale is: `0.0 - 1.0`.
        case zeroToOne

        /// Percentage scale is: `0 - 100`.
        case zeroToHundred
    }
}

extension DoubleOrDecimalProtocol {
    /// Returns a string by formatting `self` using the given rule..
    ///
    /// **Rounded Rule:**
    ///
    /// ```swift
    /// print(1.formatted(.rounded))      // "1.00"
    /// print(1.09.formatted(.rounded))   // "1.09"
    /// print(1.9.formatted(.rounded))    // "1.90"
    /// print(2.1345.formatted(.rounded)) // "2.13"
    /// print(2.1355.formatted(.rounded)) // "2.14"
    /// ```
    ///
    /// **Percentage Rule:**
    ///
    /// ```swift
    /// print(0.019.formatted(.percentage))   // "1.9%"
    /// print(-0.0109.formatted(.percentage)) // "−1.09%"
    /// print(0.02.formatted(.percentage))    // "2%"
    /// print(1.formatted(.percentage))       // "100%"
    /// ```
    ///
    /// **Percentage Rule with fraction length:**
    ///
    /// ```swift
    /// print(0.019.formatted(.percentage(fractionLength: 2)))   // "1.90%"
    /// print(-0.0109.formatted(.percentage(fractionLength: 2))) // "−1.09%"
    /// print(0.02.formatted(.percentage(fractionLength: 2)))    // "2.00%"
    /// print(1.formatted(.percentage(fractionLength: 2)))       // "100.00%"
    /// ```
    public func formatted(
        _ rule: NumericsStringFormattingRule,
        showPlusSign: Bool = false,
        minimumBound: Self? = nil /* Remove in Swift 5.7 */
    ) -> String {
        switch rule {
            case let .rounded(trimZero):
                let fractionLength = trimZero && isFractionZero ? 0...0 : 2...2

                if #available(iOS 15.0, *) {
                    if let number = self as? Decimal {
                        return number.formatted(
                            .number
                                .precision(.fractionLength(fractionLength))
                                .sign(strategy: showPlusSign ? .both : .automatic)
                                .rounded(rule: .toNearestOrAwayFromZero)
                        )
                    }
                }

                let sign = showPlusSign && self > 0 ? "+" : ""
                numberFormatter.fractionLength = fractionLength
                return sign + (numberFormatter.string(from: nsNumber) ?? "")

            case let .percentage(scale, fractionLength):
                let value = normalize(scale: scale)

                var valueToUse: Self {
                    guard
                        let minimumBound = minimumBound,
                        value != 0,
                        abs(value) < minimumBound
                    else {
                        return value
                    }

                    return value >= 0 ? minimumBound : -minimumBound
                }

                let showPlusSign = showPlusSign && value > 0 && value == valueToUse

                if #available(iOS 15.0, *) {
                    if let number = valueToUse as? Decimal {
                        let formattedValue = number.formatted(
                            .percent
                                .precision(.fractionLength(fractionLength))
                                .sign(strategy: showPlusSign ? .both : .automatic)
                                .rounded(rule: .toNearestOrAwayFromZero)
                        )

                        return value == valueToUse ? formattedValue : "<\(formattedValue)"
                    }
                }

                let formattedValue = percentFormatter.apply {
                    $0.fractionLength = fractionLength
                    $0.positivePrefix = showPlusSign ? "+" : ""
                }
                .string(from: valueToUse) ?? ""

                return value == valueToUse ? formattedValue : "<\(formattedValue)"
        }
    }

    /// Normalize `0 - 100` scale to `0.0 - 1.0` to match `NumberFormatter` scale
    /// for `percent` numbers.
    private func normalize(scale: NumericsStringFormattingRule.PercentageScale) -> Self {
        switch scale {
            case .zeroToOne:
                return self
            case .zeroToHundred:
                return self / 100
        }
    }
}

private let percentFormatter = NumberFormatter().apply {
    $0.numberStyle = .percent
    $0.roundingMode = .halfUp
}

private let numberFormatter = NumberFormatter().apply {
    $0.numberStyle = .decimal
    $0.roundingMode = .halfUp
}
