//
//  XCCollectionViewTileBackgroundView.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 16/05/2019.
//

import Foundation

final class XCCollectionViewTileBackgroundView: UICollectionReusableView {
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }

    /// The default value is `[], 0`.
    private var corners: (corners: UIRectCorner, radius: CGFloat) = ([], 0) {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: Init Methods

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

    func commonInit() {
        clipsToBounds = false
        setupShadow()
        super.backgroundColor = .clear
        backgroundColor = .clear
    }

    override var backgroundColor: UIColor? {
        get {
            guard let color = shapeLayer.fillColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            shapeLayer.fillColor = newValue?.cgColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let path = self.path()
        shapeLayer.path = path.cgPath
        layer.shadowPath = path.cgPath
    }

    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 1
        layer.shadowOpacity = Float(0.3)
        layer.shadowPath = shapeLayer.path
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    fileprivate func path(rect: CGRect? = nil) -> UIBezierPath {
        return UIBezierPath(roundedRect: rect ?? bounds, byRoundingCorners: corners.corners, cornerRadii: CGSize(width: corners.radius, height: corners.radius))
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let tileAttributes = layoutAttributes as? XCCollectionViewTileLayout.Attributes {
            corners = (corners: tileAttributes.corners, radius: tileAttributes.cornerRadius)
        }
    }
}
