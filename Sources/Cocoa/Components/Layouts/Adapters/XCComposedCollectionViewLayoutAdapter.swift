//
//  XCComposedCollectionViewLayoutAdapter.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 28/05/2019.
//

import Foundation

open class XCComposedCollectionViewLayoutAdapter: NSObject {
    private var _composedDataSource = XCCollectionViewComposedDataSource()
    var composedDataSource: XCCollectionViewComposedDataSource {
        return _composedDataSource
    }
    
    private var didSelectItem: ((IndexPath) -> Void)?
    func didSelectItem(_ callback: @escaping (IndexPath) -> Void) {
        didSelectItem = callback
    }

    func attach(to viewController: XCComposedCollectionViewController) {
        _composedDataSource = viewController.composedDataSource
        collectionView.delegate = self
    }
}

extension XCComposedCollectionViewLayoutAdapter: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem?(indexPath)
        composedDataSource.collectionView(collectionView, didSelectItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        return composedDataSource.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        return composedDataSource.collectionView(collectionView, willDisplaySupplementaryView: view, forElementKind: elementKind, at: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        return composedDataSource.collectionView(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        return composedDataSource.collectionView(collectionView, didEndDisplayingSupplementaryView: view, forElementOfKind: elementKind, at: indexPath)
    }
}
