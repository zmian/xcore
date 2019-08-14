//
// XCCollectionReusableView.swift
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

open class XCCollectionReusableView: UICollectionReusableView {
    private var didTap: (() -> Void)?

    // MARK: - Highlighted Background Color

    open var isHighlighted = false

    @objc open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        isHighlighted = highlighted
        super.setHighlighted(highlighted, animated: animated)
    }

    // MARK: - Init Methods

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Setup Methods

    /// The default implementation of this method does nothing.
    ///
    /// Subclasses can override it to perform additional actions, for example, add
    /// new subviews or configure properties. This method is called when `self` is
    /// initialized using any of the relevant `init` methods.
    open func commonInit() {}

    /// A boolean value that indicates whether the cell resist dimming its content
    /// view.
    ///
    /// The default value is `false`.
    open var resistsDimming: Bool {
        return false
    }

    open override var layer: CALayer {
        let layer = super.layer
        // Fixes an issue where scrollbar would appear below header views.
        layer.zPosition = 0
        return layer
    }

    /// The default value is `.none, 0`.
    private var corners: (corners: UIRectCorner, radius: CGFloat) = (.none, 0) {
        didSet {
            setNeedsLayout()
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners.corners, radius: corners.radius)
    }
}

// MARK: - Touches

extension XCCollectionReusableView {
    open func triggerDidTap() {
        didTap?()
    }

    open func didTap(_ callback: (() -> Void)?) {
        didTap = callback
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        didTap?()
    }
}

// MARK: Custom Layout - Dim - Flex Layout

extension XCCollectionReusableView {
    @objc open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = layoutAttributes
        if let flowAttributes = attributes as? XCCollectionViewFlowLayout.Attributes {
            flowAttributes.alpha = (flowAttributes.shouldDim && !resistsDimming) ? 0.5 : 1
            alpha = attributes.alpha
        }

        if let tileAttributes = attributes as? XCCollectionViewTileLayout.Attributes, tileAttributes.isAutosizeEnabled {
            let size = super.systemLayoutSizeFitting(
                attributes.size,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            attributes.frame.size = size
        }
        return attributes
    }

    @objc open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let layoutAttributes = layoutAttributes as? XCCollectionViewFlowLayout.Attributes {
            alpha = (layoutAttributes.shouldDim && !resistsDimming) ? 0.5 : 1
        }

        if let tileAttributes = layoutAttributes as? XCCollectionViewTileLayout.Attributes {
            corners = tileAttributes.corners
        }
    }
}
