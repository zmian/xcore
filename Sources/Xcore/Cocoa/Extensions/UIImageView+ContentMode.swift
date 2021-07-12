//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - isContentModeAutomaticallyAdjusted

extension UIImageView {
    private enum AssociatedKey {
        static var isContentModeAutomaticallyAdjusted = "isContentModeAutomaticallyAdjusted"
    }

    /// A convenience property to automatically adjust content mode to be
    /// `.scaleAspectFit` if the `image` is large or `.center` when the `image` is small
    /// or same size as `self`.
    open var isContentModeAutomaticallyAdjusted: Bool {
        get { associatedObject(&AssociatedKey.isContentModeAutomaticallyAdjusted, default: false) }
        set { setAssociatedObject(&AssociatedKey.isContentModeAutomaticallyAdjusted, value: newValue) }
    }
}

extension UIImageView {
    /// A convenience method to adjust content mode to be `.scaleAspectFit` if the
    /// image is large or `.center` when the image is small or same size as `self`.
    ///
    /// This should method will only take into effect if the frame is correct for
    /// `self`.
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

// MARK: - Swizzle

extension UIImageView {
    @objc
    private func swizzled_setHighlightedImage(_ image: UIImage?) {
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

    // `AdjustContentModeIfNeeded` related swizzle calls.

    @objc
    private func swizzled_layoutSubviews() {
        swizzled_layoutSubviews()
        adjustContentModeIfNeeded()
    }

    @objc
    private func swizzled_setImage(_ image: UIImage?) {
        swizzled_setImage(image)
        adjustContentModeIfNeeded()
    }

    @objc
    private func swizzled_setBounds(_ bounds: CGRect) {
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
