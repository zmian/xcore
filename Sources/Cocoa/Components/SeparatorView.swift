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
        case dot(spacing: Float)
        case dash(value: [Float])

        public static var dot: Style {
            return .dot(spacing: 1.5)
        }

        public static var dash: Style {
            return .dash(value: [2, 5])
        }
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
        set {
            guard newValue != shapeLayer.lineCap else { return }
            shapeLayer.lineCap = newValue
            updatePath()
        }
    }

    /// An option to specify custom thickness.
    ///
    /// The default value is `nil`, meaning use the default thickness for each
    /// style.
    public var thickness: CGFloat? {
        didSet {
            guard oldValue != thickness else { return }
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

    public override var bounds: CGRect {
        didSet {
            guard oldValue != bounds else { return }
            updatePath()
        }
    }

    /// - Parameters:
    ///   - style: The default value is `.plain`.
    ///   - axis: The default value is `.horizontal`.
    ///   - backgroundColor: The default value is `nil`.
    ///   - automaticallySetThickness: The default value is `true`.
    ///   - thickness: The default value is `nil`.
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
        commonInit(
            backgroundColor: backgroundColor,
            automaticallySetThickness: automaticallySetThickness,
            thickness: thickness
        )
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit(backgroundColor: UIColor? = nil, automaticallySetThickness: Bool = true, thickness: CGFloat? = nil) {
        super.backgroundColor = .clear
        self.automaticallySetThickness = automaticallySetThickness
        self.thickness = thickness
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
    }

    private func updatePath() {
        let capOffset = lineCap != .butt ? patternLineWidth / 2.0 : 0
        let lineAxisPosition = patternLineWidth / 2.0
        let origin = axis == .horizontal ? CGPoint(x: capOffset, y: lineAxisPosition) : CGPoint(x: lineAxisPosition, y: capOffset)
        let end = axis == .horizontal ? CGPoint(x: bounds.width - capOffset, y: lineAxisPosition) : CGPoint(x: lineAxisPosition, y: bounds.height - capOffset)

        let path = CGMutablePath()
        path.move(to: origin)
        path.addLine(to: end)
        shapeLayer.path = path
        shapeLayer.lineWidth = patternLineWidth
        updatePattern()
    }

    private func updatePattern() {
        switch style {
            case .plain:
                shapeLayer.lineDashPattern = nil
            case .dot(let spacing):
                shapeLayer.lineDashPattern = [
                    NSNumber(value: 0.001),
                    NSNumber(value: spacing * Float(patternLineWidth) * 2.0)
                ]
            case .dash(let value):
                shapeLayer.lineDashPattern = value.map { NSNumber(value: $0) }
        }
    }

    private var patternLineWidth: CGFloat {
        let width = axis == .horizontal ? bounds.height : bounds.width

        guard width > 0 else {
            return defaultThickness
        }

        return width
    }

    private var automaticallySetThickness = true

    private var defaultThickness: CGFloat {
        switch style {
            case .plain:
                return onePixel
            case .dash, .dot:
                return 2
        }
    }

    private var thicknessConstraint: NSLayoutConstraint?
    private func updateThicknessConstraintIfNeeded() {
        guard automaticallySetThickness else {
            thicknessConstraint?.deactivate()
            return
        }

        let thickness = self.thickness ?? defaultThickness

        func constraintBlock(_ anchor: Anchor) {
            switch axis {
                case .vertical:
                    thicknessConstraint = anchor.width.equalTo(thickness).constraints.first
                case .horizontal:
                    thicknessConstraint = anchor.height.equalTo(thickness).constraints.first
                @unknown default:
                    break
            }
        }

        if thicknessConstraint == nil {
            anchor.make(constraintBlock)
        } else {
            thicknessConstraint?.constant = thickness
        }

        thicknessConstraint?.activate()
        setNeedsLayout()
    }
}
