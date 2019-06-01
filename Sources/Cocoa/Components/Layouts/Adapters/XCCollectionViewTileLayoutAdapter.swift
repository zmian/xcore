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
    func margin(forSectionAt section: Int, layout: XCCollectionViewTileLayout) -> UIEdgeInsets
    func cornerRadius(forSectionAt section: Int, layout: XCCollectionViewTileLayout) -> CGFloat
    func shadowEnabled(forSectionAt section: Int, layout: XCCollectionViewTileLayout) -> Bool
}

extension XCCollectionViewTileLayoutCustomizable {
    public func margin(forSectionAt section: Int, layout: XCCollectionViewTileLayout) -> UIEdgeInsets {
        return .zero
    }

    public func cornerRadius(forSectionAt section: Int, layout: XCCollectionViewTileLayout) -> CGFloat {
        return 0
    }

    public func shadowEnabled(forSectionAt section: Int, layout: XCCollectionViewTileLayout) -> Bool {
        return false
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
            return 0
        }

        return custom.margin(forSectionAt: source.localSection, layout: collectionViewLayout)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, shadowEnabledAt section: Int) -> Bool {
        let source = composedDataSource.index(for: section)

        guard let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable else {
            return false
        }

        return custom.shadowEnabled(forSectionAt: source.localSection, layout: collectionViewLayout)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, cornerRadiusAt section: Int) -> CGFloat {
        let source = composedDataSource.index(for: section)

        guard let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable else {
            return 0
        }

        return custom.cornerRadius(forSectionAt: source.localSection, layout: collectionViewLayout)
    }
}

extension XCCollectionViewTileLayout: XCComposedCollectionViewLayoutCompatible {
    public static var defaultAdapterType: XCComposedCollectionViewLayoutAdapter.Type {
        return XCCollectionViewTileLayoutAdapter.self
    }
}
