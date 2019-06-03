//
//  XCCollectionViewTileLayoutAdapter.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 28/05/2019.
//

import Foundation

public protocol XCCollectionViewTileLayoutCustomizable {
    func isTileEnabled(in layout: XCCollectionViewTileLayout) -> Bool
}

extension XCCollectionViewTileLayoutCustomizable {
    func isTileEnabled(_ layout: XCCollectionViewTileLayout) -> Bool {
        return true
    }
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

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, isTileEnabledInSection section: Int) -> Bool {
        let source = composedDataSource.index(for: section)
        guard let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable else {
            return true
        }
        return custom.isTileEnabled(collectionViewLayout)
    }
}

extension XCCollectionViewTileLayout: XCComposedCollectionViewLayoutCompatible {
    public static var defaultAdapterType: XCComposedCollectionViewLayoutAdapter.Type {
        return XCCollectionViewTileLayoutAdapter.self
    }
}
