//
// NSLayoutConstraintExtensions.swift
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

public extension NSLayoutConstraint {

    // MARK: Convenience Methods

    public convenience init(item view1: AnyObject, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation = .Equal, toItem view2: AnyObject? = nil, attribute attr2: NSLayoutAttribute? = nil, multiplier: CGFloat = 1, constant c: CGFloat = 0, priority: Float = UILayoutPriorityRequired) {
        let attr2 = attr2 ?? attr1
        self.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c)
        self.priority = priority
    }

    public convenience init(item view1: AnyObject, aspectRatio: CGFloat, priority: Float = UILayoutPriorityRequired) {
        self.init(item: view1, attribute: .Width, toItem: view1, attribute: .Height, multiplier: aspectRatio)
        self.priority = priority
    }

    public convenience init(item view1: AnyObject, width: CGFloat, priority: Float = UILayoutPriorityRequired) {
        self.init(item: view1, attribute: .Width, attribute: .NotAnAttribute, constant: width)
        self.priority = priority
    }

    public convenience init(item view1: AnyObject, height: CGFloat, priority: Float = UILayoutPriorityRequired) {
        self.init(item: view1, attribute: .Height, attribute: .NotAnAttribute, constant: height)
        self.priority = priority
    }

    // MARK: Static Methods

    public static func size(viewToSize: UIView, size: CGSize, priority: Float = UILayoutPriorityRequired) -> [NSLayoutConstraint] {
        viewToSize.translatesAutoresizingMaskIntoConstraints = false
        return [
            NSLayoutConstraint(item: viewToSize, width: size.width, priority: priority),
            NSLayoutConstraint(item: viewToSize, height: size.height, priority: priority)
        ]
    }

    public static func centerX(viewToCenter: UIView, toView: UIView? = nil, offset: CGFloat = 0, priority: Float = UILayoutPriorityRequired) -> NSLayoutConstraint {
        let toView = toView ?? viewToCenter.superview
        viewToCenter.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: viewToCenter, attribute: .CenterX, toItem: toView, constant: offset, priority: priority)
    }

    public static func centerY(viewToCenter: UIView, toView: UIView? = nil, offset: CGFloat = 0, priority: Float = UILayoutPriorityRequired) -> NSLayoutConstraint {
        let toView = toView ?? viewToCenter.superview
        viewToCenter.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: viewToCenter, attribute: .CenterY, toItem: toView, constant: offset, priority: priority)
    }

    public static func centerXY(viewToCenter: UIView, toView: UIView? = nil, offset: CGPoint = .zero, priority: Float = UILayoutPriorityRequired) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint.centerX(viewToCenter, toView: toView, offset: offset.x, priority: priority),
            NSLayoutConstraint.centerY(viewToCenter, toView: toView, offset: offset.y, priority: priority)
        ]
    }

    public static func constraintsForViewToFillSuperviewHorizontal(viewToSize: UIView, paddingLeft: CGFloat = 0, paddingRight: CGFloat = 0, priority: Float = UILayoutPriorityRequired) -> [NSLayoutConstraint] {
        let views   = ["view": viewToSize]
        let metrics = ["priority": CGFloat(priority), "paddingLeft": paddingLeft, "paddingRight": paddingRight]
        viewToSize.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint.constraintsWithVisualFormat("H:|-paddingLeft@priority-[view]-paddingRight@priority-|", options: [], metrics: metrics, views: views)
    }

    public static func constraintsForViewToFillSuperviewVertical(viewToSize: UIView, paddingTop: CGFloat = 0, paddingBottom: CGFloat = 0, priority: Float = UILayoutPriorityRequired) -> [NSLayoutConstraint] {
        let views   = ["view": viewToSize]
        let metrics = ["priority": CGFloat(priority), "paddingTop": paddingTop, "paddingBottom": paddingBottom]
        viewToSize.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint.constraintsWithVisualFormat("V:|-paddingTop@priority-[view]-paddingBottom@priority-|", options: [], metrics: metrics, views: views)
    }

    public static func constraintsForViewToFillSuperview(viewToSize: UIView, padding: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        let views   = ["view": viewToSize]
        let metrics = ["paddingTop": padding.top, "paddingLeft": padding.left, "paddingBottom": padding.bottom, "paddingRight": padding.right]
        viewToSize.translatesAutoresizingMaskIntoConstraints = false

        var constraints: [NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-paddingLeft-[view]-paddingRight-|", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-paddingTop-[view]-paddingBottom-|", options: [], metrics: metrics, views: views)
        return constraints
    }
}

public extension NSLayoutConstraint {
    /// Activates constraint.
    ///
    /// This is a convenience method that provides an easy way to activate constraint by setting the `active` property to `true`.
    ///
    /// Activating or deactivating the constraint calls `addConstraint:` and `removeConstraint:` on the view
    /// that is the closest common ancestor of the items managed by this constraint.
    /// Use this property instead of calling `addConstraint:` or `removeConstraint:` directly.
    ///
    /// - returns: `self`
    public func activate() -> NSLayoutConstraint {
        active = true
        return self
    }

    /// Deactivates constraint.
    ///
    /// This is a convenience method that provides an easy way to deactivate constraint by setting the `active` property to `false`.
    ///
    /// Activating or deactivating the constraint calls `addConstraint:` and `removeConstraint:` on the view
    /// that is the closest common ancestor of the items managed by this constraint.
    /// Use this property instead of calling `addConstraint:` or `removeConstraint:` directly.
    ///
    /// - returns: `self`
    public func deactivate() -> NSLayoutConstraint {
        active = false
        return self
    }
}

public extension Array where Element: NSLayoutConstraint {
    /// Activates each constraint in `self`.
    ///
    /// This convenience method provides an easy way to activate a set of constraints with one call.
    /// The effect of this method is the same as setting the `active` property of each constraint to `true`.
    /// Typically, using this method is more efficient than activating each constraint individually.
    ///
    /// - returns: `self`
    public func activate() -> Array {
        NSLayoutConstraint.activateConstraints(self)
        return self
    }

    /// Deactivates each constraint in `self`.
    ///
    /// This is a convenience method that provides an easy way to deactivate a set of constraints with one call.
    /// The effect of this method is the same as setting the `active` property of each constraint to `false`.
    /// Typically, using this method is more efficient than deactivating each constraint individually.
    ///
    /// - returns: `self`
    public func deactivate() -> Array {
        NSLayoutConstraint.deactivateConstraints(self)
        return self
    }
}
