//
//  XCCollectionViewDelegateTileLayout.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 16/05/2019.
//

import UIKit

public protocol XCCollectionViewDelegateTileLayout: UICollectionViewDelegate {
    // Sizes
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat?
    // Header & Footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, headerAttributesInSection section: Int, width: CGFloat) -> (Bool, CGFloat?)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, footerAttributesInSection section: Int, width: CGFloat) -> (Bool, CGFloat?)

    // Margins
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, verticalSpacingBetweenSectionAt section: Int, and nextSection: Int) -> CGFloat

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, isTileEnabledInSection section: Int) -> Bool
}

public extension XCCollectionViewDelegateTileLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, headerAttributesInSection section: Int, width: CGFloat) -> (Bool, CGFloat?) {
        return (false, nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, footerAttributesInSection section: Int, width: CGFloat) -> (Bool, CGFloat?) {
        return (false, nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat? {
        return nil
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, verticalSpacingBetweenSectionAt section: Int, and nextSection: Int) -> CGFloat {
        return collectionViewLayout.verticalIntersectionSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, isTileEnabledInSection section: Int) -> Bool {
        return true
    }
}
