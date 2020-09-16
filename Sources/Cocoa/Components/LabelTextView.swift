//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - Handlers

extension LabelTextView {
    /// - Parameters:
    ///     - url: The URL to be processed.
    ///     - text: The text associated with the text view instance.
    public typealias URLTapBlock = (_ url: URL, _ text: String) -> Void

    /// - Parameters:
    ///     - url: The URL to be processed.
    ///     - characterRange: The character range containing the URL.
    ///     - attributedText: The text associated with the text view instance.
    public typealias URLInteractionBlock = (
        _ url: URL,
        _ characterRange: NSRange,
        _ attributedText: NSAttributedString
    ) -> Bool

    /// A block indicating if the user interaction with the given URL in the given
    /// range of text is allowed.
    ///
    /// This method is called on only the first interaction with the URL link. For
    /// example, this method is called when the user wants their first interaction
    /// with a URL to display a list of actions they can take; if the user chooses
    /// an open action from the list, this method is not called, because “open”
    /// represents the second interaction with the same URL.
    ///
    /// # Important
    /// Links in text views are interactive only if the text view is selectable but
    /// non-editable. That is, if the value of the `UITextView.isSelectable`
    /// property is `true` and the `isEditable` property is `false`.
    ///
    /// - Parameter callback: A block to invoke whenever user interacts with a link.
    public func canInteractWithUrl(_ callback: URLInteractionBlock? = nil) {
        self.canInteractWithUrl = callback
    }

    /// A convenience method to handle url taps.
    ///
    /// - Note: This method implements `canInteractWithUrl(_:)`, thus, if you
    /// implement both the last implementation overrides existing ones.
    public func didTapUrl(_ callback: URLTapBlock? = nil) {
        canInteractWithUrl { url, range, attributedText in
            guard let callback = callback else {
                return true
            }

            callback(
                url,
                attributedText.attributedSubstring(from: range).string
            )

            return false
        }
    }
}

// MARK: - LabelTextView

/// A `UITextView` subclass to be drop in replacement for `UILabel` for few
/// extra properties like tappable urls while maintaining `UILabel` auto-sizing
/// behavior.
open class LabelTextView: UITextView {
    private var canInteractWithUrl: URLInteractionBlock?

    /// The default value is `false`.
    open var isSelectionEnabled = false

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
        // Disable line selection when view is tapped by user.
        accessibilityTraits = .staticText
        dataDetectorTypes = .all
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        isEditable = false
        isScrollEnabled = false
        backgroundColor = .clear
        textAlignment = .left
        resistsSizeChange(axis: .vertical)
        didTapUrl(Self.defaultDidTapUrlHandler)
    }

    open override var canBecomeFirstResponder: Bool {
        isSelectionEnabled
    }
}

extension LabelTextView: UITextViewDelegate {
    open func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        guard
            interaction == .invokeDefaultAction,
            let attributedText = attributedText
        else {
            return false
        }

        return canInteractWithUrl?(URL, characterRange, attributedText) ?? true
    }
}

extension LabelTextView {
    public static var defaultDidTapUrlHandler: URLTapBlock?
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
                // If the "show numbers" feature is one we want to show the label.
                return super.accessibilityTraits == .link ? .button : super.accessibilityTraits
            }

            let isTitle = font?.textStyle?.isTitle ?? false
            return isTitle ? .header : super.accessibilityTraits
        }
        set { super.accessibilityTraits = newValue }
    }
}
