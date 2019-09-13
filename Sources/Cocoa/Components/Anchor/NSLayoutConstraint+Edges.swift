//
// NSLayoutConstraint+Edges.swift
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
    public struct Edges {
        public let top: NSLayoutConstraint
        public let bottom: NSLayoutConstraint
        public let leading: NSLayoutConstraint
        public let trailing: NSLayoutConstraint

        private var constraints: [NSLayoutConstraint] {
            return [top, bottom, leading, trailing]
        }

        init(_ constraints: [NSLayoutConstraint]) {
            trailing = constraints[0]
            leading = constraints[1]
            bottom = constraints[2]
            top = constraints[3]
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

        public func activate() {
            constraints.activate()
        }

        public func deactivate() {
            constraints.deactivate()
        }
    }

    public struct Size {
        public let width: NSLayoutConstraint
        public let height: NSLayoutConstraint

        private var constraints: [NSLayoutConstraint] {
            return [width, height]
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

        public func activate() {
            constraints.activate()
        }

        public func deactivate() {
            constraints.deactivate()
        }
    }
}
