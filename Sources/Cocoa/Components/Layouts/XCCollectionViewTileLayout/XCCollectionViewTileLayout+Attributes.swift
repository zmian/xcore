//
//  XCCollectionViewTileLayout+Attributes.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 17/05/2019.
//

import UIKit

extension XCCollectionViewTileLayout {
    final class Attributes: UICollectionViewLayoutAttributes {
        var corners: (corners: UIRectCorner, radius: CGFloat) = (.none, 0)
        var isAutosizeEnabled: Bool = false
        
        override func copy(with zone: NSZone? = nil) -> Any {
            guard let copy = super.copy(with: zone) as? XCCollectionViewTileLayout.Attributes else {
                return super.copy(with: zone)
            }

            copy.corners = corners
            copy.isAutosizeEnabled = isAutosizeEnabled
            return copy
        }
    }
}
