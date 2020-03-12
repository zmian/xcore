//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - XCCollectionViewTileLayoutCustomizable

public protocol XCCollectionViewTileLayoutCustomizable {
    func sectionConfiguration(in layout: XCCollectionViewTileLayout, for section: Int) -> XCCollectionViewTileLayout.SectionConfiguration
}

open class XCCollectionViewTileLayoutAdapter: XCComposedCollectionViewLayoutAdapter, XCCollectionViewDelegateTileLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat? {
        let attributes = composedDataSource.collectionView(collectionView, itemAttributesAt: indexPath)
        return attributes?.height
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, headerAttributesInSection section: Int, width: CGFloat) -> (Bool, CGFloat?) {
        let attributes = composedDataSource.collectionView(collectionView, headerAttributesForSectionAt: section)
        return (attributes.enabled, attributes.size?.height)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, footerAttributesInSection section: Int, width: CGFloat) -> (Bool, CGFloat?) {
        let attributes = composedDataSource.collectionView(collectionView, footerAttributesForSectionAt: section)
        return (attributes.enabled, attributes.size?.height)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, estimatedHeightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat {
        XCDataSourceSizeCalculator.estimatedItemSize(in: composedDataSource, at: indexPath, availableWidth: width).height
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, estimatedHeaderHeightInSection section: Int, width: CGFloat) -> CGFloat {
        XCDataSourceSizeCalculator.estimatedHeaderSize(in: composedDataSource, for: section, availableWidth: width).height
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, estimatedFooterHeightInSection section: Int, width: CGFloat) -> CGFloat {
        XCDataSourceSizeCalculator.estimatedFooterSize(in: composedDataSource, for: section, availableWidth: width).height
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, sectionConfigurationAt section: Int) -> XCCollectionViewTileLayout.SectionConfiguration? {
        let source = composedDataSource.index(for: section)
        guard let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable else {
            return nil
        }
        return custom.sectionConfiguration(in: collectionViewLayout, for: source.localSection)
    }
}

extension XCCollectionViewTileLayout: XCComposedCollectionViewLayoutCompatible {
    public static var defaultAdapterType: XCComposedCollectionViewLayoutAdapter.Type {
        XCCollectionViewTileLayoutAdapter.self
    }
}
