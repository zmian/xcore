//
// XCCollectionViewDataSource.swift
//
// Copyright © 2014 Xcore
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

@objcMembers
open class XCCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    /// The global section index of the data source in collection view.
    open var globalSection = 0

    /// The collection view of the data source.
    open weak var collectionView: UICollectionView?

    /// A convenience property to access data source's navigation controller.
    open var navigationController: UINavigationController? {
        return collectionView?.viewController?.navigationController
    }

    override init() {
        super.init()
    }

    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }

    // MARK: Layout 2.0

    open func collectionView(_ collectionView: UICollectionView, itemAttributesAt indexPath: IndexPath) -> CGSize? {
        return nil
    }

    open func collectionView(_ collectionView: UICollectionView, headerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        return (false, nil)
    }

    open func collectionView(_ collectionView: UICollectionView, footerAttributesForSectionAt section: Int) -> (enabled: Bool, size: CGSize?) {
        return (false, nil)
    }
}

// MARK: - UICollectionViewDataSource

extension XCCollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
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
        return nil
    }

    open func collectionView(_ collectionView: UICollectionView, viewForFooterInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        return nil
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
