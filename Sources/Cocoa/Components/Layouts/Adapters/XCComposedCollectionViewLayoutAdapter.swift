//
//  XCComposedCollectionViewLayoutAdapter.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 28/05/2019.
//

import Foundation

open class XCComposedCollectionViewLayoutAdapter: NSObject {
    private weak var viewController: XCComposedCollectionViewController?

    private var _composedDataSource = XCCollectionViewComposedDataSource()
    var composedDataSource: XCCollectionViewComposedDataSource {
        return _composedDataSource
    }

    public required override init() {
        super.init()
    }

    func attach(to viewController: XCComposedCollectionViewController) {
        _composedDataSource = viewController.composedDataSource
        viewController.collectionView.delegate = self
        self.viewController = viewController
    }
}

extension XCComposedCollectionViewLayoutAdapter: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewController?.collectionView(collectionView, didSelectItemAt: indexPath)
        composedDataSource.collectionView(collectionView, didSelectItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewController?.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        composedDataSource.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        viewController?.collectionView(collectionView, willDisplaySupplementaryView: view, forElementKind: elementKind, at: indexPath)
        composedDataSource.collectionView(collectionView, willDisplaySupplementaryView: view, forElementKind: elementKind, at: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewController?.collectionView(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
        composedDataSource.collectionView(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        viewController?.collectionView(collectionView, didEndDisplayingSupplementaryView: view, forElementOfKind: elementKind, at: indexPath)
        composedDataSource.collectionView(collectionView, didEndDisplayingSupplementaryView: view, forElementOfKind: elementKind, at: indexPath)
    }
}
