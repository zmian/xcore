//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class FeedViewController: XCComposedCollectionViewController {
    private var sources = [FeedDataSource]()

    var removed: Bool = false {
        didSet {
            let set = IndexSet(integersIn: 1...3)
            var newSources = sources
            if removed {
                newSources.removeSubrange(1...3)
            }
            composedDataSource.dataSources = newSources

            collectionView.performBatchUpdates {
                collectionView.collectionViewLayout.invalidateLayout()
                if removed {
                    collectionView.deleteSections(set)
                } else {
                    collectionView.insertSections(set)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        collectionView.backgroundColor = .clear
        collectionView.contentInset.top = view.safeAreaInsets.top

        layout = .init(XCCollectionViewTileLayout())

        sources = (0...10).map { index in
            FeedDataSource(sectionIndex: index)
        }
        composedDataSource.dataSources = sources
    }

    override func dataSources() -> [XCCollectionViewDataSource] {
        sources
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        removed.toggle()
    }
}
