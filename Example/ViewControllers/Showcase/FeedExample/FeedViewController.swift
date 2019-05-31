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
        return [
            FeedDataSource(collectionView: collectionView)
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
    }
}
