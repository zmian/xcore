//
// LinePageControl.swift
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

final public class LinePageControl: XCView {
    private let dotSize: CGFloat = 10
    private let lineSize: CGFloat = 2
    private var progressConstraint: NSLayoutConstraint?
    private let progressMask = UIView()
    private let dotsAndLinesBackgroundView = CAShapeLayer()
    private let dotsAndLinesMaskView = CAShapeLayer()
    private lazy var gradientView = CAGradientLayer().apply {
        updateGradientColors(for: $0)
        $0.startPoint = CGPoint(x: 0, y: 0.5)
        $0.endPoint = CGPoint(x: 1, y: 0.5)
    }

    private var indexCount: Int {
        return max(1, numberOfPages - 1)
    }

    private var stepSize: CGFloat {
        return (bounds.width - dotSize) / CGFloat(indexCount)
    }

    private var maskInset: CGFloat {
        return CGFloat(currentPage) * stepSize + dotSize
    }

    @objc dynamic public var fillColor: UIColor = .appleGray {
        didSet {
            guard oldValue != fillColor else { return }
            dotsAndLinesBackgroundView.fillColor = fillColor.cgColor
        }
    }

    @objc dynamic public var progressGradient: [UIColor] = [.appleTealBlue, .appleBlue] {
        didSet {
            guard oldValue != progressGradient else { return }
            updateGradientColors(for: gradientView)
        }
    }

    /// The number of pages the receiver shows (as dots).
    ///
    /// The value of the property is the number of pages for the page control to
    /// show as dots.
    ///
    /// The default value is `0`.
    public var numberOfPages: Int = 0 {
        didSet {
            _currentPage = 0
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    private var _currentPage: Int = 0
    /// The current page, shown by the receiver as a active dot.
    ///
    /// The property value is an integer specifying the current page shown minus
    /// one; thus a value of zero (the default) indicates the first page. A page
    /// control shows the current page as a white dot. Values outside the possible
    /// range are pinned to either `0` or `numberOfPages` minus `1`.
    public var currentPage: Int {
        get { return _currentPage }
        set { setCurrentPage(newValue, animated: true) }
    }

    public override func commonInit() {
        backgroundColor = .clear
        dotsAndLinesBackgroundView.fillColor = fillColor.cgColor
        dotsAndLinesBackgroundView.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(dotsAndLinesBackgroundView)

        dotsAndLinesMaskView.fillColor = UIColor.black.cgColor
        dotsAndLinesMaskView.strokeColor = UIColor.clear.cgColor
        gradientView.mask = dotsAndLinesMaskView
        progressMask.layer.addSublayer(gradientView)

        addSubview(progressMask)
        progressMask.clipsToBounds = true
        progressMask.anchor.make {
            $0.vertically.equalToSuperview()
            $0.leading.equalToSuperview()
            progressConstraint = $0.width.equalTo(CGFloat(0)).constraints.first
        }
    }

    public override var bounds: CGRect {
        didSet {
            guard oldValue != bounds else { return }
            progressConstraint?.constant = maskInset
            updateDotsAndLines(shape: dotsAndLinesBackgroundView)
            updateDotsAndLines(shape: dotsAndLinesMaskView)
            gradientView.frame = bounds
        }
    }

    public func setCurrentPage(_ page: Int, animated: Bool) {
        _currentPage = page
        progressConstraint?.constant = maskInset

        guard animated else { return }

        UIView.animateFromCurrentState {
            self.layoutIfNeeded()
        }
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 60 * CGFloat(indexCount) + dotSize, height: dotSize)
    }

    private func updateGradientColors(for gradientView: CAGradientLayer) {
        gradientView.colors = progressGradient.map { $0.cgColor }
    }

    private func updateDotsAndLines(shape: CAShapeLayer) {
        let path = CGMutablePath()
        for i in 0..<numberOfPages {
            path.addEllipse(in: CGRect(x: CGFloat(i) * stepSize, y: (bounds.height - dotSize) / 2, width: dotSize, height: dotSize))
        }
        path.addRect(CGRect(x: 0, y: (bounds.height - lineSize) / 2, width: bounds.width, height: lineSize))
        shape.path = path
    }
}
