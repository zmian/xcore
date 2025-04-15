//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit

extension UIFont {
    public enum Trait: Sendable {
        case normal
        case italic
        case monospaced
    }

    static func system(
        size: CGFloat,
        weight: Weight = .regular,
        trait: Trait = .normal
    ) -> UIFont {
        switch trait {
            case .normal:
                systemFont(ofSize: size, weight: weight)
            case .italic:
                italicSystemFont(ofSize: size)
            case .monospaced:
                monospacedSystemFont(ofSize: size, weight: weight)
        }
    }
}

extension UIFont {
    /// Returns a font matching the given symbolic traits.
    ///
    /// - Parameter traits: The new symbolic traits.
    /// - Returns: The new font matching the given symbolic traits.
    public func withTraits(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont? {
        fontDescriptor.withSymbolicTraits(.init(traits)).map {
            UIFont(descriptor: $0, size: 0)
        }
    }

    /// Returns a font object that is the same as the font, but has the specified
    /// weight.
    ///
    /// - Parameter weight: The desired weight of the new font object.
    /// - Returns: A font object of the specified weight.
    public func withWeight(_ weight: Weight) -> UIFont {
        var attributes = fontDescriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        traits[.weight] = weight

        attributes[.name] = nil // Needed for custom fonts as the name can be tied to specific weight.
        attributes[.family] = familyName
        attributes[.traits] = traits

        return UIFont(
            descriptor: UIFontDescriptor(fontAttributes: attributes),
            size: 0
        )
    }

    /// The text style associated with the font.
    public var textStyle: UIFont.TextStyle? {
        fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle
    }
}

extension UIFont {
    public static func printAvailableFontNames() {
        for family in familyNames {
            let count = fontNames(forFamilyName: family).count
            print("▿ \(family) (\(count) \(count == 1 ? "font" : "fonts"))")

            for name in fontNames(forFamilyName: family) {
                print("  - \(name)")
            }
        }
    }
}
#endif
