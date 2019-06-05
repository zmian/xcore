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
        ],[
            ("Heqwerqwerqwerqwerwllo asf!", "mambo jambo lala wowowow"),
            ("Hello wogagrld!", "mambo jambo lala wowowow"),
            ("Hello asd!", "mambo jambo lala wowowow")
        ],[
            ("Hello ga!", "mambo jambo lala wowowow"),
            ("Hello ag!", "mambo jambo lala wowowow")
        ],[
            ("Hellasd fasdfasdfasdo ga!", "mambo jambo lasd fasdfala wowowow"),
            ("Hellasd fasdfasdfasdfasd fasdfasdfasdfasdfasfasdf o ag!", "mambo jambo lala wowowow")
        ],[
            ("Hello ga!", "mambo jambo sadf asdfasdf asdflala wowowow"),
            ("Hello ag!", "mambo jambo lala wowowow")
        ],[
            ("Hello asf!", "mambo jamboasd fasdfasdflala wowowow"),
            ("Hello wogagrld!", "mambo jamasdf asdfasbo lala wowowow"),
            ("Hello asd!", "mambo jambo lala wowowow")
        ],[
            ("Hello asf!", "mambo jambo lala wowowow"),
            ("Hello wogagrld!", "mambo jambo lala wowowow"),
            ("Hello asd!", "mambo jambo lala wowowow")
        ],[
            ("Helloqwerqwer asf!", "mambo jambo lala asd f"),
            ("Helloqwerqwerqwer wogagrld!", "mambo sadf asdf asd f lala wowowow"),
            ("Hellqewrqwero asd!", "mambo jambo asd fasdfasdfasdfasdflala wowowow")
        ]
    ]

//    let names: [[(String, String)]] = [
//        [
//            ("Hello world!", "mambo jambo lala wowowow")
//        ],[
//            ("Hello world!", "mambo jambo lala wowowow"),
//            ("Hello world!", "mambo jambo lala wowowow"),
//            ("Hello world!", "mambo jambo lala wowowow")
//        ]
//    ]

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

    override func collectionView(_ collectionView: UICollectionView, headerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        return (true, nil)
    }

    override func collectionView(_ collectionView: UICollectionView, footerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        return (false, nil)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForHeaderInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        let globalIndexPath = indexPath.with(globalSection)
        let header = collectionView.dequeueReusableSupplementaryView(.header, for: globalIndexPath) as FeedTextHeaderFooterViewCell
        header.configure(title: "HEADER!")
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, viewForFooterInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        let globalIndexPath = indexPath.with(globalSection)
        let footer = collectionView.dequeueReusableSupplementaryView(.footer, for: globalIndexPath) as FeedTextHeaderFooterViewCell
        footer.configure(title: "FOOTER!")
        return footer
    }
}
