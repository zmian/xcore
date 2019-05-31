//
// UIScrollView+Extensions.swift
//
// Copyright © 2014 Xcore
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

extension UIScrollView {
    public enum ScrollingDirection {
        case none
        case up
        case down
        case left
        case right
        case unknown

        public var isVertical: Bool {
            return self == .up || self == .down
        }

        public var isHorizontal: Bool {
            return self == .left || self == .right
        }
    }

    /// The current scrolling direction of the scroll view.
    public var currentScrollingDirection: ScrollingDirection {
        let translation = panGestureRecognizer.translation(in: superview)

        if translation.y > 0 {
            return .down
        } else if !(translation.y > 0) {
            return .up
        }

        if translation.x > 0 {
            return .right
        } else if !(translation.x > 0) {
            return .left
        }

        return .unknown
    }

    public var isScrolling: Bool {
        switch currentScrollingDirection {
            case .up, .down, .left, .right:
                return true
            case .none, .unknown:
                return false
        }
    }
}

extension UIScrollView {
    open func scrollToTop(animated: Bool) {
        setContentOffset(CGPoint(x: 0, y: -adjustedContentInset.top), animated: animated)
    }
}

extension UIScrollView {
    private final class ContentSizeResolverView: UIView {}

    /// A method to resolve scroll view content size for the given axis.
    ///
    /// - Parameters:
    ///   - axis: The axis for which to resolve the content size.
    ///   - fixedView: The view that has the size resolved.
    func resolve(axis: NSLayoutConstraint.Axis, fixedView: UIView) {
        let contentSizeResolverView = ContentSizeResolverView().apply {
            $0.isHidden = true
            addSubview($0)
        }

        switch axis {
            case .vertical:
                contentSizeResolverView.anchor.make {
                    $0.horizontally.equalToSuperview()
                    $0.top.equalTo(self)
                    $0.height.equalTo(CGFloat(1))
                    // Now the important part
                    //
                    // Setting the resolver view width to `fixedView` width correctly defines the
                    // content width of the scroll view.
                    $0.width.equalTo(fixedView)
                }
            case .horizontal:
                contentSizeResolverView.anchor.make {
                    $0.vertically.equalToSuperview()
                    $0.leading.equalTo(self)
                    $0.width.equalTo(CGFloat(1))
                    // Now the important part
                    //
                    // Setting the resolver view height to `fixedView` width correctly defines the
                    // content height of the scroll view.
                    $0.height.equalTo(fixedView)
                }
            @unknown default:
                fatalError(because: .unknownCaseDetected(axis))
        }
    }
}
