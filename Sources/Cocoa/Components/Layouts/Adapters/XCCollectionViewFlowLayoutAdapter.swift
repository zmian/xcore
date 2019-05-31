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
    func sectionInset(for section: Int) -> UIEdgeInsets
    func minimumLineSpacing(for section: Int) -> CGFloat
    func minimumInteritemSpacing(for section: Int) -> CGFloat
}

extension XCCollectionViewFlowLayoutCustomizable {
    public func sectionInset(for section: Int) -> UIEdgeInsets {
        return .zero
    }

    public func minimumLineSpacing(for section: Int) -> CGFloat {
        return 0
    }

    public func minimumInteritemSpacing(for section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - XCCollectionViewFlowLayoutAdapter

open class XCCollectionViewFlowLayoutAdapter: XCComposedCollectionViewLayoutAdapter, UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = availableWidth(for: indexPath.section, in: collectionView)
        return composedDataSource.collectionView(collectionView, sizeForItemAt: indexPath, availableWidth: width)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset(for: section, in: collectionView)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let source = composedDataSource.index(for: section)

        guard let custom = source.dataSource as? XCCollectionViewFlowLayoutCustomizable else {
            return (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0
        }

        return custom.minimumLineSpacing(for: source.localSection)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let source = composedDataSource.index(for: section)

        guard let custom = source.dataSource as? XCCollectionViewFlowLayoutCustomizable else {
            return (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
        }

        return custom.minimumInteritemSpacing(for: source.localSection)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = availableWidth(for: section, in: collectionView)
        return composedDataSource.collectionView(collectionView, sizeForHeaderInSection: section, availableWidth: width)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = availableWidth(for: section, in: collectionView)
        return composedDataSource.collectionView(collectionView, sizeForFooterInSection: section, availableWidth: width)
    }
}

extension XCCollectionViewFlowLayoutAdapter {
    private func sectionInset(for section: Int, in collectionView: UICollectionView) -> UIEdgeInsets {
        let source = composedDataSource.index(for: section)

        guard let custom = source.dataSource as? XCCollectionViewFlowLayoutCustomizable else {
            return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        }

        return custom.sectionInset(for: source.localSection)
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
