//
//  UICollectionViewFlexBackgroundView.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 16/05/2019.
//  Copyright © 2019 Clarity Money. All rights reserved.
//

import Foundation

final class UICollectionViewFlexBackgroundView: XCCollectionReusableView {
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }

    /// The default value is `[]`.
    private var corners: UIRectCorner = [] {
        didSet {
            setNeedsLayout()
        }
    }

    /// The default value is `0`.
    private var _cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    override func commonInit() {
        super.commonInit()
        self.clipsToBounds = false
        setupShadow()
        super.backgroundColor = .clear
        backgroundColor = .clear
        corners = .allCorners
        _cornerRadius = 11
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
    }

    fileprivate func path(rect: CGRect? = nil) -> UIBezierPath {
        return UIBezierPath(roundedRect: rect ?? bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: _cornerRadius, height: _cornerRadius))
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let flexLayoutAttributes = layoutAttributes as? UICollectionViewFlexLayoutAttributes else {
            return
        }
        corners = flexLayoutAttributes.corners
        _cornerRadius = flexLayoutAttributes.cornerRadius
    }
}
