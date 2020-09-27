//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Font {
    /// Returns default app typeface that scales relative to the given `style`.
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
        let pointSize = UIFontDescriptor.preferredFontDescriptor(
            withTextStyle: style
        ).pointSize

        if #available(iOS 14.0, *) {
            return .custom(
                UIFont.defaultAppTypeface.name(weight: weight, trait: trait),
                size: pointSize,
                relativeTo: TextStyle(style)
            )
        } else {
            return .custom(
                UIFont.defaultAppTypeface.name(weight: weight, trait: trait),
                size: UIFontMetrics.default.scaledValue(for: pointSize)
            )
        }
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
                if #available(iOS 14.0, *) {
                    self = .title2
                } else {
                    self = .title
                }
            case .title3:
                if #available(iOS 14.0, *) {
                    self = .title3
                } else {
                    self = .title
                }
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
                if #available(iOS 14.0, *) {
                    self = .caption2
                } else {
                    self = .caption
                }
            default:
                self = .body
        }
    }
}
