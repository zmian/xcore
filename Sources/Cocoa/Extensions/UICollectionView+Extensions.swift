//
// UICollectionView+Extensions.swift
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
    /// Returns all the cells of the collection view in the given visible section.
    ///
    /// - Parameter section: The index of the section for which you want a count of the items.
    /// - Returns: The cell objects at the corresponding section or nil if the section is not visible or indexPath is out of range.
    ///
    /// - Note: Only the visible cells are returned.
    open func cells(inSection section: Int) -> [UICollectionViewCell] {
        guard section < numberOfSections else {
            return []
        }

        var cells: [UICollectionViewCell] = []

        for item in 0..<numberOfItems(inSection: section) {
            guard let cell = cellForItem(at: IndexPath(item: item, section: section)) else {
                continue
            }

            cells.append(cell)
        }

        return cells
    }

    /// Returns the first cell of the collection view that satisfies the given
    /// predicate.
    ///
    /// The following example uses the `cell(where:)` method to find the first
    /// cell of class type `PhotoCell`:
    ///
    /// ```swift
    /// if let cell = collectionView.cell(where: { $0.isKind(of: PhotoCell.self) }) {
    ///     print("Found cell of type PhotoCell.")
    /// }
    /// ```
    ///
    /// - Parameter predicate: A closure that takes a cell of the collection view as
    ///   its argument and returns a boolean value indicating whether the
    ///   element is a match.
    /// - Returns: The first cell of the collection view that satisfies `predicate`,
    ///   or `nil` if there is no cell that satisfies `predicate`.
    ///
    /// - Note: Only the visible cells are queried.
    open func cell(where predicate: (UICollectionViewCell) -> Bool) -> UICollectionViewCell? {
        for section in 0..<numberOfSections {
            for item in 0..<numberOfItems(inSection: section) {
                guard let cell = cellForItem(at: IndexPath(item: item, section: section)) else {
                    continue
                }

                if predicate(cell) {
                    return cell
                }
            }
        }

        return nil
    }

    /// Returns the first cell of the collection view that satisfies the given
    /// type `T`.
    ///
    /// ```swift
    /// if let cell = collectionView.cell(kind: PhotoCell.self) {
    ///     print("Found cell of type PhotoCell.")
    /// }
    /// ```
    ///
    /// - Parameter kind: The kind of cell to find.
    /// - Returns: The first cell of the collection view that satisfies the given,
    ///   type or `nil` if there is no cell that satisfies the type `T`.
    open func cell<T: UICollectionViewCell>(kind: T.Type) -> T? {
        return cell { $0.isKind(of: kind) } as? T
    }
}

extension UICollectionView {
    private struct AssociatedKey {
        static var cellLookupTimers = "cellLookupTimers"
    }

    private var cellLookupTimers: [String: Timer] {
        get { return associatedObject(&AssociatedKey.cellLookupTimers, default: [String: Timer]()) }
        set { setAssociatedObject(&AssociatedKey.cellLookupTimers, value: newValue) }
    }

    /// Use this method to wait for the first cell to load that that satisfies the given
    /// type `T`.
    ///
    /// ```swift
    /// collectionView.cell(kind: PhotoCell.self) { cell in
    ///     print("PhotoCell is available now.")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - kind: The kind of cell to find.
    ///   - block: The block to invoke when the first cell of the collection view that
    ///     satisfies the given type becomes available.
    ///
    /// - Note: The block will be called only once when the cell is avaiable.
    public func cell<T: UICollectionViewCell>(kind: T.Type, _ block: @escaping (T) -> Void) {
        let key = NSStringFromClass(kind)

        if let timer = cellLookupTimers[key] {
            timer.invalidate()
        }

        cellLookupTimers[key] = Timer.schedule(repeatInterval: 0.1) { [weak self] in
            guard let strongSelf = self, let cell = strongSelf.cell(kind: kind) else { return }
            block(cell)
            strongSelf.cellLookupTimers[key]?.invalidate()
        }
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
