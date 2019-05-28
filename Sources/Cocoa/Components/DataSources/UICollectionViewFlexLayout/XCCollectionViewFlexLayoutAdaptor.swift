//
//  XCCollectionViewFlexLayoutAdaptor.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 28/05/2019.
//

import Foundation

open class XCCollectionViewFlexLayoutAdaptor: XCComposedCollectionViewLayoutAdaptor, UICollectionViewDelegateFlexLayout {
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return composedDataSource.collectionView(collectionView, sizeForItemAt: indexPath, availableWidth: width).height
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, heightForHeaderInSection section: Int, width: CGFloat) -> CGFloat {
        return composedDataSource.collectionView(collectionView, sizeForHeaderInSection: section, availableWidth: width).height
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, heightForFooterInSection section: Int, width: CGFloat) -> CGFloat {
        return composedDataSource.collectionView(collectionView, sizeForFooterInSection: section, availableWidth: width).height
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, verticalSpacingBetweenSectionAt section: Int, and nextSection: Int) -> CGFloat {
        return .defaultPadding
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, marginForSectionAt section: Int) -> UIEdgeInsets {
        let source = composedDataSource.index(for: section)
        guard
            let custom = source.dataSource as? XCCollectionViewFlexLayoutCustomizable,
            let isFullWidth = custom.isFullWidth?(),
            isFullWidth
        else {
            return UIEdgeInsets(horizontal: .defaultPadding)
        }
        return .zero
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, isShadowEnabledAt section: Int) -> Bool {
        let source = composedDataSource.index(for: section)
        guard
            let custom = source.dataSource as? XCCollectionViewFlexLayoutCustomizable,
            let isShadowEnabled = custom.isShadowEnabled?()
        else {
            return true
        }
        return isShadowEnabled
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, cornerRadiusAt section: Int) -> CGFloat {
        let source = composedDataSource.index(for: section)
        guard
            let custom = source.dataSource as? XCCollectionViewFlexLayoutCustomizable,
            let cornerRadius = custom.cornerRadiusForTile?()
        else {
            return 11
        }
        return cornerRadius
    }
}

@objc protocol XCCollectionViewFlexLayoutCustomizable {
    @objc optional func isFullWidth() -> Bool
    @objc optional func isShadowEnabled() -> Bool
    @objc optional func cornerRadiusForTile() -> CGFloat
}
