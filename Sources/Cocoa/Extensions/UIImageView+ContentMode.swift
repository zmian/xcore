//
// UIImageView+ContentMode.swift
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
import ObjectiveC

extension UIImageView {
    private struct AssociatedKey {
        static var isContentModeAutomaticallyAdjusted = "isContentModeAutomaticallyAdjusted"
    }

    /// A convenience property to automatically adjust content mode to be
    /// `.scaleAspectFit` if the `image` is large or `.center` when the `image` is small
    /// or same size as `self`.
    open var isContentModeAutomaticallyAdjusted: Bool {
        get { return associatedObject(&AssociatedKey.isContentModeAutomaticallyAdjusted, default: false) }
        set { setAssociatedObject(&AssociatedKey.isContentModeAutomaticallyAdjusted, value: newValue) }
    }
}

extension UIImageView {
    /// A convenience method to adjust content mode to be
    /// `.scaleAspectFit` if the image is large or `.center` when the image is small
    /// or same size as `self`.
    ///
    /// This should method will only take into effect if the frame is correct for `self`.
    private func adjustContentModeIfNeeded() {
        guard isContentModeAutomaticallyAdjusted, let image = image else {
            return
        }

        if image.size.width > bounds.size.width || image.size.height > bounds.size.height {
            contentMode = .scaleAspectFit
        } else {
            contentMode = .center
        }
    }
}

extension UIImageView {
    @objc private func swizzled_setHighlightedImage(_ image: UIImage?) {
        swizzled_setHighlightedImage(image)
        // Force update the highlighted image.
        //
        // The highlighted image doesn't change if it's changed after the
        // `isHighlighted` property is already set to `true`.
        if isHighlighted {
            isHighlighted = false
            isHighlighted = true
        }
    }
}

extension UIImageView {
    @objc private func swizzled_layoutSubviews() {
        swizzled_layoutSubviews()
        adjustContentModeIfNeeded()
    }

    @objc private func swizzled_setImage(_ image: UIImage?) {
        swizzled_setImage(image)
        adjustContentModeIfNeeded()
    }

    @objc private func swizzled_setBounds(_ bounds: CGRect) {
        swizzled_setBounds(bounds)
        adjustContentModeIfNeeded()
    }

    static func runOnceSwapSelectors() {
        swizzle(
            UIImageView.self,
            originalSelector: #selector(setter: UIImageView.bounds),
            swizzledSelector: #selector(UIImageView.swizzled_setBounds(_:))
        )

        swizzle(
            UIImageView.self,
            originalSelector: #selector(setter: UIImageView.image),
            swizzledSelector: #selector(UIImageView.swizzled_setImage(_:))
        )

        swizzle(
            UIImageView.self,
            originalSelector: #selector(UIImageView.layoutSubviews),
            swizzledSelector: #selector(UIImageView.swizzled_layoutSubviews)
        )

        swizzle(
            UIImageView.self,
            originalSelector: #selector(setter: UIImageView.highlightedImage),
            swizzledSelector: #selector(UIImageView.swizzled_setHighlightedImage(_:))
        )
    }
}
