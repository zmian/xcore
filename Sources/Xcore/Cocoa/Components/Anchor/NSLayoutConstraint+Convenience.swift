//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension NSLayoutConstraint {
    convenience init(item view1: AnyObject, attribute attr1: Attribute, relatedBy relation: Relation = .equal, toItem view2: AnyObject? = nil, attribute attr2: Attribute? = nil, multiplier: CGFloat = 1, constant c: CGFloat = 0, priority: UILayoutPriority = .required) {
        let attr2 = attr2 ?? attr1
        self.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c)
        self.priority = priority
    }

    convenience init(item view1: AnyObject, aspectRatio: CGFloat, priority: UILayoutPriority = .required) {
        self.init(item: view1, attribute: .width, toItem: view1, attribute: .height, multiplier: aspectRatio)
        self.priority = priority
    }

    convenience init(item view1: AnyObject, height: CGFloat, priority: UILayoutPriority = .required) {
        self.init(item: view1, attribute: .height, attribute: .notAnAttribute, constant: height)
        self.priority = priority
    }
}

extension NSLayoutAnchor {
    @objc
    func constraint(_ relation: NSLayoutConstraint.Relation, anchor: NSLayoutAnchor) -> NSLayoutConstraint {
        switch relation {
            case .equal:
                return constraint(equalTo: anchor)
            case .lessThanOrEqual:
                return constraint(lessThanOrEqualTo: anchor)
            case .greaterThanOrEqual:
                return constraint(greaterThanOrEqualTo: anchor)
            @unknown default:
                fatalError(because: .unknownCaseDetected(relation))
        }
    }
}

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
    func activate() -> NSLayoutConstraint {
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
    func deactivate() -> NSLayoutConstraint {
        isActive = false
        return self
    }

    /// A convenience method to set constraint identifier.
    ///
    /// - Parameter value: The constraint identifier.
    /// - Returns: `self`.
    @discardableResult
    func identifier(_ value: String?) -> NSLayoutConstraint {
        identifier = value
        return self
    }
}

extension NSLayoutConstraint {
    /// Creates a new constraint with the given priority.
    ///
    /// - Parameter priority: The priority that should be set for the new
    ///   constraint.
    /// - Returns: The new activated constraint with the provided `priority` value.
    @discardableResult
    func createWithPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
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
        newConstraint.anchorAttributes = anchorAttributes
        deactivate()
        firstItem?.removeConstraint(self)
        newConstraint.activate()
        return newConstraint
    }

    /// Creates a new constraint with the given multiplier.
    ///
    /// - Parameter multiplier: The multiplier that should be set for the new
    ///   constraint.
    /// - Returns: The new activated constraint with the provided `multiplier`
    ///   value.
    @discardableResult
    func createWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )
        newConstraint.anchorAttributes = anchorAttributes
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
    func activate() -> Array {
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
    func deactivate() -> Array {
        NSLayoutConstraint.deactivate(self)
        return self
    }
}

extension NSLayoutConstraint {
    private enum AssociatedKey {
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
        first { $0.anchorAttributes == value }
    }

    func attributes(_ value: Anchor.Attributes) -> [NSLayoutConstraint] {
        filter { $0.anchorAttributes == value }
    }
}
