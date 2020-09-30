//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Font {
    /// Returns default app that scales relative to the given `style`.
    ///
    /// - Parameters:
    ///   - style: The text style for which to return a font descriptor. See Text
    ///     Styles for valid values.
    ///   - weight: The weight of the font. The default value is `.regular`.
    ///   - trait: The trait of the font. The default value is `.normal`.
    /// - Returns: The new scaled font object.
    public static func app(
        _ style: UIFont.TextStyle,
        weight: UIFont.Weight = .regular,
        trait: UIFont.Trait = .normal
    ) -> Font {
        let typeface = UIFont.defaultAppTypeface.name(weight: weight, trait: trait)

        guard typeface != UIFont.Typeface.systemFontId else {
            return system(
                TextStyle(style),
                design: trait == .monospace ? .monospaced : .default
            )
        }

        let pointSize = UIFontDescriptor.preferredFontDescriptor(
            withTextStyle: style
        ).pointSize

        #if swift(>=5.3)
        if #available(iOS 14.0, *) {
            return .custom(
                typeface,
                size: pointSize,
                relativeTo: TextStyle(style)
            )
        }
        #endif
        return .custom(
            typeface,
            size: UIFontMetrics.default.scaledValue(for: pointSize)
        )
    }

    /// Specifies default app font to use, along with the style, weight, and any
    /// design parameters you want applied to the text.
    ///
    /// - Parameters:
    ///   - size: The point size of the font.
    ///   - weight: The weight of the font. The default value is `.regular`.
    ///   - trait: The trait of the font. The default value is `.normal`.
    /// - Returns: The new font object.
    public static func app(
        size: CGFloat,
        weight: UIFont.Weight = .regular,
        trait: UIFont.Trait = .normal
    ) -> Font {
        let typeface = UIFont.defaultAppTypeface.name(weight: weight, trait: trait)

        if typeface == UIFont.Typeface.systemFontId {
            return system(
                size: size,
                weight: Weight(weight),
                design: trait == .monospace ? .monospaced : .default
            )
        }

        return custom(typeface, size: size)
    }
}

// MARK: - Helpers

extension Font.Weight {
    fileprivate init(_ weight: UIFont.Weight) {
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

extension Font.TextStyle {
    fileprivate init(_ textStyle: UIFont.TextStyle) {
        switch textStyle {
            case .largeTitle:
                self = .largeTitle
            case .title1:
                self = .title
            case .title2:
                #if swift(>=5.3)
                if #available(iOS 14.0, *) {
                    self = .title2
                } else {
                    self = .title
                }
                #else
                self = .title
                #endif
            case .title3:
                #if swift(>=5.3)
                if #available(iOS 14.0, *) {
                    self = .title3
                } else {
                    self = .title
                }
                #else
                self = .title
                #endif
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
            case .caption1:
                self = .caption
            case .caption2:
                #if swift(>=5.3)
                if #available(iOS 14.0, *) {
                    self = .caption2
                } else {
                    self = .caption
                }
                #else
                self = .caption
                #endif
            default:
                self = .body
        }
    }
}
