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
