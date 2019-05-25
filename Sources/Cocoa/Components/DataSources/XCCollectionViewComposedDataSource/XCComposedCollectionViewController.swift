//
// XCComposedCollectionViewController.swift
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

open class XCComposedCollectionViewController: UIViewController {
    public private(set) var collectionViewConstraints: NSLayoutConstraint.Edges!

    /// The layout object `UICollectionView` uses to render itself.
    /// The layout can be changed to any subclass of `UICollectionViewLayout`.
    /// However, the layout must be set before accessing `collectionView` to ensure that it is applied correctly.
    /// The default value is `XCCollectionViewFlowLayout`.
    open var layout: UICollectionViewLayout = {
        XCCollectionViewFlowLayout()
    }()

    open lazy var collectionView: UICollectionView = {
        XCCollectionView(frame: .zero, collectionViewLayout: self.layout)
    }()

    /// The distance that the collectionView is inset from the enclosing view.
    ///
    /// The default value is `0`.
    @objc open dynamic var contentInset: UIEdgeInsets = 0 {
        didSet {
            collectionViewConstraints.update(from: contentInset)
        }
    }

    // MARK: - DataSources

    private let _composedDataSource = XCCollectionViewComposedDataSource()
    open var composedDataSource: XCCollectionViewComposedDataSource {
        return _composedDataSource
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.apply {
            composedDataSource.dataSources = dataSources(for: $0)
            $0.dataSource = composedDataSource
            $0.delegate = self

            view.addSubview($0)
            collectionViewConstraints = NSLayoutConstraint.Edges(
                $0.anchor.edges.equalToSuperview().inset(contentInset).constraints
            )
        }
    }

    open func dataSources(for collectionView: UICollectionView) -> [XCCollectionViewDataSource] {
        return []
    }

    open func scrollToTop(animated: Bool = true) {
        collectionView.scrollToTop(animated: animated)
    }

    deinit {
        #if DEBUG
        Console.info("\(self) deinit")
        #endif
    }
}

// MARK: - UICollectionViewDelegate

extension XCComposedCollectionViewController {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        composedDataSource.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension XCComposedCollectionViewController: UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return composedDataSource.collectionView(collectionView, sizeForItemAt: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return composedDataSource.collectionView(collectionView, insetForSectionAt: section)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return composedDataSource.collectionView(collectionView, minimumLineSpacingForSectionAt: section)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return composedDataSource.collectionView(collectionView, minimumInteritemSpacingForSectionAt: section)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return composedDataSource.collectionView(collectionView, sizeForHeaderInSection: section)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return composedDataSource.collectionView(collectionView, sizeForFooterInSection: section)
    }

    // MARK: - Lifecycle

    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        return composedDataSource.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        return composedDataSource.collectionView(collectionView, willDisplaySupplementaryView: view, forElementKind: elementKind, at: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        return composedDataSource.collectionView(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        return composedDataSource.collectionView(collectionView, didEndDisplayingSupplementaryView: view, forElementOfKind: elementKind, at: indexPath)
    }
}

extension XCComposedCollectionViewController {
    /// Scrolls to the given `dataSource` in the collection view.
    ///
    /// - Parameters:
    ///   - dataSource: The data source to which collection view should scroll to.
    ///   - animated: `true` to animate the transition at a constant velocity to the
    ///               data source, `false` to make the transition immediate. The
    ///               default value is `true`.
    /// - Returns: `true` if successful; otherwise, `false`.
    @discardableResult
    public func scroll(to dataSource: XCCollectionViewDataSource, animated: Bool = true) -> Bool {
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize

        guard
            contentSize.height > 0,
            let dataSourceOffset = dataSource.frameInCollectionView?.origin.y,
            let dataSourceHeight = dataSource.frameInCollectionView?.size.height
        else {
            return false
        }

        let midDataSourceDeltaOffset: CGFloat = max((collectionView.frame.size.height - dataSourceHeight) / 2.0, 0.0)
        setDataSourceOffset(dataSourceOffset, midDataSourceDeltaOffset: midDataSourceDeltaOffset, animated: animated)
        return true
    }

    /// Sets the offset from the content view’s origin that corresponds to the data
    /// source origin.
    ///
    /// - Parameters:
    ///   - dataSourceOffset: A point that is offset from the content view’s origin.
    ///   - midDataSourceDeltaOffset: The offset of the middle of the data source
    ///                               delta. The default value is `0`.
    ///   - animated: `true` to animate the transition at a constant velocity to the
    ///               new offset, `false` to make the transition immediate. The
    ///               default value is `true`.
    public func setDataSourceOffset(_ dataSourceOffset: CGFloat, midDataSourceDeltaOffset: CGFloat = 0, animated: Bool = true) {
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
        let offset = collectionView.adjustedContentInset
        let newOffset = CGPoint(
            x: 0,
            y: min(
                contentSize.height - collectionView.frame.height + offset.bottom,
                max(
                    dataSourceOffset - offset.top - .maximumPadding - midDataSourceDeltaOffset,
                    -offset.top
                )
            )
        )
        collectionView.setContentOffset(newOffset, animated: animated)
    }
}
