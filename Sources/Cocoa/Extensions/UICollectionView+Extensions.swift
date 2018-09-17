//
// UICollectionView+Extensions.swift
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

extension UICollectionView {
    /// Returns an array of selected cells in the collection view.
    ///
    /// - Returns: An array of `UICollectionViewCell` objects.
    open var selectedCells: [UICollectionViewCell] {
        guard let indexPaths = indexPathsForSelectedItems else {
            return []
        }

        return indexPaths.compactMap(cellForItem)
    }
}

extension UICollectionView {
    /// Selects the item at the specified index path and optionally scrolls it into view.
    ///
    /// If the `allowsSelection` property is `false`, calling this method has no effect.
    /// If there is an existing selection with a different index path and the `allowsMultipleSelection`
    /// property is `false`, calling this method replaces the previous selection.
    ///
    /// This method can cause selection-related delegate methods to be called based on the
    /// `shouldNotifyDelegate` parameter value.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the item to select.
    ///   - animated: Specify `true` to animate the change in the selection or `false` to make the change without animating it.
    ///   - scrollPosition: An option that specifies where the item should be positioned when scrolling finishes. For a list of possible values, see `UICollectionViewScrollPosition`.
    ///   - shouldNotifyDelegate: An option to specify whether the delegate methods to be called.
    @objc open func selectItem(at indexPath: IndexPath, animated: Bool, scrollPosition: ScrollPosition, shouldNotifyDelegate: Bool) {
        guard shouldNotifyDelegate else {
            return selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        }

        guard allowsSelection, let delegate = delegate else {
            return
        }

        // Ask the delegate method if selection for the given index path is allowed.
        // If the delegate method for `shouldSelectItemAt` is not implemented the default value is `true`.
        let shouldSelect = delegate.collectionView?(self, shouldSelectItemAt: indexPath) ?? true

        guard shouldSelect else {
            return
        }

        selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        delegate.collectionView?(self, didSelectItemAt: indexPath)
    }

    /// Deselects the item at the specified index.
    ///
    /// If the `allowsSelection` property is `false`, calling this method has no effect.
    ///
    /// This method can cause selection-related delegate methods to be called based on the
    /// `shouldNotifyDelegate` parameter value.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the item to deselect.
    ///   - animated: Specify `true` to animate the change in the selection or `false` to make the change without animating it.
    ///   - shouldNotifyDelegate: An option to specify whether the delegate methods to be called.
    @objc open func deselectItem(at indexPath: IndexPath, animated: Bool, shouldNotifyDelegate: Bool) {
        guard shouldNotifyDelegate else {
            return deselectItem(at: indexPath, animated: animated)
        }

        guard allowsSelection, let delegate = delegate else {
            return
        }

        // Ask the delegate method if deselection for the given index path is allowed.
        // If the delegate method for `shouldDeselectItemAt` is not implemented the default value is `true`.
        let shouldDeselect = delegate.collectionView?(self, shouldDeselectItemAt: indexPath) ?? true

        guard shouldDeselect else {
            return
        }

        deselectItem(at: indexPath, animated: animated)
        delegate.collectionView?(self, didDeselectItemAt: indexPath)
    }
}
