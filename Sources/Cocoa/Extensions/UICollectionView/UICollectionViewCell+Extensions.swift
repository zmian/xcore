//
// UICollectionViewCell+Extensions.swift
//
// Copyright © 2018 Xcore
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
    /// Selects the cell and optionally scrolls it into view.
    ///
    /// If the `allowsSelection` property is `false`, calling this method has no effect.
    /// If there is an existing selection with a different index path and the `allowsMultipleSelection`
    /// property is `false`, calling this method replaces the previous selection.
    ///
    /// This method can cause selection-related delegate methods to be called based on the
    /// `shouldNotifyDelegate` parameter value.
    ///
    /// - Parameters:
    ///   - animated: Specify `true` to animate the change in the selection or `false` to make the change without animating it.
    ///   - scrollPosition: An option that specifies where the item should be positioned when scrolling finishes. The default value is `[]`.
    ///   - shouldNotifyDelegate: An option to specify whether the delegate methods to be called.
    @objc open func select(animated: Bool, scrollPosition: UICollectionView.ScrollPosition = [], shouldNotifyDelegate: Bool) {
        guard
            let collectionView = collectionView,
            let indexPath = collectionView.indexPath(for: self)
        else {
            return
        }

        collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition, shouldNotifyDelegate: shouldNotifyDelegate)
    }

    /// Deselects the cell.
    ///
    /// If the `allowsSelection` property is `false`, calling this method has no effect.
    ///
    /// This method can cause selection-related delegate methods to be called based on the
    /// `shouldNotifyDelegate` parameter value.
    ///
    /// - Parameters:
    ///   - animated: Specify `true` to animate the change in the selection or `false` to make the change without animating it.
    ///   - shouldNotifyDelegate: An option to specify whether the delegate methods to be called.
    @objc open func deselect(animated: Bool, shouldNotifyDelegate: Bool) {
        guard
            let collectionView = collectionView,
            let indexPath = collectionView.indexPath(for: self)
        else {
            return
        }

        collectionView.deselectItem(at: indexPath, animated: animated, shouldNotifyDelegate: shouldNotifyDelegate)
    }

    private var collectionView: UICollectionView? {
        return responder()
    }
}

// MARK: - Highlighted Background Color

extension UICollectionViewCell {
    @objc private func swizzled_isHighlightedSetter(newValue: Bool) {
        let oldValue = isHighlighted
        swizzled_isHighlightedSetter(newValue: newValue)
        guard oldValue != isHighlighted else { return }
        setHighlighted(isHighlighted, animated: true)
    }

    /// The view to which the `highlightedBackgroundColor` is applied.
    /// The default value is `contentView`.
    @objc open override var highlightedBackgroundColorView: UIView {
        return contentView
    }

    /// The view to which the `highlightedAnimation` is applied.
    /// The default value is `contentView`.
    @objc open override var highlightedAnimationView: UIView {
        return contentView
    }
}

// MARK: - Swizzle

extension UICollectionViewCell {
    static func runOnceSwapSelectors() {
        swizzle(
            UICollectionViewCell.self,
            originalSelector: #selector(setter: UICollectionViewCell.isHighlighted),
            swizzledSelector: #selector(UICollectionViewCell.swizzled_isHighlightedSetter(newValue:))
        )
    }
}
