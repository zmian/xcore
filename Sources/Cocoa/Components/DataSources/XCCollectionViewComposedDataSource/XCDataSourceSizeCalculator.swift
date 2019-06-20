//
// XCDataSourceSizeCalculator.swift
//
// Copyright © 2016 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
        return CollectionViewDequeueCache.shared.dequeueCell(identifier: identifier)
    }

    override func dequeueReusableSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        return CollectionViewDequeueCache.shared.dequeueSupplementaryView(kind: elementKind, identifier: identifier)
    }
}
