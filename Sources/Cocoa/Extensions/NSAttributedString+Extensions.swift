//
// NSAttributedString+Extensions.swift
//
// Copyright © 2017 Zeeshan Mian
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

// MARK: NSAttributedString Extension

extension NSAttributedString {
    @objc public func setLineSpacing(_ spacing: CGFloat) -> NSMutableAttributedString {
         return NSMutableAttributedString(attributedString: self).setLineSpacing(spacing)
    }

    public var attributesDescription: String {
        let range = NSRange(location: 0, length: length)

        var result = ""
        enumerateAttributes(in: range) { attributes, range, _ in
            result += "range: \(NSStringFromRange(range)) attributes: \(attributes)\n\n"
        }

        return result
    }
}

// MARK: NSMutableAttributedString Extension

extension NSMutableAttributedString {
    public override func setLineSpacing(_ spacing: CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: string.count))
        return self
    }

    open func replaceAttribute(_ name: NSAttributedStringKey, value: Any, range: NSRange) {
        removeAttribute(name, range: range)
        addAttribute(name, value: value, range: range)
    }
}

extension NSMutableAttributedString {
    open func underline(_ text: String) -> NSMutableAttributedString {
        addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range(of: text))
        return self
    }

    open func color(_ color: UIColor, for text: String? = nil) -> NSMutableAttributedString {
        addAttribute(.foregroundColor, value: color, range: range(of: text))
        return self
    }

    open func backgroundColor(_ color: UIColor, for text: String? = nil) -> NSMutableAttributedString {
        addAttribute(.foregroundColor, value: color, range: range(of: text))
        return self
    }

    open func font(_ font: UIFont, for text: String? = nil) -> NSMutableAttributedString {
        addAttribute(.font, value: font, range: range(of: text))
        return self
    }

    open func textAlignment(_ textAlignment: NSTextAlignment, for text: String? = nil) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        addAttribute(.paragraphStyle, value: paragraphStyle, range: range(of: text))
        return self
    }

    open func link(url: URL?, text: String) -> NSMutableAttributedString {
        guard let url = url else {
            return self
        }

        addAttribute(.link, value: url, range: range(of: text))
        return self
    }

    private func range(of text: String?) -> NSRange {
        let range: NSRange

        if let text = text {
            range = (string as NSString).range(of: text)
        } else {
            range = NSRange(location: 0, length: string.count)
        }

        return range
    }
}

extension NSAttributedString {
    /// Returns an `NSAttributedString` object initialized with a given `string` and `attributes`.
    ///
    /// Returns an `NSAttributedString` object initialized with the characters of `aString`
    /// and the attributes of `attributes`. The returned object might be different from the original receiver.
    ///
    /// - Parameters:
    ///   - string: The string for the new attributed string.
    ///   - image: The image for the new attributed string.
    ///   - baselineOffset: The value indicating the `image` offset from the baseline. The default value is `0`.
    ///   - attributes: The attributes for the new attributed string. For a list of attributes that you can include in this
    ///                 dictionary, see `Character Attributes`.
    public convenience init(string: String? = nil, image: UIImage, baselineOffset: CGFloat = 0, attributes: [NSAttributedStringKey: Any]? = nil) {
        let attachment = NSAttributedString.attachmentAttributes(for: image, baselineOffset: baselineOffset)

        guard let string = string else {
            self.init(string: attachment.string, attributes: attachment.attributes)
            return
        }

        let attachmentAttributedString = NSAttributedString(string: attachment.string, attributes: attachment.attributes)
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        attributedString.append(attachmentAttributedString)
        self.init(attributedString: attributedString)
    }

    private static func attachmentAttributes(for image: UIImage, baselineOffset: CGFloat) -> (string: String, attributes: [NSAttributedStringKey: Any]) {
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineHeightMultiple = 0.9

        let attachment = NSTextAttachment(data: nil, ofType: nil)
        attachment.image = image

        let attachmentCharacterString = String(Character(UnicodeScalar(NSAttachmentCharacter)!))

        return (string: attachmentCharacterString, attributes: [
            .attachment: attachment,
            .baselineOffset: baselineOffset,
            .paragraphStyle: paragraphStyle
        ])
    }
}

extension NSAttributedString {
    /// Returns an `NSAttributedString` object initialized with a given attributes.
    ///
    /// - Parameters:
    ///   - string: The string for the new attributed string.
    ///   - spacer: The spacer between the caret `direction` and the `string`. The default value is two spaces `  `.
    ///   - font: The font for the `string`.
    ///   - color: The color for the caret and the `string`.
    ///   - direction: The caret direction to use. The default value is `.forward`.
    ///   - state: The state for which to generate the new attributed string. The default value is `.normal`.
    public convenience init(string: String, spacer: String = "  ", font: UIFont, color: UIColor, direction: CaretDirection = .forward, for state: UIControlState = .normal) {
        let imageTintColor = color
        var textColor = imageTintColor
        let alpha: CGFloat = textColor.alpha * 0.5

        if state == .highlighted {
            textColor = textColor.alpha(alpha)
        }

        let attributes: [NSAttributedStringKey: Any] = [
            .font: font,
            .foregroundColor: textColor
        ]

        guard let assetIdentifier = direction.assetIdentifier else {
            self.init(string: string, attributes: attributes)
            return
        }

        var image = UIImage(assetIdentifier: assetIdentifier).tintColor(imageTintColor)

        if state == .highlighted, let highlightedImage = image.alpha(alpha) {
            image = highlightedImage
        }

        self.init(string: string + spacer, image: image, baselineOffset: direction.imageBaselineOffset, attributes: attributes)
    }
}

extension NSAttributedString {
    public enum CaretDirection {
        case none
        case down
        case forward

        var assetIdentifier: UIImage.AssetIdentifier? {
            switch self {
                case .none:
                    return nil
                case .down:
                    return .caretDirectionDown
                case .forward:
                    return .caretDirectionForward
            }
        }

        var imageBaselineOffset: CGFloat {
            switch self {
                case .none:
                    return 0
                case .down:
                    return 2
                case .forward:
                    return 0
            }
        }
    }
}
