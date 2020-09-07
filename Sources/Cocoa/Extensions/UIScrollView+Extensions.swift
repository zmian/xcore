//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
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
            self == .up || self == .down
        }

        public var isHorizontal: Bool {
            self == .left || self == .right
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
        setContentOffset(
            CGPoint(x: 0, y: -adjustedContentInset.top),
            animated: animated
        )
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
