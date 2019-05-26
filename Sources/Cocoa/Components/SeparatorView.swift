//
// SeparatorView.swift
//
// Copyright © 2016 Zeeshan Mian
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
    public enum Style {
        case plain
        case dotted
    }
}

public final class SeparatorView: UIView {
    private var defaultTintColor = UIColor(hex: "DFE9F5")

    /// The default value is `.plain`.
    public var style: Style = .plain {
        didSet {
            guard oldValue != style else { return }
            setNeedsDisplay()
            updateThicknessConstraintIfNeeded()
        }
    }

    /// The default value is `.horizontal`.
    private var axis: NSLayoutConstraint.Axis = .horizontal

    private var automaticallySetThickness = true {
        didSet {
            guard oldValue != automaticallySetThickness else { return }
            updateThicknessConstraintIfNeeded()
        }
    }

    /// The default value is `1`. Only applies when the `style` is `.dotted`.
    public var numberOfPattern: CGFloat = 1

    /// The default value is `3`. Only applies when the `style` is `.dotted`.
    public var space: CGFloat = 3

    private var _backgroundColor: UIColor?
    @objc dynamic public override var backgroundColor: UIColor? {
        get { return _backgroundColor }
        set {
            guard newValue != _backgroundColor else { return }
            _backgroundColor = newValue
            setNeedsDisplay()
        }
    }

    @objc dynamic public override var tintColor: UIColor! {
        get { return backgroundColor ?? defaultTintColor }
        set { backgroundColor = newValue }
    }

    public init(
        style: Style = .plain,
        axis: NSLayoutConstraint.Axis = .horizontal,
        backgroundColor: UIColor? = nil,
        automaticallySetThickness: Bool = true
    ) {
        super.init(frame: .zero)
        self.style = style
        self.axis = axis
        self.automaticallySetThickness = automaticallySetThickness
        commonInit()
        self.backgroundColor = backgroundColor ?? defaultTintColor
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        super.backgroundColor = .clear
        backgroundColor = defaultTintColor
        updateThicknessConstraintIfNeeded()
    }

    public override func draw(_ rect: CGRect) {
        switch style {
            case .plain:
                backgroundColor?.setFill()
                UIRectFill(rect)
            case .dotted:
                let path = UIBezierPath()
                let y = rect.midY
                path.move(to: CGPoint(x: rect.height, y: y))
                path.addLine(to: CGPoint(x: rect.width, y: y))
                path.lineWidth = rect.height - 0.5

                let dashes: [CGFloat] = [0, path.lineWidth * space]
                path.setLineDash(dashes, count: dashes.count, phase: 0)
                path.lineCapStyle = .round
                backgroundColor?.setStroke()
                path.stroke()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    private var thickness: CGFloat {
        switch style {
            case .plain:
                return onePixel
            case .dotted:
                return 2
        }
    }

    private var thicknessConstraint: NSLayoutConstraint?
    private func updateThicknessConstraintIfNeeded() {
        guard automaticallySetThickness else {
            thicknessConstraint?.deactivate()
            return
        }

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
    }
}
