//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UITextView {
    /// The maximum number of lines to use for rendering text.
    ///
    /// This property controls the maximum number of lines to use in order to fit
    /// the label’s text into its bounding rectangle. The default value for this
    /// property is `1`. To remove any maximum limit, and use as many lines as
    /// needed, set the value of this property to `0`.
    ///
    /// If you constrain your text using this property, any text that does not fit
    /// within the maximum number of lines and inside the bounding rectangle of the
    /// label is truncated using the appropriate line break mode, as specified by
    /// the `lineBreakMode` property.
    ///
    /// When the label is resized using the `sizeToFit()` method, resizing takes
    /// into account the value stored in this property. For example, if this
    /// property is set to `3`, the `sizeToFit()` method resizes the receiver so
    /// that it is big enough to display three lines of text.
    public var numberOfLines: Int {
        get {
            guard let font = font else {
                return 0
            }

            return Int(contentSize.height / font.lineHeight)
        }
        set { textContainer.maximumNumberOfLines = newValue }
    }

    func textRange(from range: NSRange) -> UITextRange? {
        guard
            let start = position(from: beginningOfDocument, offset: range.location),
            let end = position(from: start, offset: range.length)
        else {
            return nil
        }

        return textRange(from: start, to: end)
    }

    /// Returns `UIAccessibilityElement` for all links inside current instance it
    /// was given when created.
    public var linkAccessibilityElements: [UIAccessibilityElement] {
        var linkElements: [UIAccessibilityElement] = []

        attributedText.enumerateAttribute(.link, in: NSRange(0..<attributedText.length)) { value, range, _ in
            guard value != nil else {
                return
            }

            let element = UIAccessibilityElement(accessibilityContainer: self)
            element.accessibilityTraits = .link
            element.accessibilityValue = (value as? URL)?.absoluteString

            if let textRange = textRange(from: range) {
                element.accessibilityFrameInContainerSpace = firstRect(for: textRange)
                element.accessibilityLabel = self.text(in: textRange)
            }

            linkElements.append(element)
        }

        return linkElements
    }
}
