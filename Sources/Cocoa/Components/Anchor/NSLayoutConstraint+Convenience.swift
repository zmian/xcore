//
// NSLayoutConstraint+Convenience.swift
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
    public convenience init(item view1: AnyObject, attribute attr1: Attribute, relatedBy relation: Relation = .equal, toItem view2: AnyObject? = nil, attribute attr2: Attribute? = nil, multiplier: CGFloat = 1, constant c: CGFloat = 0, priority: UILayoutPriority = .required) {
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
    @objc func constraint(_ relation: NSLayoutConstraint.Relation, anchor: NSLayoutAnchor) -> NSLayoutConstraint {
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
