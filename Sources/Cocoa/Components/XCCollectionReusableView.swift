//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
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
        false
    }

    open override var layer: CALayer {
        let layer = super.layer
        // Fixes an issue where scrollbar would appear below header views.
        layer.zPosition = 0
        return layer
    }

    /// The default value is `.none, 0`.
    private var corners: (mask: CACornerMask, radius: CGFloat) = (.none, 0) {
        didSet {
            setNeedsLayout()
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners.mask, radius: corners.radius)
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
    @objc open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let layoutAttributes = layoutAttributes as? XCCollectionViewFlowLayout.Attributes {
            alpha = (layoutAttributes.shouldDim && !resistsDimming) ? 0.5 : 1
        }

        if let tileAttributes = layoutAttributes as? XCCollectionViewTileLayout.Attributes {
            corners = tileAttributes.corners
            alpha = tileAttributes.alpha
            if tileAttributes.shouldDim && !resistsDimming {
                alpha *= 0.5
            }
        }
    }
}
