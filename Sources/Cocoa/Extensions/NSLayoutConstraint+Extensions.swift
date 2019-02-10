//
// NSLayoutConstraint+Extensions.swift
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

    /// A convenience method to set layout priority.
    ///
    /// - Parameter value: The layout priority.
    /// - Returns: `self`.
    @discardableResult
    public func priority(_ value: UILayoutPriority) -> NSLayoutConstraint {
        priority = value
        return self
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
