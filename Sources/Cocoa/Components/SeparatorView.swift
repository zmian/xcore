//
// SeparatorView.swift
//
// Copyright © 2016 Xcore
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

extension SeparatorView {
    public enum Style: Equatable {
        case plain
        case dotted
        case dash(value: [Int])
    }
}

final public class SeparatorView: UIView {
    public override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    private var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }

    /// The default value is `.plain`.
    public var style: Style = .plain {
        didSet {
            guard oldValue != style else { return }
            updateThicknessConstraintIfNeeded()
            updatePattern()
        }
    }

    public var lineCap: CAShapeLayerLineCap {
        get { return shapeLayer.lineCap }
        set { shapeLayer.lineCap = newValue }
    }

    public var automaticThickness: CGFloat? {
        didSet {
            guard automaticThickness != oldValue else { return }
            updateThicknessConstraintIfNeeded()
        }
    }

    /// The default value is `.horizontal`.
    private var axis: NSLayoutConstraint.Axis = .horizontal

    private var _backgroundColor: UIColor? {
        didSet {
            guard oldValue != _backgroundColor else { return }
            shapeLayer.strokeColor = backgroundColor?.cgColor
        }
    }

    @objc public dynamic override var backgroundColor: UIColor? {
        get { return _backgroundColor ?? .appSeparator }
        set { _backgroundColor = newValue }
    }

    @objc public dynamic override var tintColor: UIColor! {
        get { return backgroundColor }
        set { backgroundColor = newValue }
    }

    // MARK: - Appearence properties

    @objc public dynamic var dottedSpacing: Int = 3 {
        didSet {
            updatePattern()
        }
    }

    public override var bounds: CGRect {
        didSet {
            guard oldValue != bounds else { return }
            updatePath()
        }
    }

    public init(
        style: Style = .plain,
        axis: NSLayoutConstraint.Axis = .horizontal,
        backgroundColor: UIColor? = nil,
        automaticallySetThickness: Bool = true,
        thickness: CGFloat? = nil
    ) {
        super.init(frame: .zero)
        self.style = style
        self.axis = axis
        commonInit(automaticallySetThickness: automaticallySetThickness, backgroundColor: backgroundColor, thickness: thickness)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit(automaticallySetThickness: Bool = true, backgroundColor: UIColor? = nil, thickness: CGFloat? = nil) {
        super.backgroundColor = .clear
        automaticThickness = automaticallySetThickness ? (thickness ?? defaultThickness) : nil
        updateThicknessConstraintIfNeeded()
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
            // This ensures that UIAppearance proxy correctly works when
            // `SeparatorView.appearance().tintColor` is used instead of
            // `SeparatorView.appearance().backgroundColor`.
            self.tintColor = backgroundColor
        }
        shapeLayer.strokeColor = self.backgroundColor?.cgColor
        lineCap = .round
        updatePattern()
    }

    private func updatePath() {
        let path = CGMutablePath()
        let origin = axis == .horizontal ? CGPoint(x: 0, y: bounds.midY) : CGPoint(x: bounds.midX, y: 0)
        let end = axis == .horizontal ? CGPoint(x: bounds.width, y: bounds.midY) : CGPoint(x: bounds.midX, y: bounds.height)
        path.move(to: origin)
        path.addLine(to: end)
        shapeLayer.path = path
        shapeLayer.lineWidth = (axis == .horizontal ? bounds.height : bounds.width) / 2.0
    }

    private func updatePattern() {
        switch style {
            case .plain:
                shapeLayer.lineDashPattern = nil
            case .dotted:
                shapeLayer.lineDashPattern = [
                    NSNumber(value: 0),
                    NSNumber(value: dottedSpacing)
                ]
            case .dash(let value):
                shapeLayer.lineDashPattern = value.map { NSNumber(value: $0) }
        }
    }

    private var defaultThickness: CGFloat {
        switch style {
            case .plain:
                return onePixel
            case .dotted, .dash:
                return 2
        }
    }

    private var thicknessConstraint: NSLayoutConstraint?
    private func updateThicknessConstraintIfNeeded() {
        guard let automaticThickness = automaticThickness else {
            thicknessConstraint?.deactivate()
            return
        }

        func constraintBlock(_ anchor: Anchor) {
            switch axis {
                case .vertical:
                    thicknessConstraint = anchor.width.equalTo(automaticThickness).constraints.first
                case .horizontal:
                    thicknessConstraint = anchor.height.equalTo(automaticThickness).constraints.first
                @unknown default:
                    break
            }
        }

        if thicknessConstraint == nil {
            anchor.make(constraintBlock)
        } else {
            thicknessConstraint?.constant = automaticThickness
        }

        thicknessConstraint?.activate()
        setNeedsLayout()
    }
}
