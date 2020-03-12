//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class XCCollectionViewTileBackgroundView: UICollectionReusableView {
    // MARK: - Init Methods

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override class var layerClass: AnyClass {
        CAShapeLayer.self
    }

    private var shapeLayer: CAShapeLayer {
        layer as! CAShapeLayer
    }

    /// The default value is `.none, 0`.
    private var corners: (corners: UIRectCorner, radius: CGFloat) = (.none, 0) {
        didSet {
            setNeedsLayout()
        }
    }

    override var backgroundColor: UIColor? {
        get { shapeLayer.fillColor?.uiColor }
        set { shapeLayer.fillColor = newValue?.cgColor }
    }

    private func commonInit() {
        clipsToBounds = false
        setupShadow()
        super.backgroundColor = .clear
        backgroundColor = .clear
    }

    private func setupShadow() {
        layer.apply {
            $0.shadowColor = UIColor.black.cgColor
            $0.shadowOffset = CGSize(width: 0, height: 1)
            $0.shadowRadius = 1
            $0.shadowOpacity = 0.3
            $0.shadowPath = shapeLayer.path
            $0.shouldRasterize = true
            $0.rasterizationScale = UIScreen.main.scale
        }
    }

    private func path(rect: CGRect? = nil) -> UIBezierPath {
        .init(roundedRect: rect ?? bounds, byRoundingCorners: corners.corners, cornerRadii: CGSize(width: corners.radius, height: corners.radius))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let path = self.path()
        shapeLayer.path = path.cgPath
        layer.shadowPath = path.cgPath
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let tileAttributes = layoutAttributes as? XCCollectionViewTileLayout.Attributes {
            corners = tileAttributes.corners
        }
    }
}
