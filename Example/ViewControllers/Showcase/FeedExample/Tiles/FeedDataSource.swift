//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class FeedDataSource: XCCollectionViewDataSource, XCCollectionViewTileLayoutCustomizable {
    static var isRandomEnabled = false
    let cellCount = Int.random(in: 1...2)
    var sectionIndex: Int
    var isVisible: Bool = true
    var isInverted: Bool = false

    lazy var names: [(String, String)] = {
        let textSize = Int.random(in: 1...3)

        guard cellCount > 0 else {
            return [(String, String)]()
        }

        var detailText = ""
        for _ in 0..<textSize {
            detailText.append("Lore ipsum alalas dasfasfasf\n")
        }
        return [("AA", "BB")]
    }()

    var isTileEnabled = true
    var cornerRadius: CGFloat = 11
    var isShadowEnabled = true

    init(sectionIndex: Int) {
        self.sectionIndex = sectionIndex
        super.init()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath.with(globalSection)) as FeedTextViewCell
        cell.configure(title: "S: \(sectionIndex)", subtitle: "")
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, headerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        (false, nil)
    }

    override func collectionView(_ collectionView: UICollectionView, footerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        (false, nil)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForHeaderInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        let globalIndexPath = indexPath.with(globalSection)
        let headerView = collectionView.dequeueReusableSupplementaryView(.header, for: globalIndexPath) as FeedTextHeaderFooterViewCell
        headerView.configure(title: "S: \(sectionIndex)")
        return headerView
    }

    override func collectionView(_ collectionView: UICollectionView, viewForFooterInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        let globalIndexPath = indexPath.with(globalSection)
        let footerView = collectionView.dequeueReusableSupplementaryView(.footer, for: globalIndexPath) as FeedTextHeaderFooterViewCell
        footerView.configure(title: "FOOTER!")
        return footerView
    }

    func sectionConfiguration(in layout: XCCollectionViewTileLayout, for section: Int) -> XCCollectionViewTileLayout.SectionConfiguration {
        var configuration = layout.defaultSectionConfiguration
        configuration.isShadowEnabled = false
        return configuration
    }
}
