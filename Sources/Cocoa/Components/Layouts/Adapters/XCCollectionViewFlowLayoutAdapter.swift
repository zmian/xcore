//
// XCCollectionViewFlowLayoutAdapter.swift
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

// MARK: - XCCollectionViewFlowLayoutCustomizable

public protocol XCCollectionViewFlowLayoutCustomizable {
    func sectionInset(_ layout: UICollectionViewLayout, for section: Int) -> UIEdgeInsets
    func minimumLineSpacing(_ layout: UICollectionViewLayout, for section: Int) -> CGFloat
    func minimumInteritemSpacing(_ layout: UICollectionViewLayout, for section: Int) -> CGFloat
}

extension XCCollectionViewFlowLayoutCustomizable {
    public func sectionInset(_ layout: UICollectionViewLayout, for section: Int) -> UIEdgeInsets {
        return (layout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
    }

    public func minimumLineSpacing(_ layout: UICollectionViewLayout, for section: Int) -> CGFloat {
        return (layout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0
    }

    public func minimumInteritemSpacing(_ layout: UICollectionViewLayout, for section: Int) -> CGFloat {
        return (layout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
    }
}

open class XCCollectionViewFlowLayoutAdapter: XCComposedCollectionViewLayoutAdapter {
    /// Internal never rendered collection view just to calculate sizes in case datasource needs it
    private let sizeCollectionView = XCFakeCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
}

// MARK: - UICollectionViewDelegateFlowLayout

extension XCCollectionViewFlowLayoutAdapter: UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let attributes = composedDataSource.collectionView(collectionView, itemAttributesAt: indexPath) else {
            let availableWidth = self.availableWidth(for: indexPath.section, in: collectionView)
            return XCDataSourceSizeCalculator.estimatedItemSize(
                in: composedDataSource,
                at: indexPath,
                availableWidth: availableWidth
            )
        }
        return attributes
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let attributes = composedDataSource.collectionView(collectionView, headerAttributesForSectionAt: section)
        guard attributes.enabled else { return .zero }
        guard let size = attributes.size else {
            let availableWidth = self.availableWidth(for: section, in: collectionView)
            return XCDataSourceSizeCalculator.estimatedHeaderSize(
                in: composedDataSource,
                for: section,
                availableWidth: availableWidth
            )
        }
        return size
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let attributes = composedDataSource.collectionView(collectionView, footerAttributesForSectionAt: section)
        guard attributes.enabled else { return .zero }
        guard let size = attributes.size else {
            let availableWidth = self.availableWidth(for: section, in: collectionView)
            return XCDataSourceSizeCalculator.estimatedFooterSize(
                in: composedDataSource,
                for: section,
                availableWidth: availableWidth
            )
        }
        return size
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset(for: section, in: collectionView)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let source = composedDataSource.index(for: section)

        guard let custom = source.dataSource as? XCCollectionViewFlowLayoutCustomizable else {
            return (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0
        }

        return custom.minimumLineSpacing(collectionViewLayout, for: source.localSection)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let source = composedDataSource.index(for: section)

        guard let custom = source.dataSource as? XCCollectionViewFlowLayoutCustomizable else {
            return (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
        }

        return custom.minimumInteritemSpacing(collectionViewLayout, for: source.localSection)
    }
}

extension XCCollectionViewFlowLayoutAdapter {
    private func sectionInset(for section: Int, in collectionView: UICollectionView) -> UIEdgeInsets {
        let source = composedDataSource.index(for: section)

        guard let custom = source.dataSource as? XCCollectionViewFlowLayoutCustomizable else {
            return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        }

        return custom.sectionInset(collectionView.collectionViewLayout, for: source.localSection)
    }

    private func availableWidth(for section: Int, in collectionView: UICollectionView) -> CGFloat {
        let inset = sectionInset(for: section, in: collectionView)
        let sectionInsetHorizontal = inset.horizontal
        let contentInsetHorizontal = collectionView.contentInset.horizontal
        let finalWidth = collectionView.bounds.width - sectionInsetHorizontal - contentInsetHorizontal - 0.01
        return finalWidth
    }
}

extension UICollectionViewFlowLayout: XCComposedCollectionViewLayoutCompatible {
    public static var defaultAdapterType: XCComposedCollectionViewLayoutAdapter.Type {
        return XCCollectionViewFlowLayoutAdapter.self
    }
}

// MARK: - XCFakeCollectionView

private final class XCFakeCollectionView: UICollectionView {
    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return CollectionViewDequeueCache.shared.dequeueCell(identifier: identifier)
    }

    override func dequeueReusableSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        return CollectionViewDequeueCache.shared.dequeueSupplementaryView(kind: elementKind, identifier: identifier)
    }
}
