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

// MARK: - XCCollectionView

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

// MARK: - XCFakeCollectionView

private final class XCFakeCollectionView: UICollectionView {
    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return CollectionViewDequeueCache.shared.dequeueCell(identifier: identifier)
    }

    override func dequeueReusableSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        return CollectionViewDequeueCache.shared.dequeueSupplementaryView(kind: elementKind, identifier: identifier)
    }
}

// MARK: - XCCollectionViewComposedDataSource

open class XCCollectionViewComposedDataSource: XCCollectionViewDataSource, ExpressibleByArrayLiteral {
    private let sizeCollectionView = XCFakeCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var dataSourceIndex = DataSourceIndex<XCCollectionViewDataSource>()

    open var dataSources = [XCCollectionViewDataSource]() {
        didSet {
            attachSizeCollectionView()
        }
    }

    public override init() {
        super.init()
    }

    public init(dataSources: [XCCollectionViewDataSource]) {
        super.init()
        self.dataSources = dataSources
        attachSizeCollectionView()
    }

    public required convenience init(arrayLiteral elements: XCCollectionViewDataSource...) {
        self.init(dataSources: elements)
    }

    // MARK: - Public Interface

    /// Adds a new data source at the end of the array.
    open func add(_ dataSource: XCCollectionViewDataSource) {
        dataSources.append(dataSource)
    }

    open func remove(_ dataSource: XCCollectionViewDataSource) {
        guard let index = dataSources.firstIndex(of: dataSource) else {
            return
        }

        dataSources.remove(at: index)
    }

    open func index(for section: Int) -> DataSource<XCCollectionViewDataSource> {
        let ds = dataSourceIndex[section]
        return DataSource(dataSource: ds.dataSource, globalSection: section, localSection: ds.localSection)
    }

    private func attachSizeCollectionView() {
        // Attach `sizeCollectionView` to all data sources.
        dataSources.forEach {
            $0._sizeCollectionView = sizeCollectionView
        }
    }
}

// MARK: - UICollectionViewDataSource

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

// MARK: - Sizes

extension XCCollectionViewComposedDataSource {
    open override func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath, availableWidth: CGFloat) -> CGSize {
        let (dataSource, localSection) = dataSourceIndex[indexPath.section]
        let localIndexPath = IndexPath(item: indexPath.item, section: localSection)
        return dataSource.collectionView(collectionView, sizeForItemAt: localIndexPath, availableWidth: availableWidth)
    }

    open override func collectionView(_ collectionView: UICollectionView, sizeForHeaderInSection section: Int, availableWidth: CGFloat) -> CGSize {
        let (dataSource, localSection) = dataSourceIndex[section]
        return dataSource.collectionView(collectionView, sizeForHeaderInSection: localSection, availableWidth: availableWidth)
    }

    open override func collectionView(_ collectionView: UICollectionView, sizeForFooterInSection section: Int, availableWidth: CGFloat) -> CGSize {
        let (dataSource, localSection) = dataSourceIndex[section]
        return dataSource.collectionView(collectionView, sizeForFooterInSection: localSection, availableWidth: availableWidth)
    }
}

// MARK: - Header and Footer

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

// MARK: - Lifecycle

extension XCCollectionViewComposedDataSource {
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let (dataSource, localSection) = dataSourceIndex[indexPath.section]
        let localIndexPath = IndexPath(item: indexPath.item, section: localSection)
        dataSource.collectionView(collectionView, didSelectItemAt: localIndexPath)
    }

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
