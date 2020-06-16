//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension XCCollectionViewTileLayout {
    final class Attributes: XCCollectionViewFlowLayout.Attributes {
        var corners: (mask: CACornerMask, radius: CGFloat) = (.none, 0)
        var offsetInSection: CGFloat = 0
        var parentIdentifier: String?

        override func copy(with zone: NSZone? = nil) -> Any {
            guard let copy = super.copy(with: zone) as? Attributes else {
                return super.copy(with: zone)
            }
            copy.corners = corners
            copy.parentIdentifier = parentIdentifier
            copy.offsetInSection = offsetInSection
            return copy
        }

        override func isEqual(_ object: Any?) -> Bool {
            guard let rhsAttributes = object as? Attributes else {
                return false
            }
            return
                super.isEqual(object) &&
                corners.mask == rhsAttributes.corners.mask &&
                corners.radius == rhsAttributes.corners.radius &&
                parentIdentifier == rhsAttributes.parentIdentifier &&
                offsetInSection == rhsAttributes.offsetInSection
        }
    }
}
