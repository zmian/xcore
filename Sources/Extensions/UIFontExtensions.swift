//
// UIFontExtensions.swift
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

public extension UIFont {
    public enum TextStyle: RawRepresentable {
        case title1, title2, title3, headline, subheadline, body, callout, footnote, caption1, caption2

        public var rawValue: String {
            switch self {
                case .title1:      if #available(iOS 9.0, *) { return UIFontTextStyleTitle1 } else { return UIFontTextStyleHeadline }
                case .title2:      if #available(iOS 9.0, *) { return UIFontTextStyleTitle2 } else { return UIFontTextStyleHeadline }
                case .title3:      if #available(iOS 9.0, *) { return UIFontTextStyleTitle3 } else { return UIFontTextStyleHeadline }
                case .headline:    return UIFontTextStyleHeadline
                case .subheadline: return UIFontTextStyleSubheadline
                case .body:        return UIFontTextStyleBody
                case .callout:     if #available(iOS 9.0, *) { return UIFontTextStyleCallout } else { return UIFontTextStyleSubheadline }
                case .footnote:    return UIFontTextStyleFootnote
                case .caption1:    return UIFontTextStyleCaption1
                case .caption2:    return UIFontTextStyleCaption2
            }
        }

        public init?(rawValue: String) {
            if #available(iOS 9.0, *) {
                switch rawValue {
                    case UIFontTextStyleTitle1:      self = .title1
                    case UIFontTextStyleTitle2:      self = .title2
                    case UIFontTextStyleTitle3:      self = .title3
                    case UIFontTextStyleHeadline:    self = .headline
                    case UIFontTextStyleSubheadline: self = .subheadline
                    case UIFontTextStyleBody:        self = .body
                    case UIFontTextStyleCallout:     self = .callout
                    case UIFontTextStyleFootnote:    self = .footnote
                    case UIFontTextStyleCaption1:    self = .caption1
                    case UIFontTextStyleCaption2:    self = .caption2
                    default: fatalError("Unsupported `TextStyle`")
                }
            } else {
                switch rawValue {
                    case UIFontTextStyleHeadline:    self = .headline
                    case UIFontTextStyleSubheadline: self = .subheadline
                    case UIFontTextStyleBody:        self = .body
                    case UIFontTextStyleFootnote:    self = .footnote
                    case UIFontTextStyleCaption1:    self = .caption1
                    case UIFontTextStyleCaption2:    self = .caption2
                    default: fatalError("Unsupported `TextStyle`")
                }
            }
        }
    }

    @warn_unused_result
    public static func systemFont(style: TextStyle) -> UIFont {
        return preferredFontForTextStyle(style.rawValue)
    }
}

public extension UIFont {
    enum Style {
        case normal, italic, monospace
    }

    enum Weight {
        case ultralight, thin, light, regular, medium, semibold, bold, heavy, black
    }

    public struct Size {
        public static let Headline: CGFloat    = 16
        public static let Subheadline: CGFloat = 14
        public static let Body: CGFloat        = 16
        public static let Label                = UIFont.labelFontSize()
        public static let Button               = UIFont.buttonFontSize()
        public static let Small                = UIFont.smallSystemFontSize()
        public static let System               = UIFont.systemFontSize()
    }

    @warn_unused_result
    static func systemFont(size: CGFloat, style: Style = .normal, weight: Weight = .regular) -> UIFont {
        let fontWeight: CGFloat

        if #available(iOS 8.2, *) {
            switch weight {
                case .ultralight:
                    fontWeight = UIFontWeightUltraLight
                case .thin:
                    fontWeight = UIFontWeightThin
                case .light:
                    fontWeight = UIFontWeightLight
                case .regular:
                    fontWeight = UIFontWeightRegular
                case .medium:
                    fontWeight = UIFontWeightMedium
                case .semibold:
                    fontWeight = UIFontWeightSemibold
                case .bold:
                    fontWeight = UIFontWeightBold
                case .heavy:
                    fontWeight = UIFontWeightHeavy
                case .black:
                    fontWeight = UIFontWeightBlack
            }
        } else {
            fontWeight = 0
        }

        switch style {
            case .normal:
                return _systemFontOfSize(size, weight: fontWeight, weightType: weight)
            case .italic:
                return italicSystemFontOfSize(size)
            case .monospace:
                if #available(iOS 9.0, *) {
                    return monospacedDigitSystemFontOfSize(size, weight: fontWeight)
                } else {
                    return _systemFontOfSize(size, weight: fontWeight, weightType: weight).monospacedDigitFont
                }
        }
    }

    private static func _systemFontOfSize(size: CGFloat, weight: CGFloat, weightType: Weight) -> UIFont {
        if #available(iOS 8.2, *) {
            return systemFontOfSize(size, weight: weight)
        } else {
            switch weightType {
                case .bold, .heavy, .black:
                    return boldSystemFontOfSize(size)
                default:
                    return systemFontOfSize(size)
            }
        }
    }
}

public extension UIFont {
    public static func printAvailableFontNames() {
        for family in familyNames() {
            let count = fontNamesForFamilyName(family).count
            print("▿ \(family) (\(count) \(count == 1 ? "font" : "fonts"))")
            for name in fontNamesForFamilyName(family) {
                print("  - \(name)")
            }
        }
    }

    /// Returns a font matching the given font descriptor.
    ///
    /// - parameter traits: The new symbolic traits.
    ///
    /// - returns: The new font matching the given font descriptor.
    @warn_unused_result
    public func traits(traits: UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor, size: 0)
    }

    public var monospacedDigitFont: UIFont {
        let featureSettings = [[UIFontFeatureTypeIdentifierKey: kNumberSpacingType, UIFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector]]
        let attributes      = [UIFontDescriptorFeatureSettingsAttribute: featureSettings]
        let oldDescriptor   = fontDescriptor()
        let newDescriptor   = oldDescriptor.fontDescriptorByAddingAttributes(attributes)
        return UIFont(descriptor: newDescriptor, size: 0)
    }
}
