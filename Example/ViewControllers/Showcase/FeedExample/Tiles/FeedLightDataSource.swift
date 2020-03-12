//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class FeedLightDataSource: XCCollectionViewDataSource {
    let height = CGFloat(Int.random(in: 100...500))
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
        1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath.with(globalSection)) as FeedColorViewCell
        cell.configure(height: height, color: color)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, headerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        (false, nil)
    }

    override func collectionView(_ collectionView: UICollectionView, footerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        (false, nil)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForHeaderInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        let indexPath = indexPath.with(globalSection)
        let headerView = collectionView.dequeueReusableSupplementaryView(.header, for: indexPath) as FeedTextHeaderFooterViewCell
        headerView.configure(title: "S: \(indexPath.section)")
        return headerView
    }

    override func collectionView(_ collectionView: UICollectionView, viewForFooterInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        let indexPath = indexPath.with(globalSection)
        let footerView = collectionView.dequeueReusableSupplementaryView(.footer, for: indexPath) as FeedTextHeaderFooterViewCell
        footerView.configure(title: "FOOTER!")
        return footerView
    }
}
