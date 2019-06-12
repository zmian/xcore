//
//  FeedDataSource.swift
//  Example
//
//  Created by Guillermo Waitzel on 31/05/2019.
//  Copyright © 2019 Xcore. All rights reserved.
//

import Foundation

final class FeedDataSource: XCCollectionViewDataSource {
    static var isRandomEnabled = false

    lazy var names: [(String, String)] = {
        let cellCount = Int.random(in: 0...1)
        let textSize = Int.random(in: 1...3)
        guard cellCount > 0 else {  return [(String, String)]() }
        var detailText = ""
        for _ in 0..<textSize {
            detailText.append("Lore ipsum alalas dasfasfasf\n")
        }
        return [("Title Test", detailText)]
    }()

    var isTileEnabled = true
    lazy var sectionCount = names.count

    override init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
        if FeedDataSource.isRandomEnabled {
            sectionCount = Int.random(in: 1...names.count)
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath.with(globalSection)) as FeedTextViewCell
        let configuration = names[indexPath.item]
        cell.configure(title: configuration.0, subtitle: configuration.1)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, headerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        return (true, nil)
    }

    override func collectionView(_ collectionView: UICollectionView, footerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        return (false, nil)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForHeaderInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        let globalIndexPath = indexPath.with(globalSection)
        let header = collectionView.dequeueReusableSupplementaryView(.header, for: globalIndexPath) as FeedTextHeaderFooterViewCell
        header.configure(title: "S: \(globalIndexPath.section)")
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, viewForFooterInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        let globalIndexPath = indexPath.with(globalSection)
        let footer = collectionView.dequeueReusableSupplementaryView(.footer, for: globalIndexPath) as FeedTextHeaderFooterViewCell
        footer.configure(title: "FOOTER!")
        return footer
    }
}

extension FeedDataSource: XCCollectionViewTileLayoutCustomizable {
    func isTileEnabled(in layout: XCCollectionViewTileLayout) -> Bool {
        return isTileEnabled
    }
}
