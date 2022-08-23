//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - Bullets

extension UILabel {
    public func applyBullets(
        interlineFactor: CGFloat = 1,
        style: NSAttributedString.BulletStyle = .dot
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
        guard let attributedText else {
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
