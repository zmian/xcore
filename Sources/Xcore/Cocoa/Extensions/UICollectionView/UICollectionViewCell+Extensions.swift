//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - Select & Deselect

extension UICollectionViewCell {
    /// Selects the cell and optionally scrolls it into view.
    ///
    /// If the `allowsSelection` property is `false`, calling this method has no
    /// effect.
    ///
    /// If there is an existing selection with a different index path and the
    /// `allowsMultipleSelection` property is `false`, calling this method replaces
    /// the previous selection.
    ///
    /// This method can cause selection-related delegate methods to be called based
    ///  on the `shouldNotifyDelegate` parameter value.
    ///
    /// - Parameters:
    ///   - animated: Specify `true` to animate the change in the selection or
    ///     `false` to make the change without animating it.
    ///   - scrollPosition: An option that specifies where the item should be
    ///     positioned when scrolling finishes.
    ///   - shouldNotifyDelegate: An option to specify whether the delegate methods
    ///     to be called.
    @objc
    open func select(
        animated: Bool,
        scrollPosition: UICollectionView.ScrollPosition = [],
        shouldNotifyDelegate: Bool
    ) {
        guard
            let collectionView = collectionView,
            let indexPath = collectionView.indexPath(for: self)
        else {
            return
        }

        collectionView.selectItem(
            at: indexPath,
            animated: animated,
            scrollPosition: scrollPosition,
            shouldNotifyDelegate: shouldNotifyDelegate
        )
    }

    /// Deselects the cell.
    ///
    /// If the `allowsSelection` property is `false`, calling this method has no
    /// effect.
    ///
    /// This method can cause selection-related delegate methods to be called based
    /// on the `shouldNotifyDelegate` parameter value.
    ///
    /// - Parameters:
    ///   - animated: Specify `true` to animate the change in the selection or
    ///     `false` to make the change without animating it.
    ///   - shouldNotifyDelegate: An option to specify whether the delegate methods
    ///     to be called.
    @objc
    open func deselect(animated: Bool, shouldNotifyDelegate: Bool) {
        guard
            let collectionView = collectionView,
            let indexPath = collectionView.indexPath(for: self)
        else {
            return
        }

        collectionView.deselectItem(
            at: indexPath,
            animated: animated,
            shouldNotifyDelegate: shouldNotifyDelegate
        )
    }

    private var collectionView: UICollectionView? {
        responder()
    }
}

// MARK: - Highlighted Background Color

extension UICollectionViewCell {
    @objc
    private func swizzled_isHighlightedSetter(newValue: Bool) {
        let oldValue = isHighlighted
        swizzled_isHighlightedSetter(newValue: newValue)
        guard oldValue != isHighlighted else { return }
        setHighlighted(isHighlighted, animated: true)
    }

    /// The view to which the `highlightedBackgroundColor` is applied.
    /// The default value is `contentView`.
    @objc open override var highlightedBackgroundColorView: UIView {
        contentView
    }

    /// The view to which the `highlightedAnimation` is applied.
    /// The default value is `contentView`.
    @objc open override var highlightedAnimationView: UIView {
        contentView
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
