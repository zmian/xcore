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
}

extension NSAttributedString {
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

    fileprivate func range(of text: String?) -> NSRange {
        let range: NSRange

        if let text = text {
            range = (string as NSString).range(of: text)
        } else {
            range = NSRange(location: 0, length: string.count)
        }

        return range
    }
}

extension NSMutableAttributedString {
    open func replaceAttribute(_ name: NSAttributedStringKey, value: Any, range: NSRange) {
        removeAttribute(name, range: range)
        addAttribute(name, value: value, range: range)
    }
}
