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
        case Title1, Title2, Title3, Headline, Subheadline, Body, Callout, Footnote, Caption1, Caption2

        public typealias RawValue = String

        public var rawValue: RawValue {
            switch self {
                case .Title1:      if #available(iOS 9.0, *) { return UIFontTextStyleTitle1 } else { return UIFontTextStyleHeadline }
                case .Title2:      if #available(iOS 9.0, *) { return UIFontTextStyleTitle2 } else { return UIFontTextStyleHeadline }
                case .Title3:      if #available(iOS 9.0, *) { return UIFontTextStyleTitle3 } else { return UIFontTextStyleHeadline }
                case .Headline:    return UIFontTextStyleHeadline
                case .Subheadline: return UIFontTextStyleSubheadline
                case .Body:        return UIFontTextStyleBody
                case .Callout:     if #available(iOS 9.0, *) { return UIFontTextStyleCallout } else { return UIFontTextStyleSubheadline }
                case .Footnote:    return UIFontTextStyleFootnote
                case .Caption1:    return UIFontTextStyleCaption1
                case .Caption2:    return UIFontTextStyleCaption2
            }
        }

        public init?(rawValue: RawValue) {
            if #available(iOS 9.0, *) {
                switch rawValue {
                    case UIFontTextStyleTitle1:      self = .Title1
                    case UIFontTextStyleTitle2:      self = .Title2
                    case UIFontTextStyleTitle3:      self = .Title3
                    case UIFontTextStyleHeadline:    self = .Headline
                    case UIFontTextStyleSubheadline: self = .Subheadline
                    case UIFontTextStyleBody:        self = .Body
                    case UIFontTextStyleCallout:     self = .Callout
                    case UIFontTextStyleFootnote:    self = .Footnote
                    case UIFontTextStyleCaption1:    self = .Caption1
                    case UIFontTextStyleCaption2:    self = .Caption2
                    default: fatalError("Unsupported `TextStyle`")
                }
            } else {
                switch rawValue {
                    case UIFontTextStyleHeadline:    self = .Headline
                    case UIFontTextStyleSubheadline: self = .Subheadline
                    case UIFontTextStyleBody:        self = .Body
                    case UIFontTextStyleFootnote:    self = .Footnote
                    case UIFontTextStyleCaption1:    self = .Caption1
                    case UIFontTextStyleCaption2:    self = .Caption2
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
        case Normal, Italic, Monospace
    }

    enum Weight {
        case UltraLight, Thin, Light, Regular, Medium, Semibold, Bold, Heavy, Black
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
    static func systemFont(size: CGFloat, style: Style = .Normal, weight: Weight = .Regular) -> UIFont {
        let fontWeight: CGFloat

        if #available(iOS 8.2, *) {
            switch weight {
                case .UltraLight:
                    fontWeight = UIFontWeightUltraLight
                case .Thin:
                    fontWeight = UIFontWeightThin
                case .Light:
                    fontWeight = UIFontWeightLight
                case .Regular:
                    fontWeight = UIFontWeightRegular
                case .Medium:
                    fontWeight = UIFontWeightMedium
                case .Semibold:
                    fontWeight = UIFontWeightSemibold
                case .Bold:
                    fontWeight = UIFontWeightBold
                case .Heavy:
                    fontWeight = UIFontWeightHeavy
                case .Black:
                    fontWeight = UIFontWeightBlack
            }
        } else {
            fontWeight = 0
        }

        switch style {
            case .Normal:
                return _systemFontOfSize(size, weight: fontWeight, weightType: weight)
            case .Italic:
                return italicSystemFontOfSize(size)
            case .Monospace:
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
                case .Bold, .Heavy, .Black:
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
