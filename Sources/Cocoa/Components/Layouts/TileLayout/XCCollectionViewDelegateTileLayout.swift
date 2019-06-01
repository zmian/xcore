//
// XCCollectionViewDelegateTileLayout.swift
//
// Copyright © 2019 Xcore
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

@objc public protocol XCCollectionViewDelegateTileLayout: UICollectionViewDelegate {
    // MARK: Sizes

    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForHeaderInSection section: Int, width: CGFloat) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForFooterInSection section: Int, width: CGFloat) -> CGFloat

    // MARK: Margins

    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, verticalSpacingBetweenSectionAt section: Int, and nextSection: Int) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, marginForSectionAt section: Int) -> UIEdgeInsets
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, verticalSpacingBetweenItemAt indexPath: IndexPath, and nextIndexPath: IndexPath) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, zIndexForItemAt indexPath: IndexPath) -> Int

    // MARK: Decorations

    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, shadowEnabledAt section: Int) -> Bool
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, cornerRadiusAt section: Int) -> CGFloat
}
