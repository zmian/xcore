//
//  UICollectionViewFlexLayoutAttributes.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 17/05/2019.
//

import UIKit

extension UICollectionViewFlexLayout {
    final class Attributes: UICollectionViewLayoutAttributes {
        var cornerRadius: CGFloat = 0.0
        var corners: UIRectCorner = []

        override func copy(with zone: NSZone? = nil) -> Any {
            guard let copy = super.copy(with: zone) as? UICollectionViewFlexLayout.Attributes else {
                return super.copy(with: zone)
            }
            
            copy.cornerRadius = cornerRadius
            copy.corners = corners
            return copy
        }
    }
}

