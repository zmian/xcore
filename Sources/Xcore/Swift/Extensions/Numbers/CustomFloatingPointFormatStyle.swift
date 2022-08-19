//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Kind

extension CustomFloatingPointFormatStyle {
    /// An enumeration representing the type of formatting.
    public enum Kind: Codable, Hashable {
        /// Formats as a number.
        case number

        /// Formats as a number to the compact representation.
        case abbreviated(threshold: Value?)

        /// Formats as percentage using the given scale.
        case percent(scale: PercentageScale)

        /// An enumeration representing the scale of percent formatting.
        public enum PercentageScale: Codable, Hashable, Sendable {
            /// Percentage scale is: `0.0 - 1.0`.
            case zeroToOne

            /// Percentage scale is: `0 - 100`.
            case zeroToHundred
        }
    }
}

// MARK: - FormatStyle

/// A structure that creates a locale-appropriate string representation of a
/// double and decimal instance.
public struct CustomFloatingPointFormatStyle<Value: DoubleOrDecimalProtocol>: Codable, Hashable, MutableAppliable {
    public let type: Kind
    public var locale: Locale = .numbers
    public var sign: SignedNumericSign = .default
    public var fractionLength: ClosedRange<Int>?
    public var trimFractionalPartIfZero = true
    public var minimumBound: Value?

    public init(type: Kind) {
        self.type = type
    }
}

// MARK: - Chaining Syntactic Syntax

extension CustomFloatingPointFormatStyle {
    /// The locale to use when formatting the value.
    public func locale(_ locale: Locale) -> Self {
        applying {
            $0.locale = locale
        }
    }

    /// The sign (+/−) used to format value.
    public func sign(_ sign: SignedNumericSign) -> Self {
        applying {
            $0.sign = sign
        }
    }

    /// The minimum and maximum number of digits after the decimal separator.
    public func fractionLength(_ limits: ClosedRange<Int>?) -> Self {
        applying {
            $0.fractionLength = limits
        }
    }

    /// The minimum and maximum number of digits after the decimal separator.
    @_disfavoredOverload
    public func fractionLength(_ limit: Int?) -> Self {
        fractionLength(limit.map { $0...$0 })
    }

    /// Omits the fractional part from the formatted value if the value is a whole
    /// number.
    ///
    /// ```swift
    /// 1.formatted(.asRounded)
    /// // Outputs "1"
    ///
    /// 1.formatted(.asRounded.trimFractionalPartIfZero(false))
    /// // Outputs "1.00"
    ///
    /// 1.09.formatted(.asRounded)
    /// // Outputs "1.09"
    ///
    /// 1.9.formatted(.asRounded)
    /// // Outputs "1.90"
    /// ```
    public func trimFractionalPartIfZero(_ trim: Bool) -> Self {
        applying {
            $0.trimFractionalPartIfZero = trim
        }
    }

    /// The value must be greater than the given value; otherwise, formatted string
    /// will return formatted "minimum bound" value with "<" character prepended.
    ///
    /// For example:
    ///
    /// ```swift
    /// -0.0000109.formatted(.asPercent.minimumBound(0.0001))
    /// // Outputs "<−0.01%"
    ///
    /// -0.019.formatted(.asPercent.minimumBound(0.0001))
    /// // Outputs "−1.90%"
    /// ```
    public func minimumBound(_ value: Value?) -> Self {
        applying {
            $0.minimumBound = value
        }
    }
}

// MARK: - Format

extension CustomFloatingPointFormatStyle {
    /// Creates a locale-aware string representation from a value.
    ///
    /// - Parameter value: The floating point value to format.
    /// - Returns: A string representation of the value.
    public func format(_ value: Value) -> String {
        let value = normalize(value)
        let sign = value == 0 ? sign.zero : (value > 0 ? sign.positive : sign.negative)
        let fractionLength = normalizeFractionLength(value)

        // MinimumBound
        let valueToUse: Value = {
            guard
                let minimumBound = minimumBound,
                abs(value) < minimumBound
            else {
                return value
            }

            return value >= 0 ? minimumBound : -minimumBound
        }()

        var formattedString = formatter.string(
            from: valueToUse,
            type: type,
            fractionLength: fractionLength,
            locale: locale
        )

        // 0.02 → "2.00%" → "2%"
        if trimFractionalPartIfZero {
            let parts = formattedString
                .components(separatedBy: locale.decimalSeparator ?? ".")

            // ["2", "30%"] → "30%"
            let fractionalPart = parts.at(1)

            if let fractionalPart = fractionalPart, let whole = parts.first {
                // "30%" → "30"
                let fractionalPartDigits = fractionalPart.replacing("\\D", with: "")
                // "30%" → "%"
                lazy var fractionalPartNonDigits = fractionalPart.replacing("\\d", with: "")

                if Int64(fractionalPartDigits) == 0 {
                    formattedString = whole + fractionalPartNonDigits
                }
            }
        }

        let formattedValue = sign + formattedString
        return value == valueToUse ? formattedValue : "<\(formattedValue)"
    }

    /// Normalize `0 - 100` scale to `0.0 - 1.0` to match `NumberFormatter` scale
    /// for `percent` numbers.
    private func normalize(_ value: Value) -> Value {
        switch type {
            case .number, .abbreviated:
                return value
            case .percent(scale: .zeroToOne):
                return value
            case .percent(scale: .zeroToHundred):
                return value / 100
        }
    }

    private func normalizeFractionLength(_ value: Value) -> ClosedRange<Int> {
        if trimFractionalPartIfZero, value.isFractionalPartZero {
            return 0...0
        }

        if let fractionLength = fractionLength {
            return fractionLength
        }

        switch type {
            case .number, .abbreviated:
                return value.calculatePrecision()
            case .percent:
                // Ensure when using `calculatePrecision` we are actually using the final value.
                // "0.008379 * 100" → "0.8379.calculatePrecision()" → (2...2) → "0.84%"
                return (value * 100).calculatePrecision()
        }
    }
}

extension CustomFloatingPointFormatStyle: Foundation.FormatStyle {}

// MARK: - Double

// TODO: Uncomment when dropping iOS 14 Support
// extension FormatStyle where Self == CustomFloatingPointFormatStyle<Double> {
extension CustomFloatingPointFormatStyle where Value == Double {
    /// Returns a number format style suitable for number types.
    ///
    /// ```swift
    /// // Usage
    /// print(1.formatted(.asNumber)) // "1"
    ///
    /// 1          → "1"
    /// 1.09       → "1.09"
    /// 1.9        → "1.9"
    /// 2.1345     → "2.1345"
    /// -2.1355    → "−2.1355"
    /// -2.1355    → "−2.1355"
    /// 20024.1355 → "20,024.1355"
    /// ```
    public static var asNumber: Self {
        .init(type: .number)
            .fractionLength(.maxFractionDigits)
    }

    /// Returns a number format style suitable for number types and ensures fraction
    /// part is at least 2 places.
    ///
    /// ```swift
    /// // Usage
    /// print(1.formatted(.asRounded)) // "1"
    ///
    /// 1          → "1"
    /// 1.09       → "1.09"
    /// 1.9        → "1.90"
    /// 2.1345     → "2.13"
    /// -2.1355    → "−2.14"
    /// 20024.1355 → "20,024.14"
    /// ```
    public static var asRounded: Self {
        .init(type: .number)
    }

    /// Returns a percent format style with the scale from `0.0 - 1.0`.
    ///
    /// ```swift
    /// // scale: .zeroToOne (default)
    /// 0.019   → "1.90%"
    /// -0.0109 → "−1.09%"
    /// 0.02    → "2%"
    /// ```
    public static var asPercent: Self {
        .asPercent(scale: .zeroToOne)
    }

    /// Returns a percent format style based on the provided scale.
    ///
    /// ```swift
    /// // scale: .zeroToHundred
    /// 1      → "1%"
    /// 1.09   → "1.09%"
    /// 1.9    → "1.90%"
    /// 2.1345 → "2.13%"
    /// 2.1355 → "2.14%"
    ///
    /// // scale: .zeroToOne (default)
    /// 0.019   → "1.90%"
    /// -0.0109 → "−1.09%"
    /// 0.02    → "2%"
    ///
    /// // scale: .zeroToOne (default), trimFractionalPartIfZero: false
    /// 0.019   → "1.90%"
    /// -0.0109 → "−1.09%"
    /// 0.02    → "2.00%"
    ///
    /// // scale: .zeroToOne (default), minimumBound: 0.01
    /// 0.019      → "+1.90%"
    /// -0.0000109 → "<−0.01%"
    /// 0.0000109  → "<0.01"
    ///
    /// // scale: .zeroToOne (default), fractionLength: 0, sign: .both
    /// 0.019   → "+2%"
    /// -0.0109 → "−1%"
    /// 0.02    → "+2%"
    ///
    /// ```
    public static func asPercent(scale: Self.Kind.PercentageScale) -> Self {
        .init(type: .percent(scale: scale))
    }

    /// Returns a format style suitable for compact representation of numbers.
    ///
    /// Abbreviates `value` to the compact representation:
    ///
    /// ```swift
    /// 987     // → 987
    /// 1200    // → 1.2K
    /// 12000   // → 12K
    /// 120000  // → 120K
    /// 1200000 // → 1.2M
    /// 1340    // → 1.3K
    /// 132456  // → 132.5K
    /// ```
    public static var asAbbreviated: Self {
        .asAbbreviated(threshold: nil)
    }

    /// Returns a format style suitable for compact representation of numbers.
    ///
    /// Abbreviates `value` to the compact representation:
    ///
    /// ```swift
    /// 987     // → 987
    /// 1200    // → 1.2K
    /// 12000   // → 12K
    /// 120000  // → 120K
    /// 1200000 // → 1.2M
    /// 1340    // → 1.3K
    /// 132456  // → 132.5K
    /// ```
    ///
    /// - Parameter threshold: An optional property to only abbreviate if `value` is
    ///   greater then this value.
    public static func asAbbreviated(threshold: Value?) -> Self {
        .init(type: .abbreviated(threshold: threshold))
            .fractionLength(.defaultFractionDigits)
            .trimFractionalPartIfZero(false)
    }
}

// MARK: - Decimal

// TODO: Uncomment when dropping iOS 14 Support
// extension FormatStyle where Self == CustomFloatingPointFormatStyle<Decimal> {
extension CustomFloatingPointFormatStyle where Value == Decimal {
    /// Returns a number format style suitable for number types.
    ///
    /// ```swift
    /// // Usage
    /// print(1.formatted(.asNumber)) // "1"
    ///
    /// 1          → "1"
    /// 1.09       → "1.09"
    /// 1.9        → "1.9"
    /// 2.1345     → "2.1345"
    /// -2.1355    → "−2.1355"
    /// -2.1355    → "−2.1355"
    /// 20024.1355 → "20,024.1355"
    /// ```
    public static var asNumber: Self {
        .init(type: .number)
            .fractionLength(.maxFractionDigits)
    }

    /// Returns a number format style suitable for number types and ensures fraction
    /// part is at least 2 places.
    ///
    /// ```swift
    /// // Usage
    /// print(1.formatted(.asRounded)) // "1"
    ///
    /// 1          → "1"
    /// 1.09       → "1.09"
    /// 1.9        → "1.90"
    /// 2.1345     → "2.13"
    /// -2.1355    → "−2.14"
    /// 20024.1355 → "20,024.14"
    /// ```
    public static var asRounded: Self {
        .init(type: .number)
    }

    /// Returns a percent format style with the scale from `0.0 - 1.0`.
    ///
    /// ```swift
    /// // scale: .zeroToOne (default)
    /// 0.019   → "1.90%"
    /// -0.0109 → "−1.09%"
    /// 0.02    → "2%"
    /// ```
    public static var asPercent: Self {
        .asPercent(scale: .zeroToOne)
    }

    /// Returns a percent format style based on the provided scale.
    ///
    /// ```swift
    /// // scale: .zeroToHundred
    /// 1      → "1%"
    /// 1.09   → "1.09%"
    /// 1.9    → "1.90%"
    /// 2.1345 → "2.13%"
    /// 2.1355 → "2.14%"
    ///
    /// // scale: .zeroToOne (default)
    /// 0.019   → "1.90%"
    /// -0.0109 → "−1.09%"
    /// 0.02    → "2%"
    ///
    /// // scale: .zeroToOne (default), trimFractionalPartIfZero: false
    /// 0.019   → "1.90%"
    /// -0.0109 → "−1.09%"
    /// 0.02    → "2.00%"
    ///
    /// // scale: .zeroToOne (default), minimumBound: 0.01
    /// 0.019      → "+1.90%"
    /// -0.0000109 → "<−0.01%"
    /// 0.0000109  → "<0.01"
    ///
    /// // scale: .zeroToOne (default), fractionLength: 0, sign: .both
    /// 0.019   → "+2%"
    /// -0.0109 → "−1%"
    /// 0.02    → "+2%"
    ///
    /// ```
    public static func asPercent(scale: Self.Kind.PercentageScale) -> Self {
        .init(type: .percent(scale: scale))
    }

    /// Returns a format style suitable for compact representation of numbers.
    ///
    /// Abbreviates `value` to the compact representation:
    ///
    /// ```swift
    /// 987     // → 987
    /// 1200    // → 1.2K
    /// 12000   // → 12K
    /// 120000  // → 120K
    /// 1200000 // → 1.2M
    /// 1340    // → 1.3K
    /// 132456  // → 132.5K
    /// ```
    public static var asAbbreviated: Self {
        .asAbbreviated(threshold: nil)
    }

    /// Returns a format style suitable for compact representation of numbers.
    ///
    /// Abbreviates `value` to the compact representation:
    ///
    /// ```swift
    /// 987     // → 987
    /// 1200    // → 1.2K
    /// 12000   // → 12K
    /// 120000  // → 120K
    /// 1200000 // → 1.2M
    /// 1340    // → 1.3K
    /// 132456  // → 132.5K
    /// ```
    ///
    /// - Parameter threshold: An optional property to only abbreviate if `value` is
    ///   greater then this value.
    public static func asAbbreviated(threshold: Value?) -> Self {
        .init(type: .abbreviated(threshold: threshold))
            .fractionLength(.defaultFractionDigits)
            .trimFractionalPartIfZero(false)
    }
}

extension DoubleOrDecimalProtocol {
    /// Returns a string by formatting `self` using the given rule..
    @available(iOS, introduced: 14, deprecated: 15, message: "Use Decimal.formatted and Double.formatted directly.")
    public func formatted(_ rule: CustomFloatingPointFormatStyle<Self>) -> String {
        rule.format(self)
    }
}

// MARK: - Helpers

private let formatter = FormatStyleFormatter()

private final class FormatStyleFormatter {
    private let formatter = NumberFormatter().apply {
        $0.numberStyle = .decimal
        $0.roundingMode = .halfUp
        $0.positivePrefix = ""
        $0.negativePrefix = ""
    }

    func string<Value>(
        from value: Value,
        type: CustomFloatingPointFormatStyle<Value>.Kind,
        fractionLength: ClosedRange<Int>,
        locale: Locale
    ) -> String where Value: DoubleOrDecimalProtocol {
        formatter.synchronized {
            formatter.locale = locale
            formatter.fractionLength = fractionLength
            formatter.numberStyle = .decimal

            switch type {
                case .number:
                    return formatter.string(from: value) ?? ""
                case .percent:
                    formatter.numberStyle = .percent
                    return formatter.string(from: value) ?? ""
                case let .abbreviated(threshold):
                    typealias Abbreviation = (suffix: String, threshold: Value, divisor: Value)

                    let abbreviations: [Abbreviation] = [
                        ("", 0, 1),
                        ("K", 1000, 1000),
                        ("M", 499_000, 1_000_000),
                        ("M", 1_000_000, 1_000_000),
                        ("B", 1_000_000_000, 1_000_000_000),
                        ("T", 1_000_000_000_000, 1_000_000_000_000)
                    ]

                    let abbreviation: Abbreviation = {
                        // Adopted from: http://stackoverflow.com/a/35504720
                        let value = abs(value)

                        if let threshold = threshold, threshold > value {
                            return abbreviations[0]
                        }

                        var prevAbbreviation = abbreviations[0]

                        for tmpAbbreviation in abbreviations {
                            if value < tmpAbbreviation.threshold {
                                break
                            }
                            prevAbbreviation = tmpAbbreviation
                        }

                        return prevAbbreviation
                    }()

                    let abbreviatedValue = value / abbreviation.divisor
                    formatter.fractionLength = value == abbreviatedValue ? .maxFractionDigits : fractionLength
                    return formatter.string(from: abbreviatedValue).map { $0 + abbreviation.suffix } ?? ""
            }
        }
    }
}
