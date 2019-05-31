//
//  XCCollectionViewDelegateTileLayout.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 16/05/2019.
//

import UIKit

@objc public protocol XCCollectionViewDelegateTileLayout: UICollectionViewDelegate {
    // Header & Footer
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, isHeaderEnabledInSection section: Int) -> Bool
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, isFooterEnabledInSection section: Int) -> Bool
    // Sizes
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForHeaderInSection section: Int, width: CGFloat) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForFooterInSection section: Int, width: CGFloat) -> CGFloat

    // Margins
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, verticalSpacingBetweenSectionAt section: Int, and nextSection: Int) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, marginForSectionAt section: Int) -> UIEdgeInsets
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, verticalSpacingBetweenItemAt indexPath: IndexPath, and nextIndexPath: IndexPath) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, zIndexForItemAt indexPath: IndexPath) -> Int

    // Decorations
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, isShadowEnabledAt section: Int) -> Bool
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, cornerRadiusAt section: Int) -> CGFloat
}
