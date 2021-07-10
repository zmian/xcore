//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension IndexPath {
    public static var zero: Self {
        .init(item: 0, section: 0)
    }
}

extension IndexPath {
    public func previous() -> Self? {
        guard item > 0 else {
            return nil
        }

        return IndexPath(row: item - 1, section: section)
    }

    public func next(in collectionView: UICollectionView) -> Self? {
        let itemsInSection = collectionView.numberOfItems(inSection: section)

        guard item + 1 < itemsInSection else {
            return nil
        }

        return IndexPath(row: item + 1, section: section)
    }
}
