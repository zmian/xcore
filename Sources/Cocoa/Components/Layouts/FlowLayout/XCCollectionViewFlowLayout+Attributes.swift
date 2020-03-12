//
// XCCollectionViewFlowLayout+Attributes.swift
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension XCCollectionViewFlowLayout {
    open class Attributes: UICollectionViewLayoutAttributes {
        public var separator: UIRectEdge = []
        public var shouldDim = false

        open override func copy(with zone: NSZone? = nil) -> Any {
            guard let copy = super.copy(with: zone) as? Attributes else {
                return super.copy(with: zone)
            }

            copy.separator = separator
            copy.shouldDim = shouldDim
            return copy
        }

        open override func isEqual(_ object: Any?) -> Bool {
            guard let rhsAttributes = object as? Attributes else {
                return false
            }
            return super.isEqual(object) &&
                shouldDim == rhsAttributes.shouldDim &&
                separator == rhsAttributes.separator
        }
    }
}
