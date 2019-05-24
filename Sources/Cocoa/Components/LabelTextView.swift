//
// LabelTextView.swift
//
// Copyright © 2017 Zeeshan Mian
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

/// A `UITextView` subclass to be drop in replacement for `UILabel` for few
/// extra properties like tappable urls while maintaining `UILabel` auto-sizing
/// behavior.
open class LabelTextView: UITextView {
    public typealias URLTapActionBlock = (_ url: URL, _ text: String) -> Void

    /// The default value is `false`.
    open var isSelectionEnabled = false

    /// The default value is `true`.
    open var isEmailLinkTapEnabled = true

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
        isAccessibilityRotorHintEnabled = true
        dataDetectorTypes = .all
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        linkTextAttributes = [.foregroundColor: UIColor.appleBlue]
        isEditable = false
        isScrollEnabled = false
        backgroundColor = .clear
        textAlignment = .left
        textColor = .black
        font = .preferredFont(forTextStyle: .footnote)
        resistsSizeChange(axis: .vertical)
        didTapUrl = type(of: self).defaultDidTapUrlHandler
    }

    open override var canBecomeFirstResponder: Bool {
        return isSelectionEnabled
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
        if [.http, .https].contains(url.schemeType) {
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
