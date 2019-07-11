//
// XCCollectionViewTileBackgroundView.swift
//
// Copyright © 2019 Xcore
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
        return CAShapeLayer.self
    }

    private var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }

    /// The default value is `.none, 0`.
    private var corners: (corners: UIRectCorner, radius: CGFloat) = (.none, 0) {
        didSet {
            setNeedsLayout()
        }
    }

    override var backgroundColor: UIColor? {
        get { return shapeLayer.fillColor?.uiColor }
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
        return UIBezierPath(roundedRect: rect ?? bounds, byRoundingCorners: corners.corners, cornerRadii: CGSize(width: corners.radius, height: corners.radius))
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
