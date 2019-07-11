//
// UIFont+Typeface.swift
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

    public static var system: UIFont.Typeface {
        return .init { (weight, trait) -> String in
            /// This is special name and it will be interpreted at the callsite.
            return systemFontId
        }
    }

    public static var avenir: UIFont.Typeface {
        return .init { (weight, trait) -> String in
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

    public static var helveticaNeue: UIFont.Typeface {
        return .init { (weight, trait) -> String in
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
                    break
            }

            switch trait {
                case .normal, .monospace:
                    return name
                case .italic:
                    return "\(name)\(spacer)Italic"
            }
        }
    }

    public static func custom(_ namePrefix: String) -> UIFont.Typeface {
        return .init { (weight, trait) -> String in
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
