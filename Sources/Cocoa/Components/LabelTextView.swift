//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A `UITextView` subclass to be drop in replacement for `UILabel` for few
/// extra properties like tappable urls while maintaining `UILabel` auto-sizing
/// behavior.
open class LabelTextView: UITextView {
    public typealias URLTapActionBlock = (_ url: URL, _ text: String) -> Void

    /// The default value is `false`.
    open var isSelectionEnabled = false

    /// The default value is `true`.
    open var isEmailLinkTapEnabled = true

    /// The default value is ["http", "https"].
    open var supportedUrlSchemes: [URL.Scheme] = [.http, .https]

    private var didTapUrl: URLTapActionBlock?
    open func didTapUrl(_ callback: URLTapActionBlock? = nil) {
        self.didTapUrl = callback
    }

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        delegate = self
        #if canImport(Haring)
        isAccessibilityRotorHintEnabled = true
        #endif
        isAccessibilityElement = true
        // Disable line selection when view is
        // tapped by user.
        accessibilityTraits = .staticText
        dataDetectorTypes = .all
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        isEditable = false
        isScrollEnabled = false
        backgroundColor = .clear
        textAlignment = .left
        resistsSizeChange(axis: .vertical)
        didTapUrl = Self.defaultDidTapUrlHandler
    }

    open override var canBecomeFirstResponder: Bool {
        isSelectionEnabled
    }
}

extension LabelTextView: UITextViewDelegate {
    open func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard interaction == .invokeDefaultAction else {
            return false
        }

        return handleUrlTapped(url: URL, characterRange: characterRange)
    }

    private func handleUrlTapped(url: URL, characterRange: NSRange) -> Bool {
        if supportedUrlSchemes.contains(url.schemeType) {
            notifyUrlTapped(url: url, characterRange: characterRange)
            return false
        }

        if url.schemeType == .email {
            return isEmailLinkTapEnabled
        }

        return true
    }

    private func notifyUrlTapped(url: URL, characterRange: NSRange) {
        guard didTapUrl != nil else {
            return
        }

        didTapUrl?(
            url,
            attributedText?.attributedSubstring(from: characterRange).string ?? ""
        )
    }
}

extension LabelTextView {
    public static var defaultDidTapUrlHandler: URLTapActionBlock?
}

// MARK: - UIAppearance Properties

extension LabelTextView {
    /// The font of the text.
    ///
    /// This property applies to the entire text string. The default value of this
    /// property is the body style of the system font.
    ///
    /// - Note:
    ///
    /// You can get information about the fonts available on the system using the
    /// methods of the `UIFont` class.
    ///
    /// In iOS 6 and later, assigning a new value to this property causes the new
    /// font to be applied to the entire contents of the text view. If you want to
    /// apply the font to only a portion of the text, you must create a new
    /// attributed string with the desired style information and assign it to the
    /// `attributedText` property.
    @objc open override dynamic var font: UIFont? {
        get { super.font }
        set { super.font = newValue }
    }

    /// The color of the text.
    ///
    /// This property applies to the entire text string. The default text color is
    /// `.black`.
    ///
    /// In iOS 6 and later, assigning a new value to this property causes the new
    /// text color to be applied to the entire contents of the text view. If you
    /// want to apply the color to only a portion of the text, you must create a new
    /// attributed string with the desired style information and assign it to the
    /// `attributedText` property.
    @objc open override dynamic var textColor: UIColor? {
        get { super.textColor }
        set { super.textColor = newValue }
    }

    /// The attributes to apply to links.
    ///
    /// The default attributes specify blue text.
    @objc open override dynamic var linkTextAttributes: [NSAttributedString.Key: Any]! {
        get { super.linkTextAttributes }
        set { super.linkTextAttributes = newValue }
    }
}

// MARK: - Accessibility

extension LabelTextView {
    /// The accessibility trait value that the element takes based on the text style
    /// it was given when created.
    open override var accessibilityTraits: UIAccessibilityTraits {
        get {
            guard UIAccessibility.isVoiceOverRunning else {
                return super.accessibilityTraits == .link ? .button : super.accessibilityTraits
            }

            let isTitle = font?.textStyle?.isTitle ?? false
            return isTitle ? .header : super.accessibilityTraits
        }
        set { super.accessibilityTraits = newValue }
    }
}
