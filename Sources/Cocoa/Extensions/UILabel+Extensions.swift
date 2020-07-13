//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UILabel {
    private struct AssociatedKey {
        static var contentInset = "contentInset"
    }

    /// The default value is `0`.
    open var contentInset: UIEdgeInsets {
        get { associatedObject(&AssociatedKey.contentInset, default: 0) }
        set {
            setAssociatedObject(&AssociatedKey.contentInset, value: newValue)
            setNeedsDisplay()
        }
    }

    @objc private func swizzled_drawText(in rect: CGRect) {
        swizzled_drawText(in: rect.inset(by: contentInset))
    }

    @objc private func swizzled_textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let textRect = swizzled_textRect(forBounds: bounds.inset(by: contentInset), limitedToNumberOfLines: numberOfLines)
        return CGRect(origin: textRect.origin, size: CGSize(width: textRect.size.width + contentInset.horizontal, height: textRect.height + contentInset.vertical))
    }
}

extension UILabel {
    open func setLineSpacing(_ spacing: CGFloat, text: String? = nil) {
        guard let text = text ?? self.text else { return }
        attributedText = NSMutableAttributedString(string: text).setLineSpacing(spacing)
    }

    /// A height of the label.
    open var boundingHeight: CGFloat {
        guard let font = font else {
            return 0
        }

        return "Sphinx".size(withFont: font).height * CGFloat(numberOfLines)
    }

    // MARK: - Underline

    @objc open func underline() {
        if let attributedText = attributedText {
            self.attributedText = NSMutableAttributedString(attributedString: attributedText).underline(attributedText.string)
        } else if let text = text {
            self.attributedText = NSMutableAttributedString(string: text).underline(text)
        }
    }
}

// MARK: - Bullets

extension UILabel {
    public func applyBullets(interlineFactor: CGFloat = 1.0, style: NSAttributedString.BulletStyle = .default) {
        let attributedString = attributedText ?? NSAttributedString(string: text ?? "", attributes: [.font: font!, .foregroundColor: textColor!])
        attributedText = attributedString.bullets(interlineFactor: interlineFactor, style: style, font: font)
    }
}

// MARK: - Scale

extension UILabel {
    /// Update the font given scale factor.
    ///
    /// ```swift
    /// let contentView = UIStackView()
    ///
    /// let label = UILabel()
    /// label.attributedText = "Hello, world!"
    ///
    /// let width = contentView.frame.width - contentView.layoutMargins.horizontal - contentView.spacing
    ///
    /// let scaleFactor = label.attributedText!.fontScaleFactor(width: width)
    /// label.updateFont(scaleFactor: scaleFactor)
    /// ```
    public func updateFont(scaleFactor: CGFloat) {
        guard let attributedText = attributedText else {
            let normalizedSize = floor(font.pointSize * scaleFactor * 10) / 10
            font = font.withSize(normalizedSize)
            return
        }

        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
        let range = NSRange(location: 0, length: mutableAttributedString.string.count)

        mutableAttributedString.enumerateAttribute(.font, in: range) { font, range, stop in
            if let font = font as? UIFont {
                let normalizedSize = floor(font.pointSize * scaleFactor * 10) / 10
                let newFont = font.withSize(normalizedSize)
                mutableAttributedString.replaceAttribute(.font, value: newFont, range: range)
            }
        }

        self.attributedText = mutableAttributedString
    }
}

extension NSAttributedString {
    /// Returns font scale factor for the given width.
    ///
    /// ```swift
    /// let contentView = UIStackView()
    ///
    /// let label = UILabel()
    /// label.attributedText = "Hello, world!"
    ///
    /// let width = contentView.frame.width - contentView.layoutMargins.horizontal - contentView.spacing
    ///
    /// let scaleFactor = label.attributedText!.fontScaleFactor(width: width)
    /// label.updateFont(scaleFactor: scaleFactor)
    /// ```
    public func fontScaleFactor(width: CGFloat, minimumScaleFactor: CGFloat = 0.5) -> CGFloat {
        let fauxLabel = UILabel().apply {
            $0.attributedText = self
            $0.minimumScaleFactor = minimumScaleFactor
            $0.adjustsFontSizeToFitWidth = true
            $0.sizeToFit()
            $0.frame.size.width = width
        }
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = fauxLabel.minimumScaleFactor
        _ = boundingRect(with: fauxLabel.frame.size, options: .usesLineFragmentOrigin, context: context)
        return context.actualScaleFactor
    }
}

// MARK: Swizzle

extension UILabel {
    static func swizzle_drawText_runOnceSwapSelectors() {
        swizzle(
            UILabel.self,
            originalSelector: #selector(UILabel.drawText(in:)),
            swizzledSelector: #selector(UILabel.swizzled_drawText(in:))
        )

        swizzle(
            UILabel.self,
            originalSelector: #selector(UILabel.textRect(forBounds:limitedToNumberOfLines:)),
            swizzledSelector: #selector(UILabel.swizzled_textRect(forBounds:limitedToNumberOfLines:))
        )
    }
}

// MARK: Accessibility

extension UILabel {
    /// The accessibility trait value that the element takes based on the text style
    /// it was given when created.
    open override var accessibilityTraits: UIAccessibilityTraits {
        get {
            guard
                let currentFont = font,
                let textStyle = currentFont.fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle
            else {
                return super.accessibilityTraits
            }

            switch textStyle {
                case UIFont.TextStyle.title1,
                     UIFont.TextStyle.title2,
                     UIFont.TextStyle.title3,
                     UIFont.TextStyle.headline,
                     UIFont.TextStyle.largeTitle:
                    return .header
                default:
                    return super.accessibilityTraits
            }
        }
        set { super.accessibilityTraits = newValue }
    }
}
