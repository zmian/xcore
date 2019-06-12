//
//  FeedViewController.swift
//  Example
//
//  Created by Guillermo Waitzel on 31/05/2019.
//  Copyright © 2019 Xcore. All rights reserved.
//

import Foundation

final class FeedViewController: XCComposedCollectionViewController {
    private var sources = [FeedDataSource]()
    private func recreateSources() {
        sources.removeAll()
        let sourcesCount = Int.random(in: 100...120)
        for _ in 0..<sourcesCount {
            sources.append(FeedDataSource(collectionView: collectionView))
        }
        composedDataSource.dataSources = dataSources(for: collectionView)
        collectionView.reloadData()
    }

    public override func dataSources(for collectionView: UICollectionView) -> [XCCollectionViewDataSource] {
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
        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.recreateSources()
        }
    }
}
