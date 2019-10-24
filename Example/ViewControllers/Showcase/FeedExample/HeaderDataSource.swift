//
//  HeaderViewController.swift
//  Example
//
//  Created by Guillermo Waitzel on 24/10/2019.
//  Copyright © 2019 Xcore. All rights reserved.
//

import Foundation

final class HeaderDataSource: XCCollectionViewDataSource {
    var isVisible: Bool = false

    override init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isVisible ? 1 : 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath.with(globalSection)) as FeedColorViewCell
        cell.configure(height: 30, color: .lightGray)
        return cell
    }
}
