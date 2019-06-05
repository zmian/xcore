//
//  FeedViewController.swift
//  Example
//
//  Created by Guillermo Waitzel on 31/05/2019.
//  Copyright © 2019 Xcore. All rights reserved.
//

import Foundation

final class FeedViewController: XCComposedCollectionViewController {
    public override func dataSources(for collectionView: UICollectionView) -> [XCCollectionViewDataSource] {
        var sources = [XCCollectionViewDataSource]()
        for _ in 0..<100 {
            sources.append(FeedDataSource(collectionView: collectionView))
        }
        if let middleFeed = sources[10] as? FeedDataSource {
            middleFeed.isTileEnabled = false
        }
        if let middleFeed = sources[20] as? FeedDataSource {
            middleFeed.isTileEnabled = false
        }
        if let middleFeed = sources[0] as? FeedDataSource {
            middleFeed.isTileEnabled = false
        }
        return sources
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.backgroundColor = .red
        collectionView.contentInset.top = view.safeAreaInsets.top
        let tileLayout = XCCollectionViewTileLayout()
        tileLayout.numberOfColumns = 1
        layout = .init(tileLayout)
        collectionView.reloadData()
    }
}
