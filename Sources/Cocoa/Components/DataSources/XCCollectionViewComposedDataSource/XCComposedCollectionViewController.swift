//
// XCComposedCollectionViewController.swift
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

open class XCComposedCollectionViewController: UIViewController {
    public private(set) var collectionViewConstraints: NSLayoutConstraint.Edges!

    /// The layout object `UICollectionView` uses to render itself.
    ///
    /// The layout can be changed to any subclass of `UICollectionViewLayout`.
    ///
    /// The default value is `XCCollectionViewFlowLayout`.
    public var layout: XCComposedCollectionViewLayout = .init(XCCollectionViewFlowLayout()) {
        didSet {
            collectionView.collectionViewLayout = layout.collectionViewLayout
            layout.adapter.attach(to: self)
        }
    }

    open lazy var collectionView: UICollectionView = {
        XCCollectionView(frame: .zero, collectionViewLayout: layout.collectionViewLayout)
    }()

    /// The distance that the collectionView is inset from the enclosing view.
    ///
    /// The default value is `0`.
    @objc open dynamic var contentInset: UIEdgeInsets = 0 {
        didSet {
            guard oldValue != contentInset else { return }
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
            layout.adapter.attach(to: self)

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

        let topOffset = -offset.top
        let bottomOffset = contentSize.height - collectionView.frame.height + offset.bottom
        let middleOffset = dataSourceOffset - .maximumPadding - contentInset.top - midDataSourceDeltaOffset

        let newOffset = CGPoint(
            x: 0,
            y: min(bottomOffset, max(middleOffset, topOffset))
        )

        collectionView.setContentOffset(newOffset, animated: animated)
    }
}

// MARK: - UICollectionViewDelegate calls forwarded from XCComposedCollectionViewLayoutAdapter

extension XCComposedCollectionViewController {
    @objc open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    @objc open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

    @objc open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    }

    @objc open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

    @objc open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
    }
}
