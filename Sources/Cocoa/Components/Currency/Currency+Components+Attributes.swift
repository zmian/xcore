//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Currency.Components {
    /// A structure that represent formatting attributes for currency components.
    public struct Attributes: Equatable {
        public let dollarsFont: UIFont
        public let centsFont: UIFont
        public let centsOffset: Int

        public init(dollarsFont: UIFont, centsFont: UIFont, centsOffset: Int) {
            self.dollarsFont = dollarsFont
            self.centsFont = centsFont
            self.centsOffset = centsOffset
        }

        public init(_ style: UIFont.TextStyle) {
            self.init(.app(style: style))
        }

        public init(_ font: UIFont) {
            self.dollarsFont = font
            self.centsFont = font
            self.centsOffset = 0
        }
    }
}

// MARK: - Convenience

extension Currency.Components.Attributes {
    /// Superscript based layout derived from the given dollars size.
    ///
    /// - Note: Consider using the pre-existing styles instead of using this method
    /// directly. If an existing style doesn't fit your need create an alias here
    /// like `.body` to ensure consistency.
    public static func superscript(_ style: UIFont.TextStyle) -> Self {
        superscript(UIFont.app(style: style))
    }

    /// Superscript based layout derived from the given dollars size.
    ///
    /// - Note: Consider using the pre-existing styles instead of using this method
    /// directly. If an existing style doesn't fit your need create an alias here
    /// like `.body` to ensure consistency.
    public static func superscript(_ font: UIFont) -> Self {
        let dollarsSize = font.pointSize

        let φ = AppConstants.φ
        var centsSize = (dollarsSize * φ).rounded()

        // Add buffer if the given size is small. This helps with readability.
        if dollarsSize <= 20 {
            centsSize += (centsSize * φ * φ * φ).rounded()
        }

        let centsWeight: UIFont.Weight = centsSize <= 10 ? .medium : .regular
        let centsOffset = Int((dollarsSize - centsSize).rounded())

        return .init(
            dollarsFont: font,
            centsFont: .app(size: centsSize, weight: centsWeight),
            centsOffset: centsOffset
        )
    }
}

// MARK: - Built-in

extension Currency.Components.Attributes {
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

extension Currency.Components.Attributes {
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
