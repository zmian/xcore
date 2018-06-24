//
// XCCollectionViewDataSource.swift
//
// Copyright © 2014 Zeeshan Mian
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
    /// An internal property to reference `UICollectionView` that `XCCollectionViewDataSource`
    /// use to implement auto-resizing cells, header, and footer. This is automatically
    /// set by the `XCCollectionViewComposedDataSource` when it is necessary.
    internal weak var _sizeCollectionView: UICollectionView?

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
}

// MARK: UICollectionViewDataSource

extension XCCollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("[XCCollectionViewDataSource] Should be implemented by subclasses.")
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var supplementaryView: UICollectionReusableView?

        switch kind {
            case UICollectionElementKindSectionHeader:
                supplementaryView = self.collectionView(collectionView, viewForHeaderInSectionAt: indexPath)
            case UICollectionElementKindSectionFooter:
                supplementaryView = self.collectionView(collectionView, viewForFooterInSectionAt: indexPath)
            default:
                break
        }
        return supplementaryView ?? UICollectionReusableView()
    }
}

// MARK: UICollectionViewDelegate

extension XCCollectionViewDataSource {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension XCCollectionViewDataSource {
    open func collectionView(_ collectionView: UICollectionView, insetForSectionAt section: Int) -> UIEdgeInsets {
        return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
    }

    open func collectionView(_ collectionView: UICollectionView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0
    }

    open func collectionView(_ collectionView: UICollectionView, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
    }

    // MARK: Lifecycle

    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    }

    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

    open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
    }
}

// MARK: Header and Footer

extension XCCollectionViewDataSource {
    open func collectionView(_ collectionView: UICollectionView, viewForHeaderInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        return nil
    }

    open func collectionView(_ collectionView: UICollectionView, viewForFooterInSectionAt indexPath: IndexPath) -> UICollectionReusableView? {
        return nil
    }
}

// MARK: Sizes

extension XCCollectionViewDataSource {
    internal func availableWidth(for collectionView: UICollectionView, section: Int) -> CGFloat {
        let sectionInset = self.collectionView(collectionView, insetForSectionAt: section)
        let sectionInsetHorizontal = sectionInset.horizontal
        let contentInsetHorizontal = collectionView.contentInset.horizontal
        let finalWidth = collectionView.bounds.width - sectionInsetHorizontal - contentInsetHorizontal - 0.01
        return finalWidth
    }

    open func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let sizeCollectionView = _sizeCollectionView else {
            return .zero
        }

        let availableWidth = self.availableWidth(for: collectionView, section: indexPath.section)
        let cell = self.collectionView(sizeCollectionView, cellForItemAt: indexPath)
        return cell.contentView.sizeFitting(width: availableWidth)
    }

    open func collectionView(_ collectionView: UICollectionView, sizeForHeaderInSection section: Int) -> CGSize {
        guard let sizeCollectionView = _sizeCollectionView else {
            return .zero
        }

        let availableWidth = self.availableWidth(for: collectionView, section: section)

        if let headerView = self.collectionView(sizeCollectionView, viewForHeaderInSectionAt: IndexPath(item: 0, section: section)) {
            return headerView.sizeFitting(width: availableWidth)
        } else {
            return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize ?? .zero
        }
    }

    open func collectionView(_ collectionView: UICollectionView, sizeForFooterInSection section: Int) -> CGSize {
        guard let sizeCollectionView = _sizeCollectionView else {
            return .zero
        }

        let availableWidth = self.availableWidth(for: collectionView, section: section)

        if let footerView = self.collectionView(sizeCollectionView, viewForFooterInSectionAt: IndexPath(item: 0, section: section)) {
            return footerView.sizeFitting(width: availableWidth)
        } else {
            return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize ?? .zero
        }
    }
}

// MARK: Frame

extension XCCollectionViewDataSource {
    /// Returns the frame of the first valid item in the datasource.
    /// If there is no content to show returns `nil`.
    open var frameInCollectionView: CGRect? {
        guard let collectionView = collectionView else { return nil }
        var attributes: UICollectionViewLayoutAttributes?
        if let globalHeader = firstHeaderGlobalIndexPath {
            attributes = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.SupplementaryViewKind.header.identifier, at: globalHeader)
        } else if let indexPath = firstRowGlobalIndexPath {
            attributes = collectionView.layoutAttributesForItem(at: indexPath)
        }
        return attributes?.frame
    }

    private var firstHeaderGlobalIndexPath: IndexPath? {
        guard let collectionView = collectionView else { return nil }
        let numberOfSections = self.numberOfSections(in: collectionView)
        for section in 0..<numberOfSections {
            if self.collectionView(collectionView, sizeForHeaderInSection: section).height > 0 {
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
