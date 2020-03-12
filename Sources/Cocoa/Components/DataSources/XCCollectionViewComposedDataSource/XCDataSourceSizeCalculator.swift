//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class XCDataSourceSizeCalculator: UICollectionView {
    private static let sharedInstance = XCDataSourceSizeCalculator(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    static func estimatedItemSize(in dataSource: XCCollectionViewComposedDataSource, at indexPath: IndexPath, availableWidth: CGFloat) -> CGSize {
        let source = dataSource.index(for: indexPath.section)
        let localIndexPath = IndexPath(item: indexPath.item, section: source.localSection)
        let cell = source.dataSource.collectionView(sharedInstance, cellForItemAt: localIndexPath)
        return cell.contentView.sizeFitting(width: availableWidth)
    }

    static func estimatedHeaderSize(in dataSource: XCCollectionViewComposedDataSource, for section: Int, availableWidth: CGFloat) -> CGSize {
        let source = dataSource.index(for: section)
        let localPath = IndexPath(item: 0, section: source.localSection)
        if let headerView = source.dataSource.collectionView(sharedInstance, viewForHeaderInSectionAt: localPath) {
            return headerView.sizeFitting(width: availableWidth)
        }
        return .zero
    }

    static func estimatedFooterSize(in dataSource: XCCollectionViewComposedDataSource, for section: Int, availableWidth: CGFloat) -> CGSize {
        let source = dataSource.index(for: section)
        let localPath = IndexPath(item: 0, section: source.localSection)
        if let footerView = source.dataSource.collectionView(sharedInstance, viewForFooterInSectionAt: localPath) {
            return footerView.sizeFitting(width: availableWidth)
        }
        return .zero
    }

    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        CollectionViewDequeueCache.shared.dequeueCell(identifier: identifier)
    }

    override func dequeueReusableSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        CollectionViewDequeueCache.shared.dequeueSupplementaryView(kind: elementKind, identifier: identifier)
    }
}
