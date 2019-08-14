//
// MarkdownKit+UIKit.swift
//
// Copyright © 2017 Xcore
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

#if canImport(Haring)
import Haring

extension MarkupText {
    /// This configuration exists to allow some of the properties
    /// to be configured to match app's appearance style.
    /// The `UIAppearance` protocol doesn't work when the stored properites
    /// are set using associated object.
    ///
    /// **For example:**
    ///
    /// ```swift
    /// MarkupText.appearance.textColor = .gray
    /// ```
    @objc(MarkupTextAppearance)
    final public class Appearance: NSObject {
        public var font: UIFont = .app(style: .body)
        public var textColor: UIColor = .black
        public var isLabelEnabled: Bool = false
        public var isTextViewEnabled: Bool = false
        fileprivate override init() {}
    }
}

extension MarkupText {
    @objc public dynamic static let appearance = Appearance()

    public static var parser: MarkdownParser {
        let parser = MarkdownParser.app()
        parser.update(font: appearance.font, textColor: appearance.textColor)
        return parser
    }
}

extension MarkdownParser {
    fileprivate static func app() -> MarkdownParser {
        let markdownParser = MarkdownParser(
            font: MarkupText.appearance.font,
            color: MarkupText.appearance.textColor,
            automaticLinkDetectionEnabled: false,
            customElements: [
                MarkdownTextColor(),
                MarkdownBackgroundColor(),
                MarkdownCustomFont(),
                MarkdownUnderline()
            ]
        )
        return markdownParser
    }
}

extension UILabel {
    private struct AssociatedKey {
        static var markdownParser = "markdownParser"
        static var isMarkupEnabled = "isMarkupEnabled"
    }

    /// A boolean property to determine whether the Markdown is supported.
    ///
    /// The default value is `false`.
    public var isMarkupEnabled: Bool {
        get { return associatedObject(&AssociatedKey.isMarkupEnabled, default: MarkupText.appearance.isLabelEnabled) }
        set { setAssociatedObject(&AssociatedKey.isMarkupEnabled, value: newValue) }
    }

    // TODO: Expose better api to get the parser text
    public private(set) var markdownParser: MarkdownParser {
        get {
            let parser: MarkdownParser

            if let existingParser: MarkdownParser = associatedObject(&AssociatedKey.markdownParser) {
                parser = existingParser
            } else {
                parser = MarkdownParser.app()
                self.markdownParser = parser
            }

            parser.update(font: font, textColor: textColor)
            return parser
        }
        set { setAssociatedObject(&AssociatedKey.markdownParser, value: newValue) }
    }
}

extension UIButton {
    private struct AssociatedKey {
        static var markdownParser = "markdownParser"
        static var isMarkupEnabled = "isMarkupEnabled"
    }

    /// A boolean property to determine whether the Markdown is supported.
    ///
    /// The default value is `false`.
    public var isMarkupEnabled: Bool {
        get { return associatedObject(&AssociatedKey.isMarkupEnabled, default: false) }
        set { setAssociatedObject(&AssociatedKey.isMarkupEnabled, value: newValue) }
    }

    private var markdownParser: MarkdownParser {
        get {
            let parser: MarkdownParser

            if let existingParser: MarkdownParser = associatedObject(&AssociatedKey.markdownParser) {
                parser = existingParser
            } else {
                parser = MarkdownParser.app()
                self.markdownParser = parser
            }

            return parser
        }
        set { setAssociatedObject(&AssociatedKey.markdownParser, value: newValue) }
    }
}

extension UITextView {
    private struct AssociatedKey {
        static var markdownParser = "markdownParser"
        static var isMarkupEnabled = "isMarkupEnabled"
        static var isAccessibilityRotorHintEnabled = "isAccessibilityRotorHintEnabled"
    }

    /// A boolean property to determine whether the accessibility hint to use rotor
    /// is enabled.
    ///
    /// The default value is `false`.
    public var isAccessibilityRotorHintEnabled: Bool {
        get { return associatedObject(&AssociatedKey.isAccessibilityRotorHintEnabled, default: false) }
        set { setAssociatedObject(&AssociatedKey.isAccessibilityRotorHintEnabled, value: newValue) }
    }

    /// A boolean property to determine whether the Markdown is supported.
    ///
    /// The default value is `false`.
    public var isMarkupEnabled: Bool {
        get { return associatedObject(&AssociatedKey.isMarkupEnabled, default: MarkupText.appearance.isTextViewEnabled) }
        set { setAssociatedObject(&AssociatedKey.isMarkupEnabled, value: newValue) }
    }

    private var markdownParser: MarkdownParser {
        get {
            let parser: MarkdownParser

            if let existingParser: MarkdownParser = associatedObject(&AssociatedKey.markdownParser) {
                parser = existingParser
            } else {
                parser = MarkdownParser.app()
                self.markdownParser = parser
            }

            parser.update(font: font ?? MarkupText.appearance.font, textColor: textColor)
            return parser
        }
        set { setAssociatedObject(&AssociatedKey.markdownParser, value: newValue) }
    }
}

extension UILabel {
    /// Creates and set `NSAttributedString` from Markdown.
    ///
    /// This variant of Markdown supports couple of extra features:
    ///
    /// - Colored text is achieved with `{#123456|the colored text}`
    /// - Set text background color with `{bg#123456|the text}`
    /// - Change font with `{font:HelveticaNeue,12pt|text in a different font}`
    private var markupText: String? {
        get { return attributedText?.string }
        set {
            guard let newValue = newValue else {
                attributedText = nil
                return
            }

            attributedText = markdownParser.parse(newValue)
        }
    }

    // TODO: Adding support for images in MarkdownKit would elimate the need for extension.
    func markupText(_ markupText: String, image: UIImage, imageOffsetY: CGFloat) {
        let attributedString = markdownParser.parse(markupText)
        let imageAttributedString = NSAttributedString(image: image, baselineOffset: imageOffsetY)
        let finalString = NSMutableAttributedString(attributedString: attributedString)
        finalString.append(imageAttributedString)
        self.attributedText = finalString
    }
}

extension UIButton {
    // TODO: Adding support for images in MarkdownKit would elimate the need for extension.
    public func markupText(_ markupText: String, image: UIImage, imageOffsetY: CGFloat) {
        let attributedString = markdownParser.parse(markupText)
        let imageAttributedString = NSAttributedString(image: image, baselineOffset: imageOffsetY)
        let finalString = NSMutableAttributedString(attributedString: attributedString)
        finalString.append(imageAttributedString)
        setAttributedTitle(finalString, for: .normal)
    }
}

extension UITextView {
    /// Creates and set `NSAttributedString` from Markdown.
    ///
    /// This variant of Markdown supports couple of extra features:
    ///
    /// - Colored text is achieved with `{#123456|the colored text}`
    /// - Set text background color with `{bg#123456|the text}`
    /// - Change font with `{font:HelveticaNeue,12pt|text in a different font}`
    private var markupText: String? {
        get { return attributedText?.string }
        set {
            guard let newValue = newValue else {
                attributedText = nil
                return
            }

            let existingTextAlignment = textAlignment
            attributedText = markdownParser.parse(newValue)
            textAlignment = existingTextAlignment
            setAccessibilityHintIfNeeded(attributedText)
        }
    }

    private func setAccessibilityHintIfNeeded(_ attributedText: NSAttributedString?) {
        guard isAccessibilityRotorHintEnabled, let attributedText = attributedText else {
            return
        }

        var totalLinks = 0

        attributedText.enumerateAttribute(.link, in: NSRange(0..<attributedText.length)) { value, _, _ in
            guard value != nil else {
                return
            }

            totalLinks += 1
        }

        accessibilityHint = totalLinks > 0 ? "Use the rotor to access links." : ""
    }
}

// MARK: MarkupText Swizzle

extension UILabel {
    @objc private var swizzled_text: String? {
        get { return isMarkupEnabled ? markupText : self.swizzled_text }
        set {
            if isMarkupEnabled {
                markupText = newValue
            } else {
                self.swizzled_text = newValue
            }
        }
    }

    // TODO: `isMarkupEnabled` is `true` by default for all `UILabel`
    // This causes issues with `UINavigationBar`'s UILabel instance by removing
    // its text color and font.
    @objc private func swizzled_textColor(_ newValue: UIColor!) {
        swizzled_textColor(newValue)

        if newValue == textColor, !isMarkupEnabled || text == nil {
            return
        }

        if let text = (text ?? attributedText?.string), text.isBlank {
            return
        }

        // Reassign the text to ensure the new color is applied correctly.
        //
        // We have to explicitly set `attributedText` instead of `markupText`
        // as `markupText` returns `attributedText?.string` causing all the attributes
        // to be removed.
        if attributedText != nil {
            let currentAttributedText = attributedText
            self.attributedText = currentAttributedText
        } else {
            let currentText = text
            self.text = currentText
        }
    }
}

extension UIButton {
    @objc private func swizzled_title(for state: UIControl.State) -> String? {
        return isMarkupEnabled ? attributedTitle(for: state)?.string : swizzled_title(for: state)
    }

    /// Creates and set `NSAttributedString` from Markdown.
    ///
    /// This variant of Markdown supports couple of extra features:
    ///
    /// - Colored text is achieved with `{#123456|the colored text}`
    /// - Set text background color with `{bg#123456|the text}`
    /// - Change font with `{font:HelveticaNeue,12pt|text in a different font}`
    @objc private func swizzled_setTitle(_ title: String?, for state: UIControl.State) {
        if !isMarkupEnabled {
            setAttributedTitle(nil, for: state)
            swizzled_setTitle(title, for: state)
            return
        }

        guard let title = title else {
            setAttributedTitle(nil, for: state)
            return
        }

        setAttributedTitle(markdownParser.parse(title), for: state)
    }
}

extension UITextView {
    @objc private var swizzled_text: String? {
        get { return isMarkupEnabled ? markupText : self.swizzled_text }
        set {
            if isMarkupEnabled {
                markupText = newValue
            } else {
                self.swizzled_text = newValue
            }
        }
    }

    // TODO: Fix the Haring library to not reguire this workaround.
    @objc private func swizzled_textColor(_ newValue: UIColor!) {
        swizzled_textColor(newValue)

        if newValue == textColor, !isMarkupEnabled || text == nil {
            return
        }

        if let text = (text ?? attributedText?.string), text.isBlank {
            return
        }

        // Reassign the text to ensure the new color is applied correctly.
        //
        // We have to explicitly set `attributedText` instead of `markupText`
        // as `markupText` returns `attributedText?.string` causing all the attributes
        // to be removed.
        if attributedText != nil {
            let currentAttributedText = attributedText
            self.attributedText = currentAttributedText
        } else {
            let currentText = text
            self.text = currentText
        }
    }
}
#endif

extension UILabel {
    static func swizzle_runOnceSwapSelectors() {
        #if canImport(Haring)
        swizzle(
            UILabel.self,
            originalSelector: #selector(getter: UILabel.text),
            swizzledSelector: #selector(getter: UILabel.swizzled_text)
        )

        swizzle(
            UILabel.self,
            originalSelector: #selector(setter: UILabel.text),
            swizzledSelector: #selector(setter: UILabel.swizzled_text)
        )

        swizzle(
            UILabel.self,
            originalSelector: #selector(setter: UILabel.textColor),
            swizzledSelector: #selector(UILabel.swizzled_textColor(_:))
        )
        #endif
        swizzle_drawText_runOnceSwapSelectors()
    }
}

extension UIButton {
    static func swizzle_runOnceSwapSelectors() {
        #if canImport(Haring)
        swizzle(
            UIButton.self,
            originalSelector: #selector(UIButton.title(for:)),
            swizzledSelector: #selector(UIButton.swizzled_title(for:))
        )

        swizzle(
            UIButton.self,
            originalSelector: #selector(UIButton.setTitle(_:for:)),
            swizzledSelector: #selector(UIButton.swizzled_setTitle(_:for:))
        )
        #endif
    }
}

extension UITextView {
    static func swizzle_runOnceSwapSelectors() {
        #if canImport(Haring)
        swizzle(
            UITextView.self,
            originalSelector: #selector(getter: UITextView.text),
            swizzledSelector: #selector(getter: UITextView.swizzled_text)
        )

        swizzle(
            UITextView.self,
            originalSelector: #selector(setter: UITextView.text),
            swizzledSelector: #selector(setter: UITextView.swizzled_text)
        )

        swizzle(
            UITextView.self,
            originalSelector: #selector(setter: UITextView.textColor),
            swizzledSelector: #selector(UITextView.swizzled_textColor(_:))
        )
        #endif
    }
}
