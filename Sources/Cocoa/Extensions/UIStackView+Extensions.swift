//
// UIStackView+Extensions.swift
//
// Copyright © 2015 Xcore
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
    public func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
