//
// IntrinsicContentSizeView.swift
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

open class IntrinsicContentSizeView: UIView {
    open var contentSize: CGSize = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    public convenience init(intrinsicContentSize: CGSize) {
        self.init(frame: .zero)
        self.contentSize = intrinsicContentSize
    }

    open override var intrinsicContentSize: CGSize {
        contentSize
    }
}

open class IntrinsicContentSizeImageView: UIImageView {
    open var contentSize: CGSize = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    public convenience init(intrinsicContentSize: CGSize) {
        self.init(frame: .zero)
        self.contentSize = intrinsicContentSize
    }

    open override var intrinsicContentSize: CGSize {
        contentSize
    }
}

extension IntrinsicContentSizeView {
    /// A spacer view without intrinsic content size. In stack view, it can act as
    /// flexible spacer view.
    public static var spacer: IntrinsicContentSizeView {
        .init(intrinsicContentSize: .init(UIView.noIntrinsicMetric))
    }
}
