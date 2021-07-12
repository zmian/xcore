//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - Content Inset

extension UILabel {
    private enum AssociatedKey {
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

    @objc
    private func swizzled_drawText(in rect: CGRect) {
        swizzled_drawText(in: rect.inset(by: contentInset))
    }

    @objc
    private func swizzled_textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let textRect = swizzled_textRect(forBounds: bounds.inset(by: contentInset), limitedToNumberOfLines: numberOfLines)
        return CGRect(origin: textRect.origin, size: CGSize(width: textRect.size.width + contentInset.horizontal, height: textRect.height + contentInset.vertical))
    }
}

// MARK: - Line Spacing & Underline

extension UILabel {
    /// A height of the label.
    open var boundingHeight: CGFloat {
        guard let font = font else {
            return 0
        }

        return "Sphinx".size(withFont: font).height * CGFloat(numberOfLines)
    }

    open func lineSpacing(_ spacing: CGFloat) {
        attributedText = mutableAttributedString()?.lineSpacing(spacing)
    }

    open func underline() {
        attributedText = mutableAttributedString()?.underline()
    }

    private func mutableAttributedString() -> NSMutableAttributedString? {
        if let attributedText = attributedText {
            return NSMutableAttributedString(attributedString: attributedText)
        } else if let text = text {
            return NSMutableAttributedString(string: text)
        }

        return nil
    }
}

// MARK: - Bullets

extension UILabel {
    public func applyBullets(
        interlineFactor: CGFloat = 1,
        style: NSAttributedString.BulletStyle = .default
    ) {
        let attributedString = attributedText ?? NSAttributedString(
            string: text ?? "",
            attributes: [
                .font: font!,
                .foregroundColor: textColor!
            ]
        )

        attributedText = attributedString.bullets(
            interlineFactor: interlineFactor,
            style: style,
            font: font
        )
    }
}

// MARK: - Scale

extension UILabel {
    /// Update the font given scale factor while respecting any existing font
    /// attributes changes (e.g., subscript and superscript).
    ///
    /// ```swift
    /// let contentView = UIStackView()
    /// let availableWidth = contentView.frame.width - contentView.layoutMargins.horizontal - contentView.spacing
    ///
    /// let label = UILabel()
    /// label.attributedText = "Hello, world!"
    /// let scaleFactor = label.attributedText!.fontScaleFactor(width: availableWidth)
    /// label.updateFont(scaleFactor: scaleFactor)
    /// ```
    public func updateFont(scaleFactor: CGFloat) {
        guard let attributedText = attributedText else {
            let normalizedSize = floor(font.pointSize * scaleFactor * 10) / 10
            font = font.withSize(normalizedSize)
            return
        }

        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        let range = NSRange(location: 0, length: attributedString.string.count)

        attributedString.enumerateAttribute(.font, in: range) { font, range, _ in
            if let font = font as? UIFont {
                let normalizedSize = floor(font.pointSize * scaleFactor * 10) / 10
                let newFont = font.withSize(normalizedSize)
                attributedString.replaceAttribute(.font, value: newFont, range: range)
            }
        }

        self.attributedText = attributedString
    }
}

extension NSAttributedString {
    /// Returns font scale factor for the given width.
    ///
    /// ```swift
    /// let contentView = UIStackView()
    /// let availableWidth = contentView.frame.width - contentView.layoutMargins.horizontal - contentView.spacing
    ///
    /// let label = UILabel()
    /// label.attributedText = "Hello, world!"
    /// let scaleFactor = label.attributedText!.fontScaleFactor(width: availableWidth)
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

        let context = NSStringDrawingContext().apply {
            $0.minimumScaleFactor = fauxLabel.minimumScaleFactor
        }

        _ = boundingRect(with: fauxLabel.frame.size, options: .usesLineFragmentOrigin, context: context)

        return context.actualScaleFactor
    }
}

// MARK: - Accessibility

extension UILabel {
    /// The accessibility trait value that the element takes based on the text style
    /// it was given when created.
    open override var accessibilityTraits: UIAccessibilityTraits {
        get {
            let isTitle = font?.textStyle?.isTitle ?? false
            return isTitle ? .header : super.accessibilityTraits
        }
        set { super.accessibilityTraits = newValue }
    }
}

// MARK: - Swizzle

extension UILabel {
    private static func swizzle_drawText_runOnceSwapSelectors() {
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

    static func runOnceSwapSelectors() {
        swizzle_drawText_runOnceSwapSelectors()
    }
}
