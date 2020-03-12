//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

open class XCCollectionViewFlowLayout: UICollectionViewFlowLayout, DimmableLayout {
    open var shouldDimElements = false {
        didSet {
            guard oldValue != shouldDimElements else { return }
            invalidateLayout()
        }
    }

    open override class var layoutAttributesClass: AnyClass {
        Attributes.self
    }

    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) as? Attributes else {
            return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        }

        attributes.shouldDim = shouldDimElements
        return attributes
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) as? [Attributes] else {
            return super.layoutAttributesForElements(in: rect)
        }

        for attribute in attributes {
            attribute.shouldDim = shouldDimElements
        }

        return attributes
    }
}
