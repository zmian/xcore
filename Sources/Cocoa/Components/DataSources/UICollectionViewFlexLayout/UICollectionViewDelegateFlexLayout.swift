//
//  UICollectionViewDelegateFlexLayout.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 16/05/2019.
//  Copyright © 2019 Clarity Money. All rights reserved.
//

import UIKit

@objc public protocol UICollectionViewDelegateFlexLayout: UICollectionViewDelegate {
    // Sizes
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, heightForHeaderInSection section: Int, width: CGFloat) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, heightForFooterInSection section: Int, width: CGFloat) -> CGFloat

    // Margins
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, verticalSpacingBetweenSectionAt section: Int, and nextSection: Int) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, marginForSectionAt section: Int) -> UIEdgeInsets
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, verticalSpacingBetweenItemAt indexPath: IndexPath, and nextIndexPath: IndexPath) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, zIndexForItemAt indexPath: IndexPath) -> Int

    // Decorations
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, isShadowEnabledAt section: Int) -> Bool
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, cornerRadiusAt section: Int) -> CGFloat
}
