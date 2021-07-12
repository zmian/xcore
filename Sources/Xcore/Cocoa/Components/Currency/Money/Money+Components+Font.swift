//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Money.Components {
    /// A structure representing fonts used to display money components.
    public struct Font: Hashable {
        /// The font to be used in displaying major unit of the amount.
        ///
        /// ```swift
        /// let amount = Decimal(120.30)
        /// // 120 - major unit
        /// // 30 - minor unit
        /// ```
        public let majorUnit: UIFont?

        /// The font to be used in displaying minor unit of the amount.
        ///
        /// ```swift
        /// let amount = Decimal(120.30)
        /// // 120 - major unit
        /// // 30 - minor unit
        /// ```
        public let minorUnit: UIFont?

        /// The offset applied to the minor unit of the amount.
        ///
        /// ```swift
        /// let amount = Decimal(120.30)
        /// // 120 - major unit
        /// // 30 - minor unit
        /// ```
        public let minorUnitOffset: Int?

        public init(majorUnit: UIFont?, minorUnit: UIFont?, minorUnitOffset: Int?) {
            self.majorUnit = majorUnit
            self.minorUnit = minorUnit
            self.minorUnitOffset = minorUnitOffset
        }

        public init(_ style: UIFont.TextStyle) {
            self.init(.app(style))
        }

        public init(_ font: UIFont?) {
            self.majorUnit = font
            self.minorUnit = font
            self.minorUnitOffset = nil
        }
    }
}

// MARK: - Convenience

extension Money.Components.Font {
    /// Superscript based layout derived from the given major unit size.
    ///
    /// - Note: Consider using the pre-existing styles instead of using this method
    ///   directly. If an existing style doesn't fit your need create an alias here
    ///   like `.body` to ensure consistency.
    public static func superscript(_ style: UIFont.TextStyle) -> Self {
        superscript(.app(style))
    }

    /// Superscript based layout derived from the given major unit size.
    ///
    /// - Note: Consider using the pre-existing styles instead of using this method
    ///   directly. If an existing style doesn't fit your need create an alias here
    ///   like `.body` to ensure consistency.
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
            majorUnit: font,
            minorUnit: .app(size: minorUnitSize, weight: minorUnitWeight),
            minorUnitOffset: minorUnitOffset
        )
    }
}

// MARK: - Built-in

extension Money.Components.Font {
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

extension Money.Components.Font {
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

    public static var none: Self {
        .init(nil)
    }
}
