//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Font {
    /// Creates a font from a UIKit font.
    ///
    /// - Parameter font: A UIFont instance from which to create a font.
    public init(uiFont font: UIFont) {
        self.init(font as CTFont)
    }

    /// Returns default app font that scales relative to the given `style`.
    ///
    /// - Parameters:
    ///   - style: The text style for which to return a font descriptor. See Text
    ///     Styles for valid values.
    ///   - weight: The weight of the font. If set to `nil`, the value is derived
    ///    from the given text style.
    ///   - trait: The trait of the font. The default value is `.normal`.
    /// - Returns: The new scaled font object.
    public static func app(
        _ style: TextStyle,
        weight: Weight? = nil,
        trait: UIFont.Trait = .normal
    ) -> Font {
        // Temporary solution while custom fonts aren't supported on Widgets.
        let isWidgetExtension = AppInfo.isWidgetExtension

        let weight = weight.normalize(style: style)
        let typeface = UIFont.defaultAppTypeface.name(weight: weight, trait: trait)

        if isWidgetExtension || typeface == UIFont.Typeface.systemFontId {
            var font = system(
                style,
                design: trait == .monospaced ? .monospaced : .default
            ).weight(weight)

            if trait == .italic {
                font = font.italic()
            }

            return font
        }

        let pointSize = UIFontDescriptor.preferredFontDescriptor(
            withTextStyle: .init(style),
            compatibleWith: compatibleWithTraitCollection()
        ).pointSize

        if isFixedSize {
            return .custom(typeface, fixedSize: pointSize)
        } else {
            return .custom(typeface, size: pointSize, relativeTo: style)
        }
    }

    /// Returns default app font with given `size`.
    ///
    /// - Parameters:
    ///   - size: The point size of the font.
    ///   - textStyle: Scales the size relative to the text style. The default value
    ///     is `.body`.
    ///   - weight: The weight of the font. If set to `nil`, the value is derived
    ///    from the given text style.
    ///   - trait: The trait of the font. The default value is `.normal`.
    /// - Returns: The new font object.
    public static func app(
        size: CGFloat,
        relativeTo textStyle: TextStyle? = nil,
        weight: Weight? = nil,
        trait: UIFont.Trait = .normal
    ) -> Font {
        // Temporary solution while custom fonts aren't supported on Widgets.
        let isWidgetExtension = AppInfo.isWidgetExtension

        let weight = weight.normalize(style: textStyle)
        let typeface = UIFont.defaultAppTypeface.name(weight: weight, trait: trait)

        if isWidgetExtension || typeface == UIFont.Typeface.systemFontId {
            var font = system(
                size: size,
                weight: weight,
                design: trait == .monospaced ? .monospaced : .default
            )

            if trait == .italic {
                font = font.italic()
            }

            return font
        }

        if isFixedSize {
            return .custom(typeface, fixedSize: size)
        } else if let textStyle = textStyle {
            return custom(typeface, size: size, relativeTo: textStyle)
        } else {
            return custom(typeface, size: size)
        }
    }
}

// MARK: - CustomTextStyle

extension Font {
    public struct CustomTextStyle {
        public let size: CGFloat
        public let textStyle: TextStyle

        public init(size: CGFloat, relativeTo textStyle: TextStyle) {
            self.size = size
            self.textStyle = textStyle
        }
    }

    /// Returns default app font that scales relative to the given `style`.
    ///
    /// - Parameters:
    ///   - style: The text style for which to return a font descriptor. See Custom
    ///     Text Styles for valid values.
    ///   - weight: The weight of the font. If set to `nil`, the value is derived
    ///    from the given text style.
    ///   - trait: The trait of the font. The default value is `.normal`.
    /// - Returns: The new scaled font object.
    public static func app(
        _ style: CustomTextStyle,
        weight: Weight? = nil,
        trait: UIFont.Trait = .normal
    ) -> Font {
        .app(
            size: style.size,
            relativeTo: style.textStyle,
            weight: weight,
            trait: trait
        )
    }
}

// MARK: - Helpers

extension UIFont.Weight {
    init(_ weight: Font.Weight) {
        switch weight {
            case .ultraLight:
                self = .ultraLight
            case .thin:
                self = .thin
            case .light:
                self = .light
            case .regular:
                self = .regular
            case .medium:
                self = .medium
            case .semibold:
                self = .semibold
            case .bold:
                self = .bold
            case .heavy:
                self = .heavy
            case .black:
                self = .black
            default:
                self = .regular
        }
    }
}

extension UIFont.TextStyle {
    fileprivate init(_ textStyle: Font.TextStyle) {
        switch textStyle {
            case .largeTitle:
                self = .largeTitle
            case .title:
                self = .title1
            case .title2:
                self = .title2
            case .title3:
                self = .title3
            case .headline:
                self = .headline
            case .subheadline:
                self = .subheadline
            case .body:
                self = .body
            case .callout:
                self = .callout
            case .footnote:
                self = .footnote
            case .caption:
                self = .caption1
            case .caption2:
                self = .caption2
            default:
                self = .body
        }
    }
}

extension Optional where Wrapped == Font.Weight {
    /// Returns non-optional font weight.
    ///
    /// - If `self` is non-nil then it returns `self`
    /// - Otherwise, if style is non-nil then it returns default preferred weight
    ///   based on Apple's Typography [Guidelines].
    /// - Else, it returns `.regular` weight.
    ///
    /// [Guidelines]: https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/#dynamic-type-sizes
    fileprivate func normalize(style: Font.TextStyle?) -> Wrapped {
        self ?? style?.defaultPreferredWeight() ?? .regular
    }
}

extension Font.TextStyle {
    /// Returns default preferred weight based on Apple's Typography [Guidelines].
    ///
    /// [Guidelines]: https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/#dynamic-type-sizes
    fileprivate func defaultPreferredWeight() -> Font.Weight {
        self == .headline ? .semibold : .regular
    }
}

// MARK: - Dynamic Type Overrides

extension Font {
    /// An optional property to set the preferred content size category.
    ///
    /// - Note: Setting this property disables dynamic type.
    public static var preferredContentSizeCategory: UIContentSizeCategory?

    fileprivate static func compatibleWithTraitCollection() -> UITraitCollection? {
        preferredContentSizeCategory.map(UITraitCollection.init(preferredContentSizeCategory:))
    }

    private static var isFixedSize: Bool {
        preferredContentSizeCategory != nil
    }
}

extension UIFont {
    static func compatibleWithTraitCollection() -> UITraitCollection? {
        Font.compatibleWithTraitCollection()
    }
}
