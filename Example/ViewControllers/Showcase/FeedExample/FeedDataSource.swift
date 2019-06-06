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
    let names: [[(String, String)]] = [
        [
            ("Hello world!", "mambo jambo lala wowowow"),
            ("Hello world!", "mambo jambo lala wowowow"),
            ("Hello world!", "mambo jambo lala wowowow")
        ],
        [
            ("Hello world!", "mambo jambo lala wowowow"),
        ],
        [
            ("Hello world!", "mambo jambo lala wowowow"),
            ("Hello world!", "mambo jambo lala wowowow")
        ],
        [
            ("Hello world!", "mambo jambo lala wowowow"),
            ("Hello world!", "mambo jambo lala wowowow"),
            ("Hello world!", "mambo jambo lala wowowow")
        ],
        [
            ("Hello world!", "mambo jambo lala wowowow"),
        ],
        [
            ("Hello world!", "mambo jambo lala wowowow"),
            ("Hello world!", "mambo jambo lala wowowow")
        ],
        [
            ("Hello world!", "mambo jambo lala wowowow"),
            ("Hello world!", "mambo jambo lala wowowow"),
            ("Hello world!", "mambo jambo lala wowowow")
        ],
        [
            ("Hello world!", "mambo jambo lala wowowow"),
        ],
        [
            ("Hello world!", "mambo jambo lala wowowow"),
            ("Hello world!", "mambo jambo lala wowowow")
        ],        [
            ("Hello world!", "mambo jambo lala wowowow"),
            ("Hello world!", "mambo jambo lala wowowow"),
            ("Hello world!", "mambo jambo lala wowowow")
        ],
        [
            ("Hello world!", "mambo jambo lala wowowow"),
            ("Hello world!", "mambo jambo lala wowowow")
        ]
    ]

    var isTileEnabled = true
    lazy var sectionCount = names.count

    override init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
        if FeedDataSource.isRandomEnabled {
            sectionCount = Int.random(in: 1...names.count)
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath.with(globalSection)) as FeedTextViewCell
        let configuration = names[indexPath.section][indexPath.item]
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
