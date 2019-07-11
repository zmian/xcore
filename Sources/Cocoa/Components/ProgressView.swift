//
// ProgressView.swift
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

final public class ProgressView: XCView {
    private var heightConstraint: NSLayoutConstraint?
    private let progressLayer = CAShapeLayer()

    @objc dynamic public var progressTintColor: UIColor = .white {
        didSet {
            progressLayer.strokeColor = progressTintColor.cgColor
        }
    }

    @objc dynamic public var fillHeight: CGFloat = 1 {
        didSet {
            heightConstraint?.constant = fillHeight
        }
    }

    @objc dynamic public var progressHeight: CGFloat = 2 {
        didSet {
            progressLayer.lineWidth = progressHeight
        }
    }

    public override var isHidden: Bool {
        didSet {
            setupAnimation()
        }
    }

    public override func commonInit() {
        layer.addSublayer(progressLayer)
        progressLayer.strokeColor = progressTintColor.cgColor
        progressLayer.lineWidth = progressHeight
        backgroundColor = progressTintColor.alpha(progressTintColor.alpha * 0.2)
        anchor.make {
            heightConstraint = $0.height.equalTo(fillHeight).constraints.first
        }
        setupAnimation()
    }

    private func setupAnimation() {
        progressLayer.removeAllAnimations()
        let animation = CABasicAnimation(keyPath: "strokeEnd").apply {
            $0.fromValue = 0
            $0.toValue = 1
            $0.repeatCount = .greatestFiniteMagnitude
            $0.isRemovedOnCompletion = false
            $0.duration = 3
        }
        progressLayer.add(animation, forKey: "progress")
    }

    private func setupPath() {
        let path = CGMutablePath()
        let y = progressHeight / 2
        path.move(to: CGPoint(x: 0, y: y))
        path.addLine(to: CGPoint(x: bounds.width, y: y))
        progressLayer.path = path
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        progressLayer.frame = bounds
        setupPath()
    }
}
