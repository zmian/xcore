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

public let XCCollectionViewFlowLayoutAutomaticSize: CGSize = {
    if #available(iOS 10.0, *) {
        return UICollectionViewFlowLayoutAutomaticSize
    } else {
        return CGSize(.greatestFiniteMagnitude)
    }
}()

open class XCComposedCollectionViewController: UIViewController {
    public private(set) var collectionViewConstraints = [NSLayoutConstraint]()

    /// The layout object `UICollectionView` uses to render itself.
    /// The layout can be changed to any subclass of `UICollectionViewLayout`.
    /// However, the layout must be set before accessing `collectionView` to ensure that it is applied correctly.
    /// The default value is `UICollectionViewFlowLayout`.
    open var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()

    open lazy var collectionView: UICollectionView = {
        let collectionView = XCCollectionView(frame: .zero, collectionViewLayout: self.layout)
        return collectionView
    }()

    /// An option to determine whether the `scrollView`'s `top` and `bottom` is constrained
    /// to `topLayoutGuide` and `bottomLayoutGuide`. The default value is `[]`.
    open var constraintToLayoutGuideOptions: LayoutGuideOptions = []

    /// The distance that the collectionView is inset from the enclosing view.
    /// The default value is `.zero`.
    @objc open dynamic var contentInset: UIEdgeInsets = .zero {
        didSet {
            collectionViewConstraints.at(0)?.constant = contentInset.left
            collectionViewConstraints.at(1)?.constant = contentInset.right
            collectionViewConstraints.at(2)?.constant = contentInset.top
            collectionViewConstraints.at(3)?.constant = contentInset.bottom
        }
    }

    // MARK: DataSources

    private let _composedDataSource = XCCollectionViewComposedDataSource()
    open var composedDataSource: XCCollectionViewComposedDataSource {
        return _composedDataSource
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionViewConstraints = constraintsForViewToFillSuperview(collectionView, padding: contentInset, constraintToLayoutGuideOptions: constraintToLayoutGuideOptions).activate()
        setup(collectionView: collectionView)
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

// MARK: Setup Methods

extension XCComposedCollectionViewController {
    private func setup(collectionView: UICollectionView) {
        composedDataSource.dataSources = dataSources(for: collectionView)
        collectionView.dataSource = composedDataSource
        collectionView.delegate = self
    }
}

// MARK: UICollectionViewDelegate

extension XCComposedCollectionViewController {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        composedDataSource.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

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

    // MARK: Lifecycle

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
