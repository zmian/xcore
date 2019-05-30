//
//  XCCollectionViewTileLayoutAdapter.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 28/05/2019.
//

import Foundation

@objc public protocol XCCollectionViewTileLayoutCustomizable {
    @objc optional func isFullWidth() -> Bool
    @objc optional func isShadowEnabled() -> Bool
    @objc optional func cornerRadiusForTile() -> CGFloat
}

open class XCCollectionViewTileLayoutAdapter: XCComposedCollectionViewLayoutAdapter, XCCollectionViewDelegateTileLayout {
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return composedDataSource.collectionView(collectionView, sizeForItemAt: indexPath, availableWidth: width).height
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForHeaderInSection section: Int, width: CGFloat) -> CGFloat {
        return composedDataSource.collectionView(collectionView, sizeForHeaderInSection: section, availableWidth: width).height
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForFooterInSection section: Int, width: CGFloat) -> CGFloat {
        return composedDataSource.collectionView(collectionView, sizeForFooterInSection: section, availableWidth: width).height
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, verticalSpacingBetweenSectionAt section: Int, and nextSection: Int) -> CGFloat {
        return .defaultPadding
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, marginForSectionAt section: Int) -> UIEdgeInsets {
        let source = composedDataSource.index(for: section)
        guard
            let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable,
            let isFullWidth = custom.isFullWidth?(),
            isFullWidth
        else {
            return UIEdgeInsets(horizontal: .defaultPadding)
        }
        return .zero
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, isShadowEnabledAt section: Int) -> Bool {
        let source = composedDataSource.index(for: section)
        guard
            let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable,
            let isShadowEnabled = custom.isShadowEnabled?()
        else {
            return true
        }
        return isShadowEnabled
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, cornerRadiusAt section: Int) -> CGFloat {
        let source = composedDataSource.index(for: section)
        guard
            let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable,
            let cornerRadius = custom.cornerRadiusForTile?()
        else {
            return 11
        }
        return cornerRadius
    }
}

extension XCCollectionViewTileLayout: XCComposedCollectionViewLayoutCompatible {
    public static var defaultAdapterType: XCComposedCollectionViewLayoutAdapter.Type {
        return XCCollectionViewTileLayoutAdapter.self
    }
}
