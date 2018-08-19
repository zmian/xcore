//
// UIFont+Extensions.swift
//
// Copyright © 2015 Zeeshan Mian
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
    public enum Style {
        case normal
        case italic
        case monospace
    }

    public struct Size {
        public static let headline: CGFloat = 16
        public static let subheadline: CGFloat = 14
        public static let body: CGFloat = 16
        public static let label = UIFont.labelFontSize
        public static let button = UIFont.buttonFontSize
        public static let small = UIFont.smallSystemFontSize
        public static let system = UIFont.systemFontSize
    }

    public static func systemFont(_ size: CGFloat, style: Style = .normal, weight: Weight = .regular) -> UIFont {
        switch style {
            case .normal:
                return systemFont(ofSize: size, weight: weight)
            case .italic:
                return italicSystemFont(ofSize: size)
            case .monospace:
                return monospacedDigitSystemFont(ofSize: size, weight: weight)
        }
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

    /// Returns a font matching the given font descriptor.
    ///
    /// - Parameter traits: The new symbolic traits.
    /// - Returns: The new font matching the given font descriptor.
    public func traits(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))!
        return UIFont(descriptor: descriptor, size: 0)
    }

    public var monospacedDigitFont: UIFont {
        let featureSettings = [[UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType, UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector]]
        let attributes = [UIFontDescriptor.AttributeName.featureSettings: featureSettings]
        let oldDescriptor = fontDescriptor
        let newDescriptor = oldDescriptor.addingAttributes(attributes)
        return UIFont(descriptor: newDescriptor, size: 0)
    }
}
