//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - Edges

extension NSLayoutConstraint {
    public struct Edges {
        public let top: NSLayoutConstraint
        public let bottom: NSLayoutConstraint
        public let leading: NSLayoutConstraint
        public let trailing: NSLayoutConstraint

        private var constraints: [NSLayoutConstraint] {
            [top, bottom, leading, trailing]
        }

        init(_ constraints: [NSLayoutConstraint]) {
            trailing = constraints.firstAttribute(.trailing)!
            leading = constraints.firstAttribute(.leading)!
            bottom = constraints.firstAttribute(.bottom)!
            top = constraints.firstAttribute(.top)!
        }

        public init(top: NSLayoutConstraint, bottom: NSLayoutConstraint, leading: NSLayoutConstraint, trailing: NSLayoutConstraint) {
            self.top = top
            self.bottom = bottom
            self.leading = leading
            self.trailing = trailing
        }

        public mutating func update(from insets: UIEdgeInsets) {
            top.constant = insets.top
            bottom.constant = insets.bottom
            leading.constant = insets.left
            trailing.constant = insets.right
        }

        public mutating func update(from value: CGFloat) {
            top.constant = value
            bottom.constant = value
            leading.constant = value
            trailing.constant = value
        }

        @discardableResult
        public func activate() -> Self {
            constraints.activate()
            return self
        }

        @discardableResult
        public func deactivate() -> Self {
            constraints.deactivate()
            return self
        }
    }
}

// MARK: - Size

extension NSLayoutConstraint {
    public struct Size {
        public let width: NSLayoutConstraint
        public let height: NSLayoutConstraint

        private var constraints: [NSLayoutConstraint] {
            [width, height]
        }

        init(_ constraints: [NSLayoutConstraint]) {
            width = constraints[0]
            height = constraints[1]
        }

        public init(width: NSLayoutConstraint, height: NSLayoutConstraint) {
            self.width = width
            self.height = height
        }

        public mutating func update(from size: CGSize) {
            width.constant = size.width
            height.constant = size.height
        }

        public mutating func update(from value: CGFloat) {
            width.constant = value
            height.constant = value
        }

        public func toggleIfNeeded() {
            width.isActive = width.constant != 0
            height.isActive = height.constant != 0
        }

        @discardableResult
        public func activate() -> Self {
            constraints.activate()
            return self
        }

        @discardableResult
        public func deactivate() -> Self {
            constraints.deactivate()
            return self
        }
    }
}
