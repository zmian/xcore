//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIStackView {
    /// Moves the provided view to the array of arranged subviews at the specified index.
    ///
    /// If index is already occupied, the stack view increases the size of the `arrangedSubviews`
    /// array and shifts all of its contents at the index and above to the next higher space in the
    /// array. Then the stack view stores the provided view at the `index`.
    ///
    /// The stack view also ensures that the `arrangedSubviews` array is always a subset of its
    /// subviews array. This method automatically adds the provided view as a subview of the stack
    /// view, if it is not already. When adding subviews, the stack view appends the view to the end
    /// of its subviews array. The index only affects the order of views in the `arrangedSubviews`
    /// array. It does not affect the ordering of views in the subviews array.
    ///
    /// - Parameters:
    ///   - view: The view to be moved from the array of views arranged by the stack.
    ///   - stackIndex: The index where the stack moves the new view in its `arrangedSubviews` array.
    ///                 This value must not be greater than the number of views currently in this array.
    ///                 If the index is out of bounds, this method throws an `internalInconsistencyException`
    ///                 exception.
    open func moveArrangedSubview(_ view: UIView, at stackIndex: Int) {
        guard arrangedSubviews.at(stackIndex) != view else { return }
        _moveArrangedSubview(view, at: stackIndex)
    }

    open func moveArrangedSubview(_ view: UIView, after arrangedSubview: UIView) {
        guard let index = arrangedSubviews.firstIndex(of: arrangedSubview) else { return }
        _moveArrangedSubview(view, at: index)
    }

    open func moveArrangedSubview(_ view: UIView, before arrangedSubview: UIView) {
        guard let index = arrangedSubviews.firstIndex(of: arrangedSubview) else { return }
        _moveArrangedSubview(view, at: index - 1)
    }

    private func _moveArrangedSubview(_ view: UIView, at index: Int) {
        let insertionIndex = index.clamped(to: 0...arrangedSubviews.count - 1)
        removeArrangedSubview(view)
        insertArrangedSubview(view, at: insertionIndex)
    }
}

extension UIStackView {
    /// Adds the list of views to the end of the `arrangedSubviews` array.
    ///
    /// - Parameter subviews: The views to be added to the array of views arranged
    ///                       by the stack view.
    public func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach {
            addArrangedSubview($0)
        }
    }
}

extension UIStackView {
    public func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
