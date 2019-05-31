//
//  FeedDataSource.swift
//  Example
//
//  Created by Guillermo Waitzel on 31/05/2019.
//  Copyright © 2019 Xcore. All rights reserved.
//

import Foundation

final class FeedDataSource: XCCollectionViewDataSource {
    let names: [[(String, String)]] = [
        [
            ("Hello world!", "mambo jambo lala wowowow")
        ],[
            ("Hello world!", "mambo jambo lala wowowow"),
            ("Hello world!", "mambo jambo lala wowowow"),
            ("Hello world!", "mambo jambo lala wowowow")
        ],[
            (
                "Hello woas dasdasd asdasdasdasdasdasdasdasdasdasdasdrld!",
                "mambo jambo lala wowowow asda  a klsdjflasa dfshklasdfl fasasd fasdf asdfhasldfjalskdjflkasjdflkjasdlfkjsalkdjflksajdflsajdlfkjasldkfjsaldjflkasjdflkjasdlflfaksjdl"
            )
        ]
    ]
    override init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return names.count
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
}
