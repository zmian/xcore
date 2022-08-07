//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Kind

extension CustomFloatingPointFormatStyle {
    /// An enumeration representing the type of formatting.
    public enum Kind: Codable, Hashable, Sendable {
        /// Formats as a number.
        case number

        /// Formats as percentage using the given scale.
        case percent(scale: PercentageScale)

        /// An enumeration representing the scale of the percentage.
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
    public var locale: Locale = .defaultNumbers
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
    /// 1.formatted(.asNumber)
    /// // Outputs "1"
    ///
    /// 1.formatted(.asNumber.trimFractionalPartIfZero(false))
    /// // Outputs "1.00"
    ///
    /// 1.09.formatted(.asNumber)
    /// // Outputs "1.09"
    ///
    /// 1.9.formatted(.asNumber)
    /// // Outputs "1.90"
    ///
    /// 2.1345.formatted(.asNumber)
    /// // Outputs "2.13"
    ///
    /// 2.1355.formatted(.asNumber)
    /// // Outputs "2.14"
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
        let currentSign = value == 0 ? sign.zero : (value > 0 ? sign.positive : sign.negative)
        let fractionLength = normalizeFractionLength(value)

        // MinimumBound
        var valueToUse: Value {
            guard
                let minimumBound = minimumBound,
                abs(value) < minimumBound
            else {
                return value
            }

            return value >= 0 ? minimumBound : -minimumBound
        }

        var numberFormattedString: String {
            if #available(iOS 15.0, *) {
                if let number = valueToUse as? Decimal {
                    return number.formatted(
                        .number
                            .precision(.fractionLength(fractionLength))
                            .sign(strategy: .never)
                            .locale(locale)
                            .rounded(rule: .toNearestOrAwayFromZero)
                    )
                }
            }

            numberFormatter.locale = locale
            numberFormatter.fractionLength = fractionLength
            return numberFormatter.string(from: valueToUse) ?? ""
        }

        var percentFormattedString: String {
            if #available(iOS 15.0, *) {
                if let number = valueToUse as? Decimal {
                    return number.formatted(
                        .percent
                            .precision(.fractionLength(fractionLength))
                            .sign(strategy: .never)
                            .locale(locale)
                            .rounded(rule: .toNearestOrAwayFromZero)
                    )
                }
            }

            percentFormatter.locale = locale
            percentFormatter.fractionLength = fractionLength
            return percentFormatter.string(from: valueToUse) ?? ""
        }

        var formattedString: String = {
            switch type {
                case .number:
                    return numberFormattedString
                case .percent:
                    return percentFormattedString
            }
        }()

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

        let formattedValue = currentSign + formattedString
        return value == valueToUse ? formattedValue : "<\(formattedValue)"
    }

    /// Normalize `0 - 100` scale to `0.0 - 1.0` to match `NumberFormatter` scale
    /// for `percent` numbers.
    private func normalize(_ value: Value) -> Value {
        switch type {
            case .number:
                return value
            case .percent(scale: .zeroToOne):
                return value
            case .percent(scale: .zeroToHundred):
                return value / 100
        }
    }

    private func normalizeFractionLength(_ value: Value) -> ClosedRange<Int> {
        if trimFractionalPartIfZero && value.isFractionalPartZero {
            return 0...0
        }

        if let fractionLength = fractionLength {
            return fractionLength
        }

        switch type {
            case .number:
                return value.calculatePrecision()
            case .percent:
                // Ensure when using `calculatePrecision` we are actually using the final value.
                // "0.008379" → "0.84%"
                return (value * 100).calculatePrecision()
        }
    }
}

extension CustomFloatingPointFormatStyle: Foundation.FormatStyle {}

// MARK: - Double

// TODO: Uncomment when dropping iOS 14 Support
// extension FormatStyle where Self == CustomFloatingPointFormatStyle<Double> {
extension CustomFloatingPointFormatStyle where Value == Double {
    /// Format the output to ensure 2 places.
    ///
    /// ```swift
    /// // Usage
    /// print(1.formatted(.asNumber)) // "1"
    ///
    /// 1       → "1"
    /// 1.09    → "1.09"
    /// 1.9     → "1.90"
    /// 2.1345  → "2.13"
    /// -2.1355 → "−2.14"
    /// ```
    public static var asNumber: Self {
        .init(type: .number)
    }

    /// Formats as percentage from a `0.0 - 1.0` scale as default.
    ///
    /// ```swift
    /// // scale: .zeroToOne (default), fractionLength: 0...2
    /// 0.019   → "1.9%"
    /// -0.0109 → "−1.09%"
    /// 0.02    → "2%"
    /// ```
    public static var asPercent: Self {
        .asPercent(scale: .zeroToOne)
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
    /// -0.0109 → "−1%"
    /// 0.02    → "2%"
    ///
    /// // scale: .zeroToOne (default), fractionLength: 0...2
    /// 0.019   → "1.9%"
    /// -0.0109 → "−1.09%"
    /// 0.02    → "2%"
    ///
    /// // scale: .zeroToOne (default), fractionLength: 2...2, sign: .both, trimFractionalPartIfZero: false
    /// 0.019   → "+1.90%"
    /// -0.0109 → "−1.09%"
    /// 0.02    → "+2.00%"
    ///
    /// // scale: .zeroToOne (default), minimumBound: 0.01
    /// 0.019   → "+1.90%"
    /// -0.0000109 → "<−0.01%"
    /// 0.0000109  → "<0.01"
    /// ```
    public static func asPercent(scale: Self.Kind.PercentageScale) -> Self {
        .init(type: .percent(scale: scale))
    }
}

// MARK: - Decimal

// TODO: Uncomment when dropping iOS 14 Support
// extension FormatStyle where Self == CustomFloatingPointFormatStyle<Decimal> {
extension CustomFloatingPointFormatStyle where Value == Decimal {
    /// Format the output to ensure 2 places.
    ///
    /// ```swift
    /// // Usage
    /// print(1.formatted(.asNumber)) // "1"
    ///
    /// 1       → "1"
    /// 1.09    → "1.09"
    /// 1.9     → "1.90"
    /// 2.1345  → "2.13"
    /// -2.1355 → "−2.14"
    /// ```
    public static var asNumber: Self {
        .init(type: .number)
    }

    /// Formats as percentage from a `0.0 - 1.0` scale as default.
    ///
    /// ```swift
    /// // scale: .zeroToOne (default), fractionLength: 0...2
    /// 0.019   → "1.9%"
    /// -0.0109 → "−1.09%"
    /// 0.02    → "2%"
    /// ```
    public static var asPercent: Self {
        .asPercent(scale: .zeroToOne)
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
    /// -0.0109 → "−1%"
    /// 0.02    → "2%"
    ///
    /// // scale: .zeroToOne (default), fractionLength: 0...2
    /// 0.019   → "1.9%"
    /// -0.0109 → "−1.09%"
    /// 0.02    → "2%"
    ///
    /// // scale: .zeroToOne (default), fractionLength: 2...2, sign: .both, trimFractionalPartIfZero: false
    /// 0.019   → "+1.90%"
    /// -0.0109 → "−1.09%"
    /// 0.02    → "+2.00%"
    ///
    /// // scale: .zeroToOne (default), minimumBound: 0.01
    /// 0.019   → "+1.90%"
    /// -0.0000109 → "<−0.01%"
    /// 0.0000109  → "<0.01"
    /// ```
    public static func asPercent(scale: Self.Kind.PercentageScale) -> Self {
        .init(type: .percent(scale: scale))
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

private let percentFormatter = NumberFormatter().apply {
    $0.numberStyle = .percent
    $0.roundingMode = .halfUp
    $0.positivePrefix = ""
    $0.negativePrefix = ""
}

private let numberFormatter = NumberFormatter().apply {
    $0.numberStyle = .decimal
    $0.roundingMode = .halfUp
    $0.positivePrefix = ""
    $0.negativePrefix = ""
}
