//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIFont {
    public enum Trait {
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
                return systemFont(ofSize: size, weight: weight)
            case .italic:
                return italicSystemFont(ofSize: size)
            case .monospaced:
                return monospacedSystemFont(ofSize: size, weight: weight)
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

        let descriptor = UIFontDescriptor(fontAttributes: attributes)
        return UIFont(descriptor: descriptor, size: 0)
    }

    func bold() -> UIFont? {
        withTraits(.traitBold)
    }

    func italic() -> UIFont? {
        withTraits(.traitItalic)
    }

    func monospaced() -> UIFont? {
        withTraits(.traitMonoSpace)
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

extension UIFont {
    private enum AssociatedKey {
        static var textStyle = "textStyle"
    }

    var _textStyle: UIFont.TextStyle? {
        get { associatedObject(&AssociatedKey.textStyle) }
        set { setAssociatedObject(&AssociatedKey.textStyle, value: newValue) }
    }

    public var textStyle: UIFont.TextStyle? {
        _textStyle ?? fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle
    }
}

extension UIFont.TextStyle: CaseIterable {
    public static var allCases: [UIFont.TextStyle] = {
        [
            .largeTitle,
            .title1,
            .title2,
            .title3,
            .headline,
            .subheadline,
            .body,
            .callout,
            .footnote,
            .caption1,
            .caption2
        ]
    }()

    private static var headerStyles: [UIFont.TextStyle] = {
        [
            .largeTitle,
            .title1,
            .title2,
            .title3,
            .headline
        ]
    }()

    public var isTitle: Bool {
        Self.headerStyles.contains(self)
    }
}
