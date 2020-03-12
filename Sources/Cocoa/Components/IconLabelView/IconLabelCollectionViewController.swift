//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

open class IconLabelCollectionViewController: UIViewController {
    public private(set) lazy var collectionView = IconLabelCollectionView(options: [.move, .delete])

    /// The layout used to organize the collection view’s items.
    public var layout: UICollectionViewFlowLayout? {
        return collectionView.layout
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.apply {
            view.addSubview($0)
            $0.anchor.edges.equalToSuperview()
        }
    }
}
