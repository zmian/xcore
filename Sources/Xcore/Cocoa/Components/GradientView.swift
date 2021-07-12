//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import CoreGraphics

// MARK: - GradientView

open class GradientView: UIView {
    private let gradientLayer = GradientLayer()

    // MARK: - Init Methods

    public required init() {
        super.init(frame: .zero)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    /// The style of gradient.
    ///
    /// The default value is `.axial`.
    open var type: CAGradientLayerType {
        get { gradientLayer.type }
        set { gradientLayer.type = newValue }
    }

    /// An optional array of `Double` defining the location of each gradient stop.
    /// This property is animatable.
    ///
    /// The gradient stops are specified as values between `0` and `1`. The values
    /// must be monotonically increasing. If `nil`, the stops are spread uniformly
    /// across the range.
    ///
    /// The default value is `nil`.
    ///
    /// When rendered, the colors are mapped to the output color space before being
    /// interpolated.
    open var locations: [Double]? {
        get { gradientLayer.locations }
        set { gradientLayer.locations = newValue }
    }

    /// An array of `UIColor` objects defining the color of each gradient stop.
    ///
    /// This property is animatable.
    open var colors: [UIColor] {
        get { gradientLayer.colors }
        set { gradientLayer.colors = newValue }
    }

    /// The direction of the gradient when drawn in the layer’s coordinate space.
    ///
    /// This property is animatable.
    ///
    /// The default value is `.topToBottom`.
    open var direction: GradientDirection {
        get { gradientLayer.direction }
        set { gradientLayer.direction = newValue }
    }

    // MARK: - Setup Methods

    /// Subclasses can override it to perform additional actions, for example, add
    /// new subviews or configure properties. This method is called when `self` is
    /// initialized using any of the relevant `init` methods.
    open func commonInit() {
        layer.addSublayer(gradientLayer)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.performWithoutAnimation {
            gradientLayer.frame = bounds
        }
    }

    public func setColors(_ colors: [UIColor], animated: Bool) {
        guard !animated else {
            self.colors = colors
            return
        }

        CATransaction.performWithoutAnimation {
            self.colors = colors
        }
    }
}

// MARK: - GradientLayer

open class GradientLayer: CALayer {
    private let gradient = CAGradientLayer()

    /// The style of gradient drawn by the layer.
    ///
    /// The default value is `.axial`.
    open var type: CAGradientLayerType = .axial {
        didSet {
            gradient.type = type
        }
    }

    /// An optional array of `Double` defining the location of each gradient stop.
    /// This property is animatable.
    ///
    /// The gradient stops are specified as values between `0` and `1`. The values
    /// must be monotonically increasing. If `nil`, the stops are spread uniformly
    /// across the range.
    ///
    /// The default value is `nil`.
    ///
    /// When rendered, the colors are mapped to the output color space before being
    /// interpolated.
    open var locations: [Double]? {
        didSet {
            guard let locations = locations else {
                gradient.locations = nil
                return
            }

            gradient.locations = locations.map {
                NSNumber(value: $0)
            }
        }
    }

    /// An array of `UIColor` objects defining the color of each gradient stop.
    ///
    /// This property is animatable.
    open var colors: [UIColor] = [] {
        didSet {
            // If only color is assigned. Then fill by using the same color. So it works as
            // expected.
            if colors.count == 1 {
                colors = [colors[0], colors[0]]
            }

            gradient.colors = colors.map(\.cgColor)
        }
    }

    /// The direction of the gradient when drawn in the layer’s coordinate space.
    ///
    /// This property is animatable.
    ///
    /// The default value is `.topToBottom`.
    open var direction: GradientDirection = .topToBottom {
        didSet {
            updateGradient(direction: direction)
        }
    }

    public override init() {
        super.init()
        commonInit()
    }

    public override init(layer: Any) {
        super.init(layer: layer)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {
        addSublayer(gradient)
        updateGradient(direction: direction)
    }

    open override func layoutSublayers() {
        super.layoutSublayers()
        CATransaction.performWithoutAnimation {
            gradient.frame = frame
        }
    }

    private func updateGradient(direction: GradientDirection) {
        (gradient.startPoint, gradient.endPoint) = direction.points
    }
}

// MARK: - GradientDirection

public enum GradientDirection {
    case topToBottom
    case bottomToTop
    case leftToRight
    case rightToLeft
    case topLeftToBottomRight
    case topRightToBottomLeft
    case bottomLeftToTopRight
    case bottomRightToTopLeft
    case custom(start: CGPoint, end: CGPoint)

    public var points: (start: CGPoint, end: CGPoint) {
        switch self {
            case .topToBottom:
                return (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
            case .bottomToTop:
                return (CGPoint(x: 0.5, y: 1.0), CGPoint(x: 0.5, y: 0.0))
            case .leftToRight:
                return (CGPoint(x: 1.0, y: 0.5), CGPoint(x: 0.0, y: 0.5))
            case .rightToLeft:
                return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
            case .topLeftToBottomRight:
                return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
            case .topRightToBottomLeft:
                return (CGPoint(x: 1.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
            case .bottomLeftToTopRight:
                return (CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0))
            case .bottomRightToTopLeft:
                return (CGPoint(x: 1.0, y: 1.0), CGPoint(x: 0.0, y: 0.0))
            case let .custom(start, end):
                return (start, end)
        }
    }
}
