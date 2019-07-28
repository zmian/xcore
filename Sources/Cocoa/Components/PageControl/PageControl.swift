//
// PageControl.swift
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
import CoreGraphics

extension PageControl {
    private struct Constants {
        static var dotSize: CGFloat { return 12 }
        static var unselectedInset: CGFloat { return 3 }
        static var lineWidth: CGFloat { return 1 }
        static var unequalSizeDotsPadding: CGFloat { return 26 }
    }
}

final public class PageControl: UIView {
    public var dotsPadding: CGFloat
    public var equalSizeDots: Bool

    @objc dynamic public var dotSize = Constants.dotSize

    /// The tint color to be used for the page indicator.
    ///
    /// The default color is a translucent white for the page indicator dot. The
    /// page indicator dot is used for all of the pages not visible on the screen.
    /// Assigning a new value to this property does not automatically change the
    /// color in the `currentPageIndicatorTintColor` property because the value for
    /// these two properties is not automatically derived from the other. Both
    /// properties must be specified independently. Similarly, no alpha is applied
    /// to this property for you. It is recommended (but not required) that the
    /// color you specify for this parameter contains some transparency – i.e. the
    /// alpha value should be less than `1.0`.
    @objc dynamic public var pageIndicatorTintColor = UIColor.white.alpha(0.5)

    /// The tint color to be used for the current page indicator.
    ///
    /// The default color is an opaque white for the current page indicator dot. The
    /// current page indicator dot is used to indicate the currently visible page.
    /// Assigning a new value to this property does not automatically change the
    /// color in the `pageIndicatorTintColor` property because the value for these
    /// two properties is not automatically derived from the other. Both properties
    /// must be specified independently.
    @objc dynamic public var currentPageIndicatorTintColor: UIColor = .white {
        didSet {
            guard oldValue != currentPageIndicatorTintColor else { return }
            updateTintColorsIfNeeded(force: true)
        }
    }

    /// A list of tint colors to be used for the each current page indicator.
    ///
    /// The default color is an opaque white for the current page indicator dot. The
    /// current page indicator dot is used to indicate the currently visible page.
    /// Assigning a new value to this property does not automatically change the
    /// color in the `pageIndicatorTintColor` property because the value for these
    /// two properties is not automatically derived from the other. Both properties
    /// must be specified independently.
    public var currentPageIndicatorTintColors = [UIColor]() {
        didSet {
            guard oldValue != currentPageIndicatorTintColors else { return }
            numberOfPages = currentPageIndicatorTintColors.count
        }
    }

    /// The number of pages the receiver shows (as dots).
    ///
    /// The value of the property is the number of pages for the page control to
    /// show as dots.
    ///
    /// The default value is `0`.
    public var numberOfPages = 0 {
        didSet {
            guard oldValue != numberOfPages else { return }
            updateTintColorsIfNeeded()
            isHidden = _internalHidden
            setNeedsDisplay()
            invalidateIntrinsicContentSize()
        }
    }

    /// The current page, shown by the receiver as a active dot.
    ///
    /// The property value is an integer specifying the current page shown minus
    /// one; thus a value of zero (the default) indicates the first page. A page
    /// control shows the current page as a white dot. Values outside the possible
    /// range are pinned to either `0` or `numberOfPages` minus `1`.
    public var currentPage = 0 {
        didSet {
            guard oldValue != currentPage else { return }
            setNeedsDisplay()
        }
    }

    /// A property to keep track of user's preference.
    ///
    /// The page control should be hidden when `numberOfPages <= 1`.
    /// However, we want this property to update as soon as number
    /// of pages update and respect user's preference.
    ///
    /// So if the user wants to hide the dots regardless of
    /// `numberOfPages` this will ensure that it works as intended.
    private var _internalHidden: Bool = false
    public override var isHidden: Bool {
        get {
            guard _internalHidden else {
                return numberOfPages <= 1
            }
            return _internalHidden
        }
        set {
            super.isHidden = isHidden
            _internalHidden = newValue
        }
    }

    public init(equalSizeDots: Bool = false, dotPadding: CGFloat? = nil) {
        self.equalSizeDots = equalSizeDots

        if let dotPadding = dotPadding {
            dotsPadding = dotPadding
        } else {
            dotsPadding = equalSizeDots ? .defaultPadding : Constants.unequalSizeDotsPadding
        }

        super.init(frame: .zero)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        equalSizeDots = false
        dotsPadding = Constants.unequalSizeDotsPadding
        super.init(coder: aDecoder)
        commonInit()
    }

    public convenience init(
        pageIndicatorTintColor: UIColor,
        currentPageIndicatorTintColors: [UIColor]
    ) {
        self.init()
        self.pageIndicatorTintColor = pageIndicatorTintColor
        self.currentPageIndicatorTintColors = currentPageIndicatorTintColors
        numberOfPages = currentPageIndicatorTintColors.count
    }

    private func commonInit() {
        backgroundColor = .clear
    }

    private func updateTintColorsIfNeeded(force: Bool = false) {
        guard force || numberOfPages != currentPageIndicatorTintColors.count else {
            return
        }

        currentPageIndicatorTintColors = numberOfPages.map { _ in
            currentPageIndicatorTintColor
        }
    }

    public override var intrinsicContentSize: CGSize {
        let height = dotSize + Constants.lineWidth
        return CGSize(width: CGFloat(numberOfPages) * dotsPadding, height: height)
    }

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.saveGState()

        let dotWidth = dotSize
        let smallDotInset = Constants.unselectedInset
        let smallDotSize = dotWidth - smallDotInset * 2
        let lineWidth = Constants.lineWidth

        let step: CGFloat = (frame.width - dotWidth - lineWidth) / CGFloat(numberOfPages - 1)
        var locationAcum: CGFloat = 0

        for i in 0..<numberOfPages {
            if i == currentPage {
                if equalSizeDots {
                    context.setFillColor(currentPageIndicatorTintColors[currentPage].cgColor)
                    context.fillEllipse(in: CGRect(x: locationAcum + smallDotInset, y: smallDotInset, width: smallDotSize, height: smallDotSize))
                } else {
                    context.setStrokeColor(currentPageIndicatorTintColors[currentPage].cgColor)
                    context.strokeEllipse(in: CGRect(x: locationAcum + lineWidth / 2, y: lineWidth / 2, width: dotWidth, height: dotWidth))
                }
            } else {
                context.setFillColor(pageIndicatorTintColor.cgColor)
                context.fillEllipse(in: CGRect(x: locationAcum + smallDotInset, y: smallDotInset, width: smallDotSize, height: smallDotSize))
            }
            locationAcum += step
        }

        context.restoreGState()
    }
}
