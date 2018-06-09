//
// XCCollectionViewComposedDataSource.swift
//
// Copyright © 2014 Zeeshan Mian
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

final class XCCollectionView: UICollectionView {
    override func reloadData() {
        RunLoop.cancelPreviousPerformRequests(withTarget: self, selector: #selector(xcReloadData), object: nil)
        perform(#selector(xcReloadData), with: nil, afterDelay: 0.03)
    }

    @objc
    private func xcReloadData() {
        super.reloadData()
        collectionViewLayout.invalidateLayout()
    }

    deinit {
        RunLoop.cancelPreviousPerformRequests(withTarget: self, selector: #selector(xcReloadData), object: nil)
    }
}

private final class XCFakeCollectionView: UICollectionView {
    static var cellCache = [String: UICollectionViewCell]()
    static var supplementaryViewCache = [String: UICollectionReusableView]()

    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        let className = identifier

        if let cachedCell = XCFakeCollectionView.cellCache[className] {
            cachedCell.prepareForReuse()
            return cachedCell
        }

        let aClass = NSClassFromString(className) as! UICollectionViewCell.Type
        let cell = aClass.init(frame: .zero)
        XCFakeCollectionView.cellCache[className] = cell
        return cell
    }

    override func dequeueReusableSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        let className = identifier

        if let cachedSupplementaryView = XCFakeCollectionView.supplementaryViewCache[className] {
            cachedSupplementaryView.prepareForReuse()
            return cachedSupplementaryView
        }

        let aClass = NSClassFromString(className) as! UICollectionReusableView.Type
        let supplementaryView = aClass.init(frame: .zero)
        XCFakeCollectionView.supplementaryViewCache[className] = supplementaryView
        return supplementaryView
    }
}

extension XCCollectionViewComposedDataSource {
    open static func clearCellCache() {
        XCFakeCollectionView.cellCache.removeAll(keepingCapacity: false)
        XCFakeCollectionView.supplementaryViewCache.removeAll(keepingCapacity: false)
    }
}

open class XCCollectionViewComposedDataSource: XCCollectionViewDataSource {
    private let sizeCollectionView = XCFakeCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var dataSourceIndex = DataSourceIndex<XCCollectionViewDataSource>()

    open func index(for section: Int) -> DataSource<XCCollectionViewDataSource> {
        let ds = dataSourceIndex[section]
        return DataSource(dataSource: ds.dataSource, globalSection: section, localSection: ds.localSection)
    }

    open var dataSources = [XCCollectionViewDataSource]() {
        didSet {
            // Attach `sizeCollectionView` to all data sources.
            dataSources.forEach {
                $0._sizeCollectionView = sizeCollectionView
            }
        }
    }

    public override init() {
        super.init()
    }

    public init(dataSources: [XCCollectionViewDataSource]) {
        super.init()
        self.dataSources = dataSources
    }

    // MARK: Public Interface

    open func append(dataSource: XCCollectionViewDataSource) {
        dataSources.append(dataSource)
    }

    open func remove(dataSource: XCCollectionViewDataSource) {
        if let index = dataSources.index(of: dataSource) {
            dataSources.remove(at: index)
        }
    }
}

// MARK: UICollectionViewDataSource

extension XCCollectionViewComposedDataSource {
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numberOfSections = 0
        let dataSourcesCount = dataSources.count

        for i in 0..<dataSourcesCount {
            let dataSource = dataSources[i]
            var dataSourceSections = dataSource.numberOfSections(in: collectionView)
            var localSection = 0

            while dataSourceSections > 0 {
                dataSources[i].globalSection = i
                dataSourceIndex[numberOfSections] = (dataSources[i], localSection)
                localSection += 1
                numberOfSections += 1
                dataSourceSections -= 1
            }
        }

        return numberOfSections
    }

    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let (dataSource, localSection) = dataSourceIndex[section]
        return dataSource.collectionView(collectionView, numberOfItemsInSection: localSection)
    }

    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let (dataSource, localSection) = dataSourceIndex[indexPath.section]
        let localIndexPath = IndexPath(item: indexPath.item, section: localSection)
        return dataSource.collectionView(collectionView, cellForItemAt: localIndexPath)
    }
}

// MARK: UICollectionViewDelegate

extension XCCollectionViewComposedDataSource {
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let (dataSource, localSection) = dataSourceIndex[indexPath.section]
        let localIndexPath = IndexPath(item: indexPath.item, section: localSection)
        dataSource.collectionView(collectionView, didSelectItemAt: localIndexPath)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension XCCollectionViewComposedDataSource {
    open override func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let (dataSource, localSection) = dataSourceIndex[indexPath.section]
        let localIndexPath = IndexPath(item: indexPath.item, section: localSection)
        let availableWidth = self.availableWidth(for: collectionView, section: localSection)
        var size = dataSource.collectionView(collectionView, sizeForItemAt: localIndexPath)
        if size.width > availableWidth {
            size.width = availableWidth
        }
        return size
    }

    open override func collectionView(_ collectionView: UICollectionView, sizeForHeaderInSection section: Int) -> CGSize {
        let (dataSource, localSection) = dataSourceIndex[section]
        return dataSource.collectionView(collectionView, sizeForHeaderInSection: localSection)
    }

    open override func collectionView(_ collectionView: UICollectionView, sizeForFooterInSection section: Int) -> CGSize {
        let (dataSource, localSection) = dataSourceIndex[section]
        return dataSource.collectionView(collectionView, sizeForFooterInSection: localSection)
    }

    open override func collectionView(_ collectionView: UICollectionView, insetForSectionAt section: Int) -> UIEdgeInsets {
        let (dataSource, localSection) = dataSourceIndex[section]
        let sectionInset = dataSource.collectionView(collectionView, insetForSectionAt: localSection)

        // This is to prevent any section insets being included in layout
        // when given section has no items, header or footer present.
        //
        // If the given section have items, header or footer we include insets; otherwise we remove the insets from the given section.
        // The following logic lazily walks down the tree checking to see if any of those elements present.
        if sectionInset != .zero {
            let numberOfItemsInSection = dataSource.collectionView(collectionView, numberOfItemsInSection: localSection)
            if numberOfItemsInSection == 0 {
                let headerSize = dataSource.collectionView(collectionView, sizeForHeaderInSection: localSection)
                if headerSize.height == 0 {
                    let footerSize = dataSource.collectionView(collectionView, sizeForFooterInSection: localSection)
                    if footerSize.height == 0 {
                        return .zero
                    }
                }
            }
        }

        return sectionInset
    }

    open override func collectionView(_ collectionView: UICollectionView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let (dataSource, localSection) = dataSourceIndex[section]
        return dataSource.collectionView(collectionView, minimumLineSpacingForSectionAt: localSection)
    }

    open override func collectionView(_ collectionView: UICollectionView, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let (dataSource, localSection) = dataSourceIndex[section]
        return dataSource.collectionView(collectionView, minimumInteritemSpacingForSectionAt: localSection)
    }

    // MARK: Lifecycle

    open override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let (dataSource, localSection) = dataSourceIndex[indexPath.section]
        let localIndexPath = IndexPath(item: indexPath.item, section: localSection)
        return dataSource.collectionView(collectionView, willDisplay: cell, forItemAt: localIndexPath)
    }

    open override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let (dataSource, localSection) = dataSourceIndex[indexPath.section]
        let localIndexPath = IndexPath(item: indexPath.item, section: localSection)
        return dataSource.collectionView(collectionView, willDisplaySupplementaryView: view, forElementKind: elementKind, at: localIndexPath)
    }

    open override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let (dataSource, localSection) = dataSourceIndex[indexPath.section]
        let localIndexPath = IndexPath(item: indexPath.item, section: localSection)
        return dataSource.collectionView(collectionView, didEndDisplaying: cell, forItemAt: localIndexPath)
    }

    open override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        let (dataSource, localSection) = dataSourceIndex[indexPath.section]
        let localIndexPath = IndexPath(item: indexPath.item, section: localSection)
        return dataSource.collectionView(collectionView, didEndDisplayingSupplementaryView: view, forElementOfKind: elementKind, at: localIndexPath)
    }
}

// MARK: Header and Footer

extension XCCollectionViewComposedDataSource {
    open override func collectionView(_ collectionView: UICollectionView, viewForHeaderInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        let (dataSource, localSection) = dataSourceIndex[indexPath.section]
        let localIndexPath = IndexPath(item: indexPath.item, section: localSection)
        return dataSource.collectionView(collectionView, viewForHeaderInSectionAt: localIndexPath)
    }

    open override func collectionView(_ collectionView: UICollectionView, viewForFooterInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        let (dataSource, localSection) = dataSourceIndex[indexPath.section]
        let localIndexPath = IndexPath(item: indexPath.item, section: localSection)
        return dataSource.collectionView(collectionView, viewForFooterInSectionAt: localIndexPath)
    }
}
