//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public typealias CarouselViewCellType = UICollectionViewCell & CarouselViewCellRepresentable
public typealias CarouselAccessibilityItem = (label: String, value: String, additionalViews: [Any]?)

public protocol CarouselAccessibilitySupport {
    func accessibilityItem(index: Int) -> CarouselAccessibilityItem?
}

public protocol CarouselViewModelRepresentable: CarouselAccessibilitySupport {
    associatedtype Model

    func numberOfItems() -> Int
    func itemViewModel(index: Int) -> Model?
}

public protocol CarouselViewCellRepresentable: Reusable {
    associatedtype Model

    func configure(_ model: Model)

    func didSelectItem(_ callback: @escaping () -> Void)

    /// A convenience method to specify the cell width.
    /// The default value is width of the collection view.
    func preferredWidth(collectionView: UICollectionView) -> CGFloat
}

extension CarouselViewCellRepresentable {
    public func preferredWidth(collectionView: UICollectionView) -> CGFloat {
        collectionView.frame.width
    }

    public func didSelectItem(_ callback: @escaping () -> Void) { }
}
