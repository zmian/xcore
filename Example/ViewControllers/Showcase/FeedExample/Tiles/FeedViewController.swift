//
// FeedViewController.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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

            // swiftlint:disable:next trailing_closure
            collectionView.performBatchUpdates({
                collectionView.collectionViewLayout.invalidateLayout()
                if removed {
                    collectionView.deleteSections(set)
                } else {
                    collectionView.insertSections(set)
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        collectionView.backgroundColor = .clear
        collectionView.contentInset.top = view.safeAreaInsets.top

        layout = .init(XCCollectionViewTileLayout())

        sources = (0...10).map { index in
            FeedDataSource(collectionView: collectionView, sectionIndex: index)
        }
        composedDataSource.dataSources = sources
    }

    override func dataSources(for collectionView: UICollectionView) -> [XCCollectionViewDataSource] {
        sources
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        removed.toggle()
    }
}
