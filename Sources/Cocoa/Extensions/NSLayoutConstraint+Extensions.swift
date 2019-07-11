//
// NSLayoutConstraint+Extensions.swift
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

extension NSLayoutConstraint {
    /// Activates constraint.
    ///
    /// A convenience method that provides an easy way to activate constraint by
    /// setting the `active` property to `true`.
    ///
    /// Activating or deactivating the constraint calls `addConstraint:` and
    /// `removeConstraint:` on the view that is the closest common ancestor of the
    /// items managed by this constraint.
    ///
    /// Use this property instead of calling `addConstraint:` or `removeConstraint:`
    /// directly.
    ///
    /// - Returns: `self`.
    @discardableResult
    public func activate() -> NSLayoutConstraint {
        isActive = true
        return self
    }

    /// Deactivates constraint.
    ///
    /// A convenience method that provides an easy way to deactivate constraint by
    /// setting the `active` property to `false`.
    ///
    /// Activating or deactivating the constraint calls `addConstraint:` and
    /// `removeConstraint:` on the view that is the closest common ancestor of the
    /// items managed by this constraint.
    ///
    /// Use this property instead of calling `addConstraint:` or `removeConstraint:`
    /// directly.
    ///
    /// - Returns: `self`.
    @discardableResult
    public func deactivate() -> NSLayoutConstraint {
        isActive = false
        return self
    }

    /// A convenience method to set constraint priority.
    ///
    /// - Parameter value: The constraint priority.
    /// - Returns: `self`.
    @discardableResult
    public func priority(_ value: UILayoutPriority) -> NSLayoutConstraint {
        priority = value
        return self
    }

    /// A convenience method to set constraint identifier.
    ///
    /// - Parameter value: The constraint identifier.
    /// - Returns: `self`.
    @discardableResult
    public func identifier(_ value: String?) -> NSLayoutConstraint {
        identifier = value
        return self
    }
}

extension NSLayoutConstraint {
    /// Creates a new constraint with the given priority.
    ///
    /// - Parameter priority: The priority that should be set for the new constraint.
    /// - Returns: The new activated constraint with the provided `priority` value.
    @discardableResult
    func createWithPriority( _ priority: UILayoutPriority) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )
        newConstraint.priority = priority
        deactivate()
        firstItem?.removeConstraint(self)
        newConstraint.activate()
        return newConstraint
    }

    /// Creates a new constraint with the given multiplier.
    ///
    /// - Parameter multiplier: The multiplier that should be set for the new constraint.
    /// - Returns: The new activated constraint with the provided `multiplier` value.
    @discardableResult
    func createWithMultiplier( _ multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )
        deactivate()
        firstItem?.removeConstraint(self)
        newConstraint.activate()
        return newConstraint
    }
}

extension Array where Element: NSLayoutConstraint {
    /// Activates each constraint in `self`.
    ///
    /// A convenience method provides an easy way to activate a set of constraints
    /// with one call. The effect of this method is the same as setting the `active`
    /// property of each constraint to `true`.
    ///
    /// Typically, using this method is more efficient than activating each
    /// constraint individually.
    ///
    /// - Returns: `self`.
    @discardableResult
    public func activate() -> Array {
        NSLayoutConstraint.activate(self)
        return self
    }

    /// Deactivates each constraint in `self`.
    ///
    /// A convenience method that provides an easy way to deactivate a set of
    /// constraints with one call. The effect of this method is the same as setting
    /// the `active` property of each constraint to `false`.
    ///
    /// Typically, using this method is more efficient than deactivating each
    /// constraint individually.
    ///
    /// - Returns: `self`.
    @discardableResult
    public func deactivate() -> Array {
        NSLayoutConstraint.deactivate(self)
        return self
    }

    /// A convenience method to set layout priority.
    ///
    /// - Parameter value: The layout priority.
    /// - Returns: `self`.
    @discardableResult
    public func priority(_ value: UILayoutPriority) -> Array {
        forEach {
            $0.priority = value
        }
        return self
    }
}

extension NSLayoutConstraint {
    private struct AssociatedKey {
        static var anchorAttributes = "anchorAttributes"
    }

    var anchorAttributes: Anchor.Attributes? {
        get {
            guard let intValue: Int = associatedObject(&AssociatedKey.anchorAttributes) else {
                return nil
            }

            return Anchor.Attributes(rawValue: intValue)
        }
        set { setAssociatedObject(&AssociatedKey.anchorAttributes, value: newValue?.rawValue) }
    }

    func anchorAttributes(_ value: Anchor.Attributes) -> NSLayoutConstraint {
        anchorAttributes = value
        return self
    }
}

extension Array where Element: NSLayoutConstraint {
    func firstAttribute(_ value: Anchor.Attributes) -> NSLayoutConstraint? {
        return first { $0.anchorAttributes == value }
    }
}

extension Array where Element == NSLayoutConstraint.Axis {
    /// The `.vertical` and `.horizontal` `NSLayoutConstraint.Axis`.
    public static var both: [Element] {
        return [.vertical, .horizontal]
    }
}

extension UILayoutPriority {
    /// When setting `UIStackView`'s subview to hidden, it will first constrain its
    /// height to zero in order to animate it out. This can cause `Unable to
    /// simultaneously satisfy constraints` warnings.
    ///
    /// To resolve the issue, Changing constraints priority from `1000` to `999` so
    /// the `UISV-hiding` constraint can then take priority if needed.
    public static var stackViewSubview: UILayoutPriority {
        return .required - 1
    }
}
