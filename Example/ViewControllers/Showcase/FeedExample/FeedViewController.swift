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
        for _ in 0..<1000 {
            sources.append(FeedLightDataSource(collectionView: collectionView))
        }
        if let notTiled = sources[10] as? FeedDataSource {
            notTiled.isTileEnabled = false
        }
        return sources
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = view.safeAreaInsets.top
        let tileLayout = XCCollectionViewTileLayout()
        tileLayout.numberOfColumns = 3
        layout = .init(tileLayout)
    }
}
