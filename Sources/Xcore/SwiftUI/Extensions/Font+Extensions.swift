//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Font {
    /// Returns default app font that scales relative to the given `style`.
    ///
    /// - Parameters:
    ///   - style: The text style for which to return a font descriptor. See Text
    ///     Styles for valid values.
    ///   - weight: The weight of the font. The default value is `.regular`.
    ///   - trait: The trait of the font. The default value is `.normal`.
    /// - Returns: The new scaled font object.
    public static func app(
        _ style: TextStyle,
        weight: Weight = .regular,
        trait: UIFont.Trait = .normal
    ) -> Font {
        let typeface = UIFont.defaultAppTypeface.name(weight: weight, trait: trait)

        if typeface == UIFont.Typeface.systemFontId {
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
            withTextStyle: .init(style)
        ).pointSize

        return .custom(typeface, size: pointSize, relativeTo: style)
    }

    /// Returns default app font with given `size`.
    ///
    /// - Parameters:
    ///   - size: The point size of the font.
    ///   - weight: The weight of the font. The default value is `.regular`.
    ///   - trait: The trait of the font. The default value is `.normal`.
    /// - Returns: The new font object.
    public static func app(
        size: CGFloat,
        weight: Weight = .regular,
        trait: UIFont.Trait = .normal
    ) -> Font {
        let typeface = UIFont.defaultAppTypeface.name(weight: weight, trait: trait)

        if typeface == UIFont.Typeface.systemFontId {
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

        return custom(typeface, size: size)
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
