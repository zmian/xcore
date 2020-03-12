//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final public class XCCollectionView: UICollectionView {
    private var _reloadDataPrecondition: () -> Bool = { true }

    /// Checks a necessary condition for `reloadData`.
    ///
    /// This method is invoked before any `reloadData` calls are made. This must
    /// return `true` for the reload data call to be made.
    ///
    /// The default value is `true`.
    public func reloadDataPrecondition(_ condition: @autoclosure @escaping () -> Bool) {
        _reloadDataPrecondition = condition
    }

    public override func reloadData() {
        guard _reloadDataPrecondition() else {
            return
        }

        super.reloadData()
        collectionViewLayout.invalidateLayout()
    }
}

// MARK: - XCCollectionViewComposedDataSource

open class XCCollectionViewComposedDataSource: XCCollectionViewDataSource, ExpressibleByArrayLiteral {
    private var dataSourceIndex = DataSourceIndex<XCCollectionViewDataSource>()

    open var dataSources = [XCCollectionViewDataSource]()

    public override init() {
        super.init()
    }

    public init(dataSources: [XCCollectionViewDataSource]) {
        super.init()
        self.dataSources = dataSources
    }

    public required convenience init(arrayLiteral elements: XCCollectionViewDataSource...) {
        self.init(dataSources: elements)
    }

    // MARK: - Public Interface

    /// Adds a new data source at the end of the collection.
    open func add(_ dataSource: XCCollectionViewDataSource) {
        dataSources.append(dataSource)
    }

    /// Removes the given data source.
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

    // MARK: - Layout Attributes

    open override func collectionView(_ collectionView: UICollectionView, itemAttributesAt indexPath: IndexPath) -> CGSize? {
        let (dataSource, localSection) = dataSourceIndex[indexPath.section]
        let localIndexPath = IndexPath(item: indexPath.item, section: localSection)
        return dataSource.collectionView(collectionView, itemAttributesAt: localIndexPath)
    }

    open override func collectionView(_ collectionView: UICollectionView, headerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        let (dataSource, localSection) = dataSourceIndex[section]
        return dataSource.collectionView(collectionView, headerAttributesForSectionAt: localSection)
    }

    open override func collectionView(_ collectionView: UICollectionView, footerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        let (dataSource, localSection) = dataSourceIndex[section]
        return dataSource.collectionView(collectionView, footerAttributesForSectionAt: localSection)
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

            dataSources[i].globalSection = numberOfSections
            while dataSourceSections > 0 {
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
