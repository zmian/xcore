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

    private enum Priority: Float {
        case Low      = 250
        case High     = 750
        case Required = 1000 // Default priority
    }

    // MARK: Convenience Methods

    public convenience init(item view1: AnyObject, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation = .Equal, toItem view2: AnyObject? = nil, attribute attr2: NSLayoutAttribute? = nil, multiplier: CGFloat = 1, constant c: CGFloat = 0, priority: Float = Priority.Required.rawValue) {
        let attribute2 = attr2 != nil ? attr2! : attr1
        self.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attribute2, multiplier: multiplier, constant: c)
        self.priority = priority
    }

    public convenience init(item view1: AnyObject, aspectRatio: CGFloat, priority: Float = Priority.Required.rawValue) {
        self.init(item: view1, attribute: .Width, relatedBy: .Equal, toItem: view1, attribute: .Height, multiplier: aspectRatio)
        self.priority = priority
    }

    public convenience init(item view1: AnyObject, width: CGFloat, priority: Float = Priority.Required.rawValue) {
        self.init(item: view1, attribute: .Width, attribute: .NotAnAttribute, constant: width)
        self.priority = priority
    }

    public convenience init(item view1: AnyObject, height: CGFloat, priority: Float = Priority.Required.rawValue) {
        self.init(item: view1, attribute: .Height, attribute: .NotAnAttribute, constant: height)
        self.priority = priority
    }

    // MARK: Static Methods

    public static func size(viewToSize: UIView, size: CGSize, priority: Float = Priority.Required.rawValue) -> [NSLayoutConstraint] {
        viewToSize.translatesAutoresizingMaskIntoConstraints = false
        return [
            NSLayoutConstraint(item: viewToSize, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.width, priority: priority),
            NSLayoutConstraint(item: viewToSize, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.height, priority: priority)
        ]
    }

    public static func centerX(viewToCenter: UIView, superview: UIView? = nil, offset: CGFloat = 0) -> NSLayoutConstraint {
        let superview = superview ?? viewToCenter.superview
        viewToCenter.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: viewToCenter, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1, constant: offset)
    }

    public static func centerY(viewToCenter: UIView, superview: UIView? = nil, offset: CGFloat = 0) -> NSLayoutConstraint {
        let superview = superview ?? viewToCenter.superview
        viewToCenter.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: viewToCenter, attribute: .CenterY, relatedBy: .Equal, toItem: superview, attribute: .CenterY, multiplier: 1, constant: offset)
    }

    public static func centerXY(viewToCenter: UIView, superview: UIView? = nil, offset: CGPoint = CGPointZero) -> [NSLayoutConstraint] {
        let superview = superview ?? viewToCenter.superview
        viewToCenter.translatesAutoresizingMaskIntoConstraints = false

        return [
            NSLayoutConstraint(item: viewToCenter, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1, constant: offset.x),
            NSLayoutConstraint(item: viewToCenter, attribute: .CenterY, relatedBy: .Equal, toItem: superview, attribute: .CenterY, multiplier: 1, constant: offset.y)
        ]
    }

    public static func constraintsForViewToFillSuperviewHorizontal(viewToSize: UIView, paddingLeft: CGFloat = 0, paddingRight: CGFloat = 0, priority: Float = Priority.Required.rawValue) -> [NSLayoutConstraint] {
        let views = ["view": viewToSize]
        let metrics = ["priority": CGFloat(priority), "paddingLeft": paddingLeft, "paddingRight": paddingRight]
        viewToSize.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint.constraintsWithVisualFormat("H:|-paddingLeft@priority-[view]-paddingRight@priority-|", options: [], metrics: metrics, views: views)
    }

    public static func constraintsForViewToFillSuperviewVertical(viewToSize: UIView, paddingTop: CGFloat = 0, paddingBottom: CGFloat = 0, priority: Float = Priority.Required.rawValue) -> [NSLayoutConstraint] {
        let views = ["view": viewToSize]
        let metrics = ["priority": CGFloat(priority), "paddingTop": paddingTop, "paddingBottom": paddingBottom]
        viewToSize.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint.constraintsWithVisualFormat("V:|-paddingTop@priority-[view]-paddingBottom@priority-|", options: [], metrics: metrics, views: views)
    }

    public static func constraintsForViewToFillSuperview(viewToSize: UIView, padding: UIEdgeInsets = UIEdgeInsetsZero) -> [NSLayoutConstraint] {
        let views = ["view": viewToSize]
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
