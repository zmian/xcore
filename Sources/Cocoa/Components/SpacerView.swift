//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A spacer view with optional intrinsic content size. In stack view, it can
/// act as flexible spacer view.
open class SpacerView: UIView {
    open var contentSize: CGSize = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    public convenience init() {
        self.init(frame: .zero)
        self.contentSize = .init(UIView.noIntrinsicMetric)
    }

    public convenience init(size: CGSize) {
        self.init(frame: .zero)
        self.contentSize = size
    }

    public convenience init(width: CGFloat) {
        self.init(frame: .zero)
        self.contentSize = .init(width: width, height: UIView.noIntrinsicMetric)
    }

    public convenience init(height: CGFloat) {
        self.init(frame: .zero)
        self.contentSize = .init(width: UIView.noIntrinsicMetric, height: height)
    }

    open override var intrinsicContentSize: CGSize {
        contentSize
    }
}

// MARK: - UIImageView

open class SpacerImageView: UIImageView {
    open var contentSize: CGSize = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    public convenience init() {
        self.init(frame: .zero)
        self.contentSize = .init(UIView.noIntrinsicMetric)
    }

    public convenience init(size: CGSize) {
        self.init(frame: .zero)
        self.contentSize = size
    }

    public convenience init(width: CGFloat) {
        self.init(frame: .zero)
        self.contentSize = .init(width: width, height: UIView.noIntrinsicMetric)
    }

    public convenience init(height: CGFloat) {
        self.init(frame: .zero)
        self.contentSize = .init(width: UIView.noIntrinsicMetric, height: height)
    }

    open override var intrinsicContentSize: CGSize {
        contentSize
    }
}
