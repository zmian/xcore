//
// NSLayoutConstraint+Convenience.swift
//
// Copyright © 2014 Zeeshan Mian
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

extension NSLayoutConstraint {
    // MARK: Convenience Methods
    public convenience init(item view1: AnyObject, attribute attr1: Attribute, relatedBy relation: Relation = .equal, toItem view2: AnyObject? = nil, attribute attr2: Attribute? = nil, multiplier: CGFloat = 1, constant c: CGFloat = 0, priority: UILayoutPriority = .required) {
        let attr2 = attr2 ?? attr1
        self.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c)
        self.priority = priority
    }

    public convenience init(item view1: AnyObject, aspectRatio: CGFloat, priority: UILayoutPriority = .required) {
        self.init(item: view1, attribute: .width, toItem: view1, attribute: .height, multiplier: aspectRatio)
        self.priority = priority
    }

    public convenience init(item view1: AnyObject, width: CGFloat, priority: UILayoutPriority = .required) {
        self.init(item: view1, attribute: .width, attribute: .notAnAttribute, constant: width)
        self.priority = priority
    }

    public convenience init(item view1: AnyObject, height: CGFloat, priority: UILayoutPriority = .required) {
        self.init(item: view1, attribute: .height, attribute: .notAnAttribute, constant: height)
        self.priority = priority
    }

    // MARK: Static Methods
    public static func size(_ viewToSize: UIView, size: CGSize, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        viewToSize.translatesAutoresizingMaskIntoConstraints = false
        return [
            NSLayoutConstraint(item: viewToSize, width: size.width, priority: priority),
            NSLayoutConstraint(item: viewToSize, height: size.height, priority: priority)
        ]
    }

    public static func centerX(_ viewToCenter: UIView, relatedBy relation: Relation = .equal, toView: UIView? = nil, offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let toView = toView ?? viewToCenter.superview
        viewToCenter.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: viewToCenter, attribute: .centerX, relatedBy: relation, toItem: toView, constant: offset, priority: priority)
    }

    public static func centerY(_ viewToCenter: UIView, relatedBy relation: Relation = .equal, toView: UIView? = nil, offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let toView = toView ?? viewToCenter.superview
        viewToCenter.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: viewToCenter, attribute: .centerY, relatedBy: relation, toItem: toView, constant: offset, priority: priority)
    }

    public static func center(_ viewToCenter: UIView, relatedBy relation: Relation = .equal, toView: UIView? = nil, offset: CGPoint = .zero, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint.centerX(viewToCenter, relatedBy: relation, toView: toView, offset: offset.x, priority: priority),
            NSLayoutConstraint.centerY(viewToCenter, relatedBy: relation, toView: toView, offset: offset.y, priority: priority)
        ]
    }

    public static func constraintsForViewToFillSuperviewHorizontal(_ viewToSize: UIView, paddingLeft: CGFloat = 0, paddingRight: CGFloat = 0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        let views = ["view": viewToSize]
        let metrics = ["priority": CGFloat(priority.rawValue), "paddingLeft": paddingLeft, "paddingRight": paddingRight]
        viewToSize.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint.constraints(withVisualFormat: "H:|-paddingLeft@priority-[view]-paddingRight@priority-|", options: [], metrics: metrics, views: views)
    }

    public static func constraintsForViewToFillSuperviewVertical(_ viewToSize: UIView, paddingTop: CGFloat = 0, paddingBottom: CGFloat = 0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        let views = ["view": viewToSize]
        let metrics = ["priority": CGFloat(priority.rawValue), "paddingTop": paddingTop, "paddingBottom": paddingBottom]
        viewToSize.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint.constraints(withVisualFormat: "V:|-paddingTop@priority-[view]-paddingBottom@priority-|", metrics: metrics, views: views)
    }

    public static func constraintsForViewToFillSuperview(_ viewToSize: UIView, padding: UIEdgeInsets = .zero, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        let views = ["view": viewToSize]
        let metrics = ["priority": CGFloat(priority.rawValue), "paddingTop": padding.top, "paddingLeft": padding.left, "paddingBottom": padding.bottom, "paddingRight": padding.right]
        viewToSize.translatesAutoresizingMaskIntoConstraints = false

        var constraints: [NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-paddingLeft@priority-[view]-paddingRight@priority-|", metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-paddingTop@priority-[view]-paddingBottom@priority-|", metrics: metrics, views: views)
        return constraints
    }

    public static func constraintsForViewToFillLayoutGuide(_ viewToSize: UIView, guide: UILayoutGuide, padding: UIEdgeInsets = .zero, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        viewToSize.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            viewToSize.topAnchor.constraint(equalTo: guide.topAnchor, constant: padding.top),
            viewToSize.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: padding.bottom),
            viewToSize.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: padding.left),
            viewToSize.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: padding.right)
        ]

        constraints.forEach {
            $0.priority = priority
        }

        return constraints
    }
}

extension UIViewController {
    public func constraintsForViewToFillSuperview(_ viewToSize: UIView, padding: UIEdgeInsets = .zero, constraintToLayoutGuideOptions: SafeAreaLayoutGuideOptions = [], priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        var constraints = NSLayoutConstraint.constraintsForViewToFillSuperviewHorizontal(viewToSize, paddingLeft: padding.left, paddingRight: padding.right, priority: priority)
        constraints += constraintsForViewToFillSuperviewVertical(viewToSize, paddingTop: padding.top, paddingBottom: padding.bottom, constraintToLayoutGuideOptions: constraintToLayoutGuideOptions, priority: priority)
        return constraints
    }

    public func constraintsForViewToFillSuperviewVertical(_ viewToSize: UIView, paddingTop: CGFloat = 0, paddingBottom: CGFloat = 0, constraintToLayoutGuideOptions: SafeAreaLayoutGuideOptions = [], priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        viewToSize.translatesAutoresizingMaskIntoConstraints = false

        let isTopLayoutGuide = constraintToLayoutGuideOptions.contains(.top)
        let isBottomLayoutGuide = constraintToLayoutGuideOptions.contains(.bottom)

        return [
            NSLayoutConstraint(
                item: viewToSize,
                attribute: .top,
                toItem: isTopLayoutGuide ? view.safeAreaLayoutGuide.topAnchor : view,
                attribute: isTopLayoutGuide ? .bottom : .top,
                constant: paddingTop,
                priority: priority
            ),
            NSLayoutConstraint(
                item: isBottomLayoutGuide ? view.safeAreaLayoutGuide.bottomAnchor : view,
                attribute: isBottomLayoutGuide ? .top : .bottom,
                toItem: viewToSize,
                attribute: .bottom,
                constant: paddingBottom,
                priority: priority
            )
        ]
    }
}
