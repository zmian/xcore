//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIFont {
    public static var defaultAppTypeface: UIFont.Typeface = .system

    /// Scaled version of default app typeface.
    ///
    /// - Parameters:
    ///   - style: The text style for which to return a font descriptor. See text
    ///     styles for valid values.
    ///   - weight: The weight of the font. The default value is `.regular`.
    ///   - trait: The trait of the font. The default value is `.normal`.
    ///   - traitCollection: The trait collection containing the content size
    ///     category information. The default value is `nil`.
    /// - Returns: The new scaled font object.
    public static func app(
        _ style: TextStyle,
        weight: Weight = .regular,
        trait: Trait = .normal,
        compatibleWith traitCollection: UITraitCollection? = nil
    ) -> UIFont {
        let typeface = defaultAppTypeface.name(weight: weight, trait: trait)

        if typeface == Typeface.systemFontId {
            // TODO: Handle monospaced and italic traits.
            return preferredFont(forTextStyle: style, compatibleWith: traitCollection)
        }

        let preferredPointSize = UIFontDescriptor.preferredFontDescriptor(
            withTextStyle: style,
            compatibleWith: traitCollection
        ).pointSize

        return UIFont(name: typeface, size: preferredPointSize)!
            .apply { $0._textStyle = style }
    }

    /// The default app typeface with given size and weight.
    ///
    /// - Parameters:
    ///   - size: The point size of the font.
    ///   - weight: The weight of the font. The default value is `.regular`.
    ///   - trait: The trait of the font. The default value is `.normal`.
    /// - Returns: The new font object.
    public static func app(
        size: CGFloat,
        weight: Weight = .regular,
        trait: Trait = .normal
    ) -> UIFont {
        let typeface = defaultAppTypeface.name(weight: weight, trait: trait)

        if typeface == Typeface.systemFontId {
            return .system(size: size, weight: weight, trait: trait)
        }

        return UIFont(name: typeface, size: size)!
    }
}
