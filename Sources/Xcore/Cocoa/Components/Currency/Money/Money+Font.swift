//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Money {
    /// A structure representing fonts used to format money components.
    public struct Font: Hashable {
        /// The font for major unit of the amount.
        ///
        /// ```swift
        /// let amount = Decimal(120.30)
        /// // 120 - major unit
        /// // 30 - minor unit
        /// ```
        public var majorUnit: UIFont

        /// The font for minor unit of the amount.
        ///
        /// ```swift
        /// let amount = Decimal(120.30)
        /// // 120 - major unit
        /// // 30 - minor unit
        /// ```
        public var minorUnit: Superscript?

        /// The font for currency symbol of the amount.
        ///
        /// ```swift
        /// let amount = Decimal(120.30)
        /// // $ - currency symbol
        /// // 120 - major unit
        /// // 30 - minor unit
        /// ```
        public var currencySymbol: Superscript?

        /// Creates an instance of font.
        ///
        /// - Parameters:
        ///   - majorUnit: The font for major unit of the amount.
        ///   - minorUnit: The font for minor unit of the amount.
        ///   - currencySymbol: The font for currency symbol of the amount.
        public init(
            majorUnit: UIFont,
            minorUnit: Superscript?,
            currencySymbol: Superscript? = nil
        ) {
            self.majorUnit = majorUnit
            self.minorUnit = minorUnit
            self.currencySymbol = nil
        }

        /// Creates an instance of font.
        ///
        /// - Parameter font: The font for the amount.
        public init(_ font: UIFont) {
            self.majorUnit = font
            self.minorUnit = nil
            self.currencySymbol = nil
        }
    }
}

// MARK: - Built-in

extension Money.Font {
    /// Creates an instance of font.
    ///
    /// - Parameter style: The font text style for the amount.
    public static func app(_ style: Font.TextStyle) -> Self {
        self.init(.app(.init(style)))
    }

    /// Creates an instance of font.
    ///
    /// - Parameter style: The font text style for the amount.
    public static func app(_ style: Font.CustomTextStyle) -> Self {
        self.init(.app(size: style.size))
    }

    /// Creates an instance of font with minor unit superscripted relative to the
    /// given font.
    ///
    /// - Parameter font: The font for the amount.
    public static func superscript(_ font: UIFont) -> Self {
        .init(majorUnit: font, minorUnit: .relative(to: font))
    }

    /// Creates an instance of font with minor unit superscripted relative to the
    /// given font text style.
    ///
    /// - Parameter style: The font text style for the amount.
    public static func superscript(_ style: Font.TextStyle) -> Self {
        superscript(.app(.init(style)))
    }

    /// Creates an instance of font with minor unit superscripted relative to the
    /// given font text style.
    ///
    /// - Parameter style: The font text style for the amount.
    public static func superscript(_ style: Font.CustomTextStyle) -> Self {
        superscript(.app(size: style.size))
    }
}

// MARK: - Chaining Syntactic Syntax

extension Money.Font {
    /// Superscripts currency symbol relative to the major unit.
    public func currencySymbolSuperscript() -> Self {
        currencySymbol(.relative(to: majorUnit))
    }

    /// The font for currency symbol of the amount.
    public func currencySymbol(font: UIFont, baselineOffset: CGFloat) -> Self {
        currencySymbol(.init(font: font, baselineOffset: baselineOffset))
    }

    /// The font for currency symbol of the amount.
    public func currencySymbol(_ superscript: Superscript?) -> Self {
        var copy = self
        copy.currencySymbol = superscript
        return copy
    }
}

// MARK: - Superscript

extension Money.Font {
    /// A structure representing font and baseline offset.
    public struct Superscript: Hashable {
        public let font: UIFont
        public let baselineOffset: CGFloat

        public init(font: UIFont, baselineOffset: CGFloat) {
            self.font = font
            self.baselineOffset = baselineOffset
        }

        /// Returns superscript based layout derived from the given font text style.
        public static func relative(to style: Font.TextStyle) -> Self {
            relative(to: .app(.init(style)))
        }

        /// Returns superscript based layout derived from the given font point size.
        public static func relative(to font: UIFont) -> Self {
            let majorUnitSize = font.pointSize

            let φ = AppConstants.φ
            var minorUnitSize = (majorUnitSize * φ).rounded()

            // Add buffer if the given size is small. This helps with readability.
            if majorUnitSize <= 20 {
                minorUnitSize += (minorUnitSize * φ * φ * φ).rounded()
            }

            let minorUnitWeight: UIFont.Weight = minorUnitSize <= 10 ? .medium : .regular
            let minorUnitOffset = (majorUnitSize - minorUnitSize).rounded()

            return .init(
                font: .app(size: minorUnitSize, weight: minorUnitWeight),
                baselineOffset: minorUnitOffset
            )
        }
    }
}
