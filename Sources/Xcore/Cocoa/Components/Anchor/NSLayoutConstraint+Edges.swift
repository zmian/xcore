//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - Edges

extension NSLayoutConstraint {
    struct Edges {
        let top: NSLayoutConstraint
        let bottom: NSLayoutConstraint
        let leading: NSLayoutConstraint
        let trailing: NSLayoutConstraint

        private var constraints: [NSLayoutConstraint] {
            [top, bottom, leading, trailing]
        }

        init(_ constraints: [NSLayoutConstraint]) {
            trailing = constraints.firstAttribute(.trailing)!
            leading = constraints.firstAttribute(.leading)!
            bottom = constraints.firstAttribute(.bottom)!
            top = constraints.firstAttribute(.top)!
        }

        init(top: NSLayoutConstraint, bottom: NSLayoutConstraint, leading: NSLayoutConstraint, trailing: NSLayoutConstraint) {
            self.top = top
            self.bottom = bottom
            self.leading = leading
            self.trailing = trailing
        }

        mutating func update(from insets: UIEdgeInsets) {
            top.constant = insets.top
            bottom.constant = insets.bottom
            leading.constant = insets.left
            trailing.constant = insets.right
        }

        mutating func update(from value: CGFloat) {
            top.constant = value
            bottom.constant = value
            leading.constant = value
            trailing.constant = value
        }

        @discardableResult
        func activate() -> Self {
            constraints.activate()
            return self
        }

        @discardableResult
        func deactivate() -> Self {
            constraints.deactivate()
            return self
        }
    }
}

// MARK: - Size

extension NSLayoutConstraint {
    struct Size {
        let width: NSLayoutConstraint
        let height: NSLayoutConstraint

        private var constraints: [NSLayoutConstraint] {
            [width, height]
        }

        init(_ constraints: [NSLayoutConstraint]) {
            width = constraints[0]
            height = constraints[1]
        }

        init(width: NSLayoutConstraint, height: NSLayoutConstraint) {
            self.width = width
            self.height = height
        }

        mutating func update(from size: CGSize) {
            width.constant = size.width
            height.constant = size.height
        }

        mutating func update(from value: CGFloat) {
            width.constant = value
            height.constant = value
        }

        func toggleIfNeeded() {
            width.isActive = width.constant != 0
            height.isActive = height.constant != 0
        }

        @discardableResult
        func activate() -> Self {
            constraints.activate()
            return self
        }

        @discardableResult
        func deactivate() -> Self {
            constraints.deactivate()
            return self
        }
    }
}
