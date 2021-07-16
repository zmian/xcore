//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension SeparatorView {
    public enum Style: Equatable {
        case plain
        case dot(spacing: Float)
        case dash(value: [Float])

        public static var dot: Self {
            .dot(spacing: 1.5)
        }

        public static var dash: Self {
            .dash(value: [2, 5])
        }
    }
}

public final class SeparatorView: UIView {
    public override class var layerClass: AnyClass {
        CAShapeLayer.self
    }

    private var shapeLayer: CAShapeLayer {
        layer as! CAShapeLayer
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
        get { shapeLayer.lineCap }
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

    @objc public override dynamic var backgroundColor: UIColor? {
        get { _backgroundColor ?? Theme.separatorColor }
        set { _backgroundColor = newValue }
    }

    @objc public override dynamic var tintColor: UIColor! {
        get { backgroundColor }
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

    private func commonInit(
        backgroundColor: UIColor? = nil,
        automaticallySetThickness: Bool = true,
        thickness: CGFloat? = nil
    ) {
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

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            shapeLayer.strokeColor = backgroundColor?.cgColor
        }
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
            case let .dot(spacing):
                shapeLayer.lineDashPattern = [
                    NSNumber(value: 0.001),
                    NSNumber(value: spacing * Float(patternLineWidth) * 2.0)
                ]
            case let .dash(value):
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
