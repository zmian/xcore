//
//  XCCollectionViewFlowLayoutAdapter.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 28/05/2019.
//

import Foundation

open class XCCollectionViewFlowLayoutAdapter: XCComposedCollectionViewLayoutAdapter, UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = availableWidth(for: indexPath.section, in: collectionView)
        return composedDataSource.collectionView(collectionView, sizeForItemAt: indexPath, availableWidth: width)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset(for: section, in: collectionView)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
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
        return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
    }

    private func availableWidth(for section: Int, in collectionView: UICollectionView) -> CGFloat {
        let inset = sectionInset(for: section, in: collectionView)
        let sectionInsetHorizontal = inset.horizontal
        let contentInsetHorizontal = collectionView.contentInset.horizontal
        let finalWidth = collectionView.bounds.width - sectionInsetHorizontal - contentInsetHorizontal - 0.01
        return finalWidth
    }
}
