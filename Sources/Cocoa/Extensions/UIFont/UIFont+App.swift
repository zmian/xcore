//
// UIFont+App.swift
//
// Copyright © 2018 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
        let preferredPointSize = UIFontDescriptor.preferredFontDescriptor(
            withTextStyle: style,
            compatibleWith: traitCollection
        ).pointSize

        return UIFont(name: name, size: preferredPointSize)!
    }
}
