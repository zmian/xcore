//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

protocol Colorable {
    var color: UIColor { get }
}

protocol CollectionViewLayoutRepresentable {
    var itemSize: CGSize { get set }
    var scrollDirection: UICollectionView.ScrollDirection { get }
}

extension UICollectionViewFlowLayout: CollectionViewLayoutRepresentable {}

extension UIScrollView {
    /// A convenience function to cross fade between two color in given items.
    func crossFadeColor(previousIndex: Int, items: [Colorable]) -> UIColor {
        var span = currentScrollingDirection.isHorizontal ? frame.width : frame.height
        var offset = currentScrollingDirection.isHorizontal ? contentOffset.x : contentOffset.y

        if let collectionViewLayout = (self as? UICollectionView)?.collectionViewLayout as? CollectionViewLayoutRepresentable {
            span = collectionViewLayout.scrollDirection == .horizontal ? collectionViewLayout.itemSize.width : collectionViewLayout.itemSize.height
            offset = collectionViewLayout.scrollDirection == .horizontal ? contentOffset.x : contentOffset.y
        }

        let delta = (offset - CGFloat(previousIndex) * span) / span
        let fromColor = items.at(previousIndex)?.color ?? .black
        let toColor = items.at(delta > 0 ? previousIndex + 1 : previousIndex - 1)?.color ?? fromColor
        return fromColor.crossFade(to: toColor, delta: abs(delta))
    }
}
