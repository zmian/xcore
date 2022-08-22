//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - NSAttributedString

extension NSAttributedString {
    /// Returns `self` as `NSMutableAttributedString`.
    public func mutable() -> NSMutableAttributedString {
        NSMutableAttributedString(attributedString: self)
    }

    /// A textual representation of attributes.
    public var attributesDescription: String {
        let text = string as NSString
        let range = NSRange(location: 0, length: length)
        var result: [String] = []

        enumerateAttributes(in: range) { attributes, range, _ in
            result.append("\nstring: \(text.substring(with: range))")
            result.append("range: \(NSStringFromRange(range))")
            attributes.forEach {
                var value = $0.value

                if $0.key == .foregroundColor, let color = value as? UIColor {
                    value = color.hex
                }

                result.append("\($0.key.rawValue): \(value)")
            }
        }

        return result.joined(separator: "\n")
    }
}

// MARK: - NSMutableAttributedString

extension NSMutableAttributedString {
    public func replaceAttribute(_ name: Key, value: Any, range: NSRange) {
        removeAttribute(name, range: range)
        addAttribute(name, value: value, range: range)
    }
}

// MARK: - NSMutableAttributedString: Chaining Attributes

extension NSMutableAttributedString {
    public func underline(_ text: String? = nil, style: NSUnderlineStyle = .single) -> Self {
        addAttribute(.underlineStyle, value: style.rawValue, range: range(of: text))
        return self
    }

    @discardableResult
    public func foregroundColor(_ color: UIColor, for text: String? = nil) -> Self {
        addAttribute(.foregroundColor, value: color, range: range(of: text))
        return self
    }

    public func backgroundColor(_ color: UIColor, for text: String? = nil) -> Self {
        addAttribute(.backgroundColor, value: color, range: range(of: text))
        return self
    }

    public func font(_ font: UIFont, for text: String? = nil) -> Self {
        addAttribute(.font, value: font, range: range(of: text))
        return self
    }

    public func link(url: URL?, text: String) -> Self {
        guard let url = url else {
            return self
        }

        addAttribute(.link, value: url, range: range(of: text))
        return self
    }

    public func lineSpacing(_ spacing: CGFloat) -> Self {
        paragraphStyle(\.lineSpacing, to: spacing, range: range(of: nil))
        return self
    }

    public func textAlignment(_ textAlignment: NSTextAlignment, for text: String? = nil) -> Self {
        paragraphStyle(\.alignment, to: textAlignment, range: range(of: text))
        return self
    }

    private func paragraphStyle<T>(
        _ keyPath: WritableKeyPath<NSMutableParagraphStyle, T>,
        to value: T,
        range: NSRange
    ) {
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle[keyPath: keyPath] = value
        addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
    }

    /// Returns the range of a substring in the attributed string, if it exists;
    /// otherwise, returns the range of the entire attributed string.
    private func range(of stringToFind: String?) -> NSRange {
        let range: NSRange

        if let stringToFind = stringToFind {
            range = (string as NSString).range(of: stringToFind)
        } else {
            range = NSRange(location: 0, length: string.count)
        }

        return range
    }

    /// Returns the range of a substring in the attributed string, if it exists.
    func range(of stringToFind: String) -> NSRange? {
        let range = (string as NSString).range(of: stringToFind)
        return range.location == NSNotFound ? nil : range
    }
}

// MARK: - Bullets

extension NSAttributedString {
    /// An enumeration representing the bullet style.
    public enum BulletStyle {
        /// Prefix bulleted list as dots (e.g., `"•"`).
        case dot

        /// Prefix bulleted list as numbers (e.g., `"1."` and `"2."`).
        case numbered

        fileprivate func bullet(at index: Int) -> String {
            switch self {
                case .dot:
                    return "•   "
                case .numbered:
                    return (index + 1).description + ".  "
            }
        }
    }

    /// Returns bulleted list of `self`.
    public func bullets(
        interlineFactor: CGFloat = 1,
        style: BulletStyle = .dot,
        font: UIFont
    ) -> NSAttributedString {
        guard !string.isEmpty else {
            return self
        }

        let existingAttributes = attributes(at: 0, effectiveRange: nil)

        let bulletedLines = string
            .lines()
            .lazy
            .enumerated()
            .map { style.bullet(at: $0.0) + $0.1 }
            .joined(separator: "\n")

        let size = style.bullet(at: 1)
            .size(withFont: existingAttributes[.font] as? UIFont ?? font)

        let paragraphStyle = NSMutableParagraphStyle().apply {
            $0.firstLineHeadIndent = 0
            $0.headIndent = size.width
            $0.paragraphSpacing = size.height * interlineFactor
        }

        return NSAttributedString(
            string: bulletedLines,
            attributes: existingAttributes + [.paragraphStyle: paragraphStyle]
        )
    }
}
