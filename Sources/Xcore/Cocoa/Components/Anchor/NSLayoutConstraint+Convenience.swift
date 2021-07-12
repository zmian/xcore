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
