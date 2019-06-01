//
// XCCollectionViewTileLayoutAdapter.swift
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

// MARK: - XCCollectionViewTileLayoutCustomizable

public protocol XCCollectionViewTileLayoutCustomizable {
    func tileAttributes(forSectionAt section: Int, layout: XCCollectionViewTileLayout) -> TileAttributes
}

extension XCCollectionViewTileLayoutCustomizable {
    public func tileAttributes(forSectionAt section: Int, layout: XCCollectionViewTileLayout) -> TileAttributes {
        return .none
    }
}

// MARK: - XCCollectionViewTileLayoutAdapter

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

        guard let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable else {
            return TileAttributes.none.margin
        }

        return custom.tileAttributes(forSectionAt: source.localSection, layout: collectionViewLayout).margin
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, shadowEnabledAt section: Int) -> Bool {
        let source = composedDataSource.index(for: section)

        guard let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable else {
            return TileAttributes.none.isShadowEnabled
        }

        return custom.tileAttributes(forSectionAt: source.localSection, layout: collectionViewLayout).isShadowEnabled
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, cornerRadiusAt section: Int) -> CGFloat {
        let source = composedDataSource.index(for: section)

        guard let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable else {
            return TileAttributes.none.cornerRadius
        }

        return custom.tileAttributes(forSectionAt: source.localSection, layout: collectionViewLayout).cornerRadius
    }
}

extension XCCollectionViewTileLayout: XCComposedCollectionViewLayoutCompatible {
    public static var defaultAdapterType: XCComposedCollectionViewLayoutAdapter.Type {
        return XCCollectionViewTileLayoutAdapter.self
    }
}
