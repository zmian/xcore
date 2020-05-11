//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Money.Components {
    /// A structure that represent formatting attributes for money components.
    public struct Attributes: Hashable {
        /// Font for the major unit of the amount.
        ///
        /// ```swift
        /// let amount = Decimal(120.30)
        /// // 120 - major unit
        /// // 30 - minor unit
        /// ```
        public let majorUnitFont: UIFont

        /// Font for the minor unit of the amount.
        ///
        /// ```swift
        /// let amount = Decimal(120.30)
        /// // 120 - major unit
        /// // 30 - minor unit
        /// ```
        public let minorUnitFont: UIFont

        /// The offset applied to minor unit.
        ///
        /// ```swift
        /// let amount = Decimal(120.30)
        /// // 120 - major unit
        /// // 30 - minor unit
        /// ```
        public let minorUnitOffset: Int

        public init(majorUnitFont: UIFont, minorUnitFont: UIFont, minorUnitOffset: Int) {
            self.majorUnitFont = majorUnitFont
            self.minorUnitFont = minorUnitFont
            self.minorUnitOffset = minorUnitOffset
        }

        public init(_ style: UIFont.TextStyle) {
            self.init(.app(style: style))
        }

        public init(_ font: UIFont) {
            self.majorUnitFont = font
            self.minorUnitFont = font
            self.minorUnitOffset = 0
        }
    }
}

// MARK: - Convenience

extension Money.Components.Attributes {
    /// Superscript based layout derived from the given major unit size.
    ///
    /// - Note: Consider using the pre-existing styles instead of using this method
    /// directly. If an existing style doesn't fit your need create an alias here
    /// like `.body` to ensure consistency.
    public static func superscript(_ style: UIFont.TextStyle) -> Self {
        superscript(UIFont.app(style: style))
    }

    /// Superscript based layout derived from the given major unit size.
    ///
    /// - Note: Consider using the pre-existing styles instead of using this method
    /// directly. If an existing style doesn't fit your need create an alias here
    /// like `.body` to ensure consistency.
    public static func superscript(_ font: UIFont) -> Self {
        let majorUnitSize = font.pointSize

        let φ = AppConstants.φ
        var minorUnitSize = (majorUnitSize * φ).rounded()

        // Add buffer if the given size is small. This helps with readability.
        if majorUnitSize <= 20 {
            minorUnitSize += (minorUnitSize * φ * φ * φ).rounded()
        }

        let minorUnitWeight: UIFont.Weight = minorUnitSize <= 10 ? .medium : .regular
        let minorUnitOffset = Int((majorUnitSize - minorUnitSize).rounded())

        return .init(
            majorUnitFont: font,
            minorUnitFont: .app(size: minorUnitSize, weight: minorUnitWeight),
            minorUnitOffset: minorUnitOffset
        )
    }
}

// MARK: - Built-in

extension Money.Components.Attributes {
    public static var largeTitle: Self {
        largeTitle(superscript: false)
    }

    public static var title1: Self {
        title1(superscript: false)
    }

    public static var title2: Self {
        title2(superscript: false)
    }

    public static var title3: Self {
        title3(superscript: false)
    }

    public static var headline: Self {
        headline(superscript: false)
    }

    public static var subheadline: Self {
        subheadline(superscript: false)
    }

    public static var body: Self {
        body(superscript: false)
    }

    public static var callout: Self {
        callout(superscript: false)
    }

    public static var footnote: Self {
        footnote(superscript: false)
    }

    public static var caption1: Self {
        caption1(superscript: false)
    }

    public static var caption2: Self {
        caption2(superscript: false)
    }
}

extension Money.Components.Attributes {
    public static func largeTitle(superscript: Bool) -> Self {
        superscript ? .superscript(.largeTitle) : .init(.largeTitle)
    }

    public static func title1(superscript: Bool) -> Self {
        superscript ? .superscript(.title1) : .init(.title1)
    }

    public static func title2(superscript: Bool) -> Self {
        superscript ? .superscript(.title2) : .init(.title2)
    }

    public static func title3(superscript: Bool) -> Self {
        superscript ? .superscript(.title3) : .init(.title3)
    }

    public static func headline(superscript: Bool) -> Self {
        superscript ? .superscript(.headline) : .init(.headline)
    }

    public static func subheadline(superscript: Bool) -> Self {
        superscript ? .superscript(.subheadline) : .init(.subheadline)
    }

    public static func body(superscript: Bool) -> Self {
        superscript ? .superscript(.body) : .init(.body)
    }

    public static func callout(superscript: Bool) -> Self {
        superscript ? .superscript(.callout) : .init(.callout)
    }

    public static func footnote(superscript: Bool) -> Self {
        superscript ? .superscript(.footnote) : .init(.footnote)
    }

    public static func caption1(superscript: Bool) -> Self {
        superscript ? .superscript(.caption1) : .init(.caption1)
    }

    public static func caption2(superscript: Bool) -> Self {
        superscript ? .superscript(.caption2) : .init(.caption2)
    }
}
