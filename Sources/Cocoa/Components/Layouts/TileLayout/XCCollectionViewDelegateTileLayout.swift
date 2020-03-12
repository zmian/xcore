//
// XCCollectionViewDelegateTileLayout.swift
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public protocol XCCollectionViewDelegateTileLayout: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, headerAttributesInSection section: Int, width: CGFloat) -> (Bool, CGFloat?)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, footerAttributesInSection section: Int, width: CGFloat) -> (Bool, CGFloat?)

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, estimatedHeightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, estimatedHeaderHeightInSection section: Int, width: CGFloat) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, estimatedFooterHeightInSection section: Int, width: CGFloat) -> CGFloat

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, sectionConfigurationAt section: Int) -> XCCollectionViewTileLayout.SectionConfiguration?
}

extension XCCollectionViewDelegateTileLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat? {
        nil
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, headerAttributesInSection section: Int, width: CGFloat) -> (Bool, CGFloat?) {
        (false, nil)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, footerAttributesInSection section: Int, width: CGFloat) -> (Bool, CGFloat?) {
        (false, nil)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, estimatedHeightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat {
        collectionViewLayout.estimatedItemHeight
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, estimatedHeaderHeightInSection section: Int, width: CGFloat) -> CGFloat {
        collectionViewLayout.estimatedHeaderFooterHeight
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, estimatedFooterHeightInSection section: Int, width: CGFloat) -> CGFloat {
        collectionViewLayout.estimatedHeaderFooterHeight
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, sectionConfigurationAt section: Int) -> XCCollectionViewTileLayout.SectionConfiguration? {
        nil
    }
}
