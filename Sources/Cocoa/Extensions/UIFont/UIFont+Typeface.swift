//
// UIFont+Typeface.swift
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIFont {
    /// Creates and returns a font object for the specified typeface.
    public convenience init(
        typeface: Typeface,
        weight: Weight = .regular,
        trait: Trait = .normal,
        size: CGFloat
    ) {
        let name = typeface.name(weight: weight, trait: trait)
        precondition(name != Typeface.systemFontId, "Please use .systemFont() method.")
        self.init(name: name, size: size)!
    }

    public struct Typeface {
        private let block: (Weight, Trait) -> String

        public init(_ block: @escaping (Weight, Trait) -> String) {
            self.block = block
        }

        public func name(weight: Weight, trait: Trait = .normal) -> String {
            return block(weight, trait)
        }
    }
}

// MARK: - Custom

extension UIFont.Typeface {
    static var systemFontId = "XCAppleSystemUIFont"

    public static var system: Self {
        .init { (weight, trait) -> String in
            /// This is special name and it will be interpreted at the callsite.
            systemFontId
        }
    }

    public static var avenir: Self {
        .init { (weight, trait) -> String in
            var name = "AvenirNext"

            switch weight {
                case .ultraLight, .light, .thin:
                    name += "-UltraLight"
                case .medium:
                    name += "-Medium"
                case .semibold:
                    name += "-DemiBold"
                case .bold:
                    name += "-Bold"
                case .heavy, .black:
                    name += "-Heavy"
                default:
                    name += "-Regular"
            }

            switch trait {
                case .normal, .monospace:
                    return name
                case .italic:
                    return "\(name)Italic"
            }
        }
    }

    public static var helveticaNeue: Self {
        .init { (weight, trait) -> String in
            var name = "HelveticaNeue"
            var spacer = ""

            switch weight {
                case .ultraLight:
                    name += "-UltraLight"
                case .light:
                    name += "-Light"
                case .thin:
                    name += "-Thin"
                case .medium, .semibold:
                    name += "-Medium"
                case .bold, .heavy, .black:
                    name += "-Bold"
                default:
                    spacer = "-"
            }

            switch trait {
                case .normal, .monospace:
                    return name
                case .italic:
                    return "\(name)\(spacer)Italic"
            }
        }
    }

    public static func custom(_ namePrefix: String) -> Self {
        .init { (weight, trait) -> String in
            var name = namePrefix

            switch weight {
                case .medium, .semibold:
                    name += "-Medium"
                case .bold:
                    name += "-Bold"
                case .heavy, .black:
                    name += "-Black"
                default:
                    name += "-Book"
            }

            switch trait {
                case .normal, .monospace:
                    return name
                case .italic:
                    return "\(name)Italic"
            }
        }
    }
}
