//
//  FeedLightDataSource.swift
//  Example
//
//  Created by Guillermo Waitzel on 06/06/2019.
//  Copyright © 2019 Xcore. All rights reserved.
//

import Foundation

final class FeedLightDataSource: XCCollectionViewDataSource {
    let height = CGFloat(Float.random(in: 100.0...500.0))
    let color: UIColor = {
        switch Int.random(in: 0...2) {
            case 0:
                return .red
            case 1:
                return .green
            case 2:
                return .yellow
            default:
                return .black
        }
    }()
    
    override init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath.with(globalSection)) as FeedColorViewCell
        cell.configure(height: height, color: color)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, headerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        return (false, nil)
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
