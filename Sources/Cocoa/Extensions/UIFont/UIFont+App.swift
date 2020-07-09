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
    ///   - style: The text style for which to return a font descriptor. See Text
    ///            Styles for valid values.
    ///   - weight: The weight of the font. The default value is `.regular`.
    ///   - trait: The trait of the font. The default value is `.normal`.
    ///   - traitCollection: The trait collection containing the content size
    ///                      category information. The default value is `nil`.
    /// - Returns: The new scaled font object.
    public static func app(
        style: UIFont.TextStyle,
        weight: Weight = .regular,
        trait: Trait = .normal,
        compatibleWith traitCollection: UITraitCollection? = nil
    ) -> UIFont {
        let typeface = defaultAppTypeface.name(weight: weight, trait: trait)

        if typeface == Typeface.systemFontId {
            // TODO: Handle monospace and italic traits.
            return preferredFont(forTextStyle: style, compatibleWith: traitCollection)
        }

        return scaled(
            name: typeface,
            style: style,
            compatibleWith: traitCollection
        ).apply(trait)
    }

    /// The default app typeface with given size and weight.
    ///
    /// - Parameters:
    ///   - size: The point size of the font.
    ///   - weight: The weight of the font. The default value is `.regular`.
    ///   - trait: The trait of the font. The default value is `.normal`.
    /// - Returns: The new font object.
    public static func app(size: CGFloat, weight: Weight = .regular, trait: Trait = .normal) -> UIFont {
        let typeface = defaultAppTypeface.name(weight: weight, trait: trait)

        if typeface == Typeface.systemFontId {
            return .systemFont(size: size, weight: weight, trait: trait)
        }

        return UIFont(name: typeface, size: size)!.apply(trait)
    }
}

extension UIFont {
    /// Scaled version of the given font name.
    ///
    /// - Parameters:
    ///   - style: The text style for which to return a font descriptor. See Text
    ///                Styles for valid values.
    ///   - traitCollection: The trait collection containing the content size
    ///                      category information. The default value is `nil`.
    /// - Returns: The new scaled font object.
    static func scaled(
        name: String,
        style: UIFont.TextStyle,
        compatibleWith traitCollection: UITraitCollection? = nil
    ) -> UIFont {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(
            withTextStyle: style,
            compatibleWith: traitCollection
        ).addingAttributes([.name : name])

        return UIFont(descriptor: fontDescriptor, size: fontDescriptor.pointSize)
    }
}
