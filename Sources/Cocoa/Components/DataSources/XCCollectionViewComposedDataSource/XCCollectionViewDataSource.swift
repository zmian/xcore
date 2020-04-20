//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

@objcMembers
open class XCCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    /// The global section index of the data source in collection view.
    open var globalSection = 0

    /// The collection view of the data source.
    open weak var collectionView: UICollectionView?

    /// A convenience property to access data source's navigation controller.
    open var navigationController: UINavigationController? {
        collectionView?.viewController?.navigationController
    }

    public override init() {
        super.init()
    }

    // MARK: - Layout 2.0

    open func collectionView(_ collectionView: UICollectionView, itemAttributesAt indexPath: IndexPath) -> CGSize? {
        nil
    }

    open func collectionView(_ collectionView: UICollectionView, headerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        (false, nil)
    }

    open func collectionView(_ collectionView: UICollectionView, footerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        (false, nil)
    }
}

// MARK: - UICollectionViewDataSource

extension XCCollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError(because: .subclassMustImplement)
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let kind = UICollectionView.SupplementaryViewKind(rawValue: kind)
        var supplementaryView: UICollectionReusableView?

        switch kind {
            case .header:
                supplementaryView = self.collectionView(collectionView, viewForHeaderInSectionAt: indexPath)
            case .footer:
                supplementaryView = self.collectionView(collectionView, viewForFooterInSectionAt: indexPath)
            default:
                break
        }

        guard let reusableSupplementaryView = supplementaryView else {
            // Return a dummy cell, this happens when collection view datasources change but
            // collection view did not update section and item counts. In some cases,
            // collection view queries and crash if no valid view is found.
            return collectionView.dequeueReusableSupplementaryView(kind, for: indexPath)
        }

        return reusableSupplementaryView
    }

    open func collectionView(_ collectionView: UICollectionView, viewForHeaderInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        nil
    }

    open func collectionView(_ collectionView: UICollectionView, viewForFooterInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        nil
    }
}

// MARK: - UICollectionViewDelegate

extension XCCollectionViewDataSource {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension XCCollectionViewDataSource {
    // MARK: - Lifecycle

    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    }

    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

    open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
    }
}

// MARK: - Frame

extension XCCollectionViewDataSource {
    /// Returns the frame of the first valid item in the datasource. If there is no
    /// content to show returns `nil`.
    open var frameInCollectionView: CGRect? {
        guard let collectionView = collectionView else { return nil }
        var attributes: UICollectionViewLayoutAttributes?
        if let globalHeader = firstHeaderGlobalIndexPath {
            attributes = collectionView.layoutAttributesForSupplementaryElement(ofKind: .header, at: globalHeader)
        } else if let indexPath = firstRowGlobalIndexPath {
            attributes = collectionView.layoutAttributesForItem(at: indexPath)
        }
        return attributes?.frame
    }

    private var firstHeaderGlobalIndexPath: IndexPath? {
        guard let collectionView = collectionView else { return nil }
        let numberOfSections = self.numberOfSections(in: collectionView)
        for section in 0..<numberOfSections {
            if self.collectionView(collectionView, headerAttributesForSectionAt: section).enabled {
                return IndexPath(row: 0, section: section + globalSection)
            }
        }
        return nil
    }

    private var firstRowGlobalIndexPath: IndexPath? {
        guard let collectionView = collectionView else { return nil }
        let numberOfSections = self.numberOfSections(in: collectionView)
        for section in 0..<numberOfSections {
            if self.collectionView(collectionView, numberOfItemsInSection: section) > 0 {
                return IndexPath(row: 0, section: section + globalSection)
            }
        }
        return nil
    }
}

// MARK: - Convenience methods

extension XCCollectionViewDataSource {
    open var isEmpty: Bool {
        guard let collectionView = collectionView else {
            return true
        }
        let sectionsCount = numberOfSections(in: collectionView)
        guard sectionsCount > 0 else {
            return true
        }

        for section in 0..<sectionsCount {
            if self.collectionView(collectionView, numberOfItemsInSection: section) > 0 {
                return false
            }
        }
        return true
    }
}
