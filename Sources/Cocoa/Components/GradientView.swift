//
// GradientView.swift
//
// Copyright © 2017 Xcore
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
import CoreGraphics

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
    /// The default value is `.axial`.
    open var type: CAGradientLayerType {
        get { return gradientLayer.type }
        set { gradientLayer.type = newValue }
    }

    /// An optional array of `Double` defining the location of each gradient stop.
    /// This property is animatable.
    ///
    /// The gradient stops are specified as values between `0` and `1`. The values must be
    /// monotonically increasing. If `nil`, the stops are spread uniformly across the range.
    /// The default value is `nil`.
    ///
    /// When rendered, the colors are mapped to the output color space before being
    /// interpolated.
    open var locations: [Double]? {
        get { return gradientLayer.locations }
        set { gradientLayer.locations = newValue }
    }

    /// An array of `UIColor` objects defining the color of each gradient stop.
    /// This property is animatable.
    open var colors: [UIColor] {
        get { return gradientLayer.colors }
        set { gradientLayer.colors = newValue }
    }

    /// The direction of the gradient when drawn in the layer’s coordinate space.
    /// This property is animatable.
    ///
    /// The default value is `.topToBottom`.
    open var direction: GradientDirection {
        get { return gradientLayer.direction }
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

open class GradientLayer: CALayer {
    private let gradient = CAGradientLayer()

    /// The style of gradient drawn by the layer.
    /// The default value is `.axial`.
    open var type: CAGradientLayerType = .axial {
        didSet {
            gradient.type = type
        }
    }

    /// An optional array of `Double` defining the location of each gradient stop.
    /// This property is animatable.
    ///
    /// The gradient stops are specified as values between `0` and `1`. The values must be
    /// monotonically increasing. If `nil`, the stops are spread uniformly across the range.
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
    /// This property is animatable.
    open var colors: [UIColor] = [] {
        didSet {
            gradient.colors = colors.map { $0.cgColor }
        }
    }

    /// The direction of the gradient when drawn in the layer’s coordinate space.
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
            case .custom(let (start, end)):
                return (start, end)
        }
    }
}
