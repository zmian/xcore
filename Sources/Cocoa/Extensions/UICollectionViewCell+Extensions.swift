//
// UICollectionViewCell+Extensions.swift
//
// Copyright © 2018 Zeeshan Mian
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

extension UICollectionViewCell {
    private struct AssociatedKey {
        static var highlightedAnimation = "highlightedAnimation"
    }

    /// A boolean property to provide visual feedback when the
    /// cell is highlighted. The default value is `.none`.
    open var highlightedAnimation: HighlightedAnimationOptions {
        get { return associatedObject(&AssociatedKey.highlightedAnimation, default: .none) }
        set { setAssociatedObject(&AssociatedKey.highlightedAnimation, value: newValue) }
    }

    // MARK: Highlighted Background Color

    @objc private func swizzled_isHighlightedSetter(newValue: Bool) {
        let oldValue = isHighlighted
        self.swizzled_isHighlightedSetter(newValue: newValue)
        guard oldValue != isHighlighted else { return }
        setHighlighted(isHighlighted, animated: true)
    }

    /// The background color of the cell for the highlighted state.
    @objc open dynamic var highlightedBackgroundColor: UIColor? {
        get { return backgroundColor(for: .highlighted) }
        set { setBackgroundColor(newValue, for: .highlighted) }
    }

    /// The background color of the cell for the normal state.
    private var normalBackgroundColor: UIColor? {
        get { return backgroundColor(for: .normal) }
        set { setBackgroundColor(newValue, for: .normal) }
    }

    private func setHighlighted(_ highlighted: Bool, animated: Bool) {
        highlightedAnimation.animate(highlightedAnimationView, isHighlighted: highlighted)

        guard let highlightedBackgroundColor = highlightedBackgroundColor else {
            return
        }

        // Make sure we always store unhighlighted background color so we can later restore it.
        if highlightedBackgroundColor != highlightedBackgroundColorView.backgroundColor {
            normalBackgroundColor = highlightedBackgroundColorView.backgroundColor
        }

        let newBackgroundColor = highlighted ? highlightedBackgroundColor : normalBackgroundColor

        UIView.animateFromCurrentState(withDuration: animated ? 0.15 : 0) {
            self.highlightedBackgroundColorView.backgroundColor = newBackgroundColor
        }
    }

    /// The view to which the `highlightedBackgroundColor` is applied.
    /// The default value is `contentView`.
    @objc open var highlightedBackgroundColorView: UIView {
        return contentView
    }

    /// The view to which the `highlightedAnimation` is applied.
    /// The default value is `contentView`.
    @objc open var highlightedAnimationView: UIView {
        return contentView
    }
}

// MARK: Swizzle

extension UICollectionViewCell {
    static func runOnceSwapSelectors() {
        swizzle(
            UICollectionViewCell.self,
            originalSelector: #selector(setter: UICollectionViewCell.isHighlighted),
            swizzledSelector: #selector(UICollectionViewCell.swizzled_isHighlightedSetter(newValue:))
        )
    }
}
