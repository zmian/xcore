//
// UILabel+Extensions.swift
//
// Copyright © 2014 Xcore
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

extension UILabel {
    private struct AssociatedKey {
        static var contentInset = "contentInset"
    }

    /// The default value is `0`.
    open var contentInset: UIEdgeInsets {
        get { return associatedObject(&AssociatedKey.contentInset, default: 0) }
        set {
            setAssociatedObject(&AssociatedKey.contentInset, value: newValue)
            setNeedsDisplay()
        }
    }

    @objc private func swizzled_drawText(in rect: CGRect) {
        swizzled_drawText(in: rect.inset(by: contentInset))
    }

    @objc private func swizzled_textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        return swizzled_textRect(forBounds: bounds.inset(by: contentInset), limitedToNumberOfLines: numberOfLines)
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
