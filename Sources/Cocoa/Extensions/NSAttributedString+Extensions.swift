//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - NSAttributedString Extension

extension NSAttributedString {
    @objc public func lineSpacing(_ spacing: CGFloat) -> NSMutableAttributedString {
         NSMutableAttributedString(attributedString: self).lineSpacing(spacing)
    }

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

// MARK: - NSMutableAttributedString Extension

extension NSMutableAttributedString {
    open func replaceAttribute(_ name: Key, value: Any, range: NSRange) {
        removeAttribute(name, range: range)
        addAttribute(name, value: value, range: range)
    }
}

// MARK: - Chaining Attributes

extension NSMutableAttributedString {
    open func underline(_ text: String? = nil, style: NSUnderlineStyle = .single) -> Self {
        addAttribute(.underlineStyle, value: style.rawValue, range: range(of: text))
        return self
    }

    open func foregroundColor(_ color: UIColor, for text: String? = nil) -> Self {
        addAttribute(.foregroundColor, value: color, range: range(of: text))
        return self
    }

    open func backgroundColor(_ color: UIColor, for text: String? = nil) -> Self {
        addAttribute(.backgroundColor, value: color, range: range(of: text))
        return self
    }

    open func font(_ font: UIFont, for text: String? = nil) -> Self {
        addAttribute(.font, value: font, range: range(of: text))
        return self
    }

    open func link(url: URL?, text: String) -> Self {
        guard let url = url else {
            return self
        }

        addAttribute(.link, value: url, range: range(of: text))
        return self
    }

    public override func lineSpacing(_ spacing: CGFloat) -> Self {
        paragraphStyle(\.lineSpacing, to: spacing, range: range(of: nil))
        return self
    }

    open func textAlignment(_ textAlignment: NSTextAlignment, for text: String? = nil) -> Self {
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

// MARK: - Image Attachment

extension NSAttributedString {
    /// Returns an `NSAttributedString` object initialized with a given `string` and
    /// `attributes`.
    ///
    /// Returns an `NSAttributedString` object initialized with the characters of
    /// `string` and the attributes of `attributes`. The returned object might be
    /// different from the original receiver.
    ///
    /// - Parameters:
    ///   - string: The string for the new attributed string.
    ///   - image: The image for the new attributed string.
    ///   - baselineOffset: The value indicating the `image` offset from the
    ///                     baseline. The default value is `0`.
    ///   - attributes: The attributes for the new attributed string. For a list of
    ///                 attributes that you can include in this dictionary, see
    ///                 `Character Attributes`.
    public convenience init(
        string: String? = nil,
        image: UIImage,
        baselineOffset: CGFloat = 0,
        attributes: [Key: Any]? = nil
    ) {
        guard let string = string else {
            self.init(image: image, baselineOffset: baselineOffset)
            return
        }

        let attachment = NSAttributedString(image: image, baselineOffset: baselineOffset)
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        attributedString.append(attachment)
        self.init(attributedString: attributedString)
    }

    /// Returns an `NSAttributedString` object initialized with a given `image` and
    /// `baselineOffset`.
    ///
    /// - Parameters:
    ///   - image: The image for the new attributed string.
    ///   - baselineOffset: The value indicating the `image` offset from the
    ///                     baseline. The default value is `0`.
    private convenience init(
        image: UIImage,
        baselineOffset: CGFloat = 0
    ) {
        let paragraphStyle = NSMutableParagraphStyle().apply {
            $0.lineHeightMultiple = 0.9
        }

        let attachment = NSTextAttachment().apply {
            $0.image = image
        }

        self.init(
            string: String(Character(UnicodeScalar(NSTextAttachment.character)!)),
            attributes: [
                .attachment: attachment,
                .baselineOffset: baselineOffset,
                .paragraphStyle: paragraphStyle
            ]
        )
    }
}

// MARK: - Caret

extension NSAttributedString {
    /// Returns an `NSAttributedString` object initialized with a given attributes.
    ///
    /// - Parameters:
    ///   - string: The string for the new attributed string.
    ///   - spacer: The spacer between the caret `direction` and the `string`. The
    ///             default value is two spaces `"  "`.
    ///   - font: The font for the `string`.
    ///   - color: The color for the caret and the `string`.
    ///   - direction: The caret direction to use. The default value is `.forward`.
    ///   - state: The state for which to generate the new attributed string. The
    ///            default value is `.normal`.
    public convenience init(
        string: String,
        spacer: String = " ",
        font: UIFont,
        color: UIColor,
        direction: CaretDirection = .forward,
        for state: UIControl.State = .normal
    ) {
        let imageTintColor = color
        var textColor = imageTintColor
        let alpha = textColor.alpha * 0.5

        if state == .highlighted {
            textColor = textColor.alpha(alpha)
        }

        let attributes: [Key: Any] = [
            .font: font,
            .foregroundColor: textColor
        ]

        guard let assetIdentifier = direction.assetIdentifier else {
            self.init(string: string, attributes: attributes)
            return
        }

        let symbolConfiguration = UIImage.SymbolConfiguration(font: font, scale: .small)
        var image = UIImage(system: assetIdentifier, with: symbolConfiguration)?
            .tintColor(imageTintColor) ?? UIImage()

        if state == .highlighted {
            image = image.alpha(alpha)
        }

        self.init(
            string: string + spacer,
            image: image,
            baselineOffset: direction.imageBaselineOffset,
            attributes: attributes
        )
    }
}

// MARK: - CaretDirection

extension NSAttributedString {
    public enum CaretDirection {
        case none
        case up
        case down
        case back
        case forward

        var assetIdentifier: SystemAssetIdentifier? {
            switch self {
                case .none:
                    return nil
                case .up:
                    return .chevronUp
                case .down:
                    return .chevronDown
                case .back:
                    return .chevronBackward
                case .forward:
                    return .chevronForward
            }
        }

        var imageBaselineOffset: CGFloat {
            switch self {
                case .none:
                    return 0
                case .up, .down:
                    return 1
                case .back, .forward:
                    return -0.5
            }
        }
    }
}

// MARK: - Bullets

extension NSAttributedString {
    public enum BulletStyle {
        case `default`
        case ordinal

        fileprivate func bullet(at index: Int) -> String {
            switch self {
                case .default:
                    return "•   "
                case .ordinal:
                    return (index + 1).description + ".  "
            }
        }
    }

    public func bullets(
        interlineFactor: CGFloat = 1,
        style: BulletStyle = .default,
        font: UIFont
    ) -> NSAttributedString {
        guard !string.isEmpty else {
            return self
        }

        let existingAttributes = attributes(at: 0, effectiveRange: nil)

        let bulletedLines = string
            .lines()
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
