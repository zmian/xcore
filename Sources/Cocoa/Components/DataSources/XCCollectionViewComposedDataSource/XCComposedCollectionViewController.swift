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

public extension XCComposedCollectionViewController {
    enum LayoutType {
        case feed
        case `default`
    }
}

open class XCComposedCollectionViewController: UIViewController {
    public private(set) var collectionViewConstraints: NSLayoutConstraint.Edges!

    open var layoutType: LayoutType {
        return .default
    }

    /// The layout object `UICollectionView` uses to render itself.
    /// The layout can be changed to any subclass of `UICollectionViewLayout`.
    /// However, the layout must be set before accessing `collectionView` to ensure that it is applied correctly.
    /// The default value is `UICollectionViewFlowLayout`.
    open lazy var layout: UICollectionViewLayout = {
        switch layoutType {
            case .feed:
                return UICollectionViewFlexLayout()
            case .default:
                return UICollectionViewFlowLayout()
        }
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

    // MARK: DataSources

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

// MARK: UICollectionViewDelegate

extension XCComposedCollectionViewController {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        composedDataSource.collectionView(collectionView, didSelectItemAt: indexPath)
    }

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
}

// MARK: UICollectionViewDelegateFlexLayout

extension XCComposedCollectionViewController: UICollectionViewDelegateFlexLayout {
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return composedDataSource.collectionView(collectionView, sizeForItemAt: indexPath, availableWidth: width).height
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, heightForHeaderInSection section: Int, width: CGFloat) -> CGFloat {
        return composedDataSource.collectionView(collectionView, sizeForHeaderInSection: section, availableWidth: width).height
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, heightForFooterInSection section: Int, width: CGFloat) -> CGFloat {
        return composedDataSource.collectionView(collectionView, sizeForFooterInSection: section, availableWidth: width).height
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, verticalSpacingBetweenSectionAt section: Int, and nextSection: Int) -> CGFloat {
        return .defaultPadding
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, marginForSectionAt section: Int) -> UIEdgeInsets {
        return composedDataSource.collectionView(collectionView, marginForSectionAt: section)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, isShadowEnabledAt section: Int) -> Bool {
        return composedDataSource.collectionView(collectionView, isShadowEnabledForSectionAt: section)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, cornerRadiusAt section: Int) -> CGFloat {
        return composedDataSource.collectionView(collectionView, cornerRadiusForSectionAt: section)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, paddingForSectionAt section: Int) -> UIEdgeInsets {
        return 0
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, verticalSpacingBetweenItemAt indexPath: IndexPath, and nextIndexPath: IndexPath) -> CGFloat {
        return 0
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, marginForItemAt indexPath: IndexPath) -> UIEdgeInsets {
        return 0
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, paddingForItemAt indexPath: IndexPath) -> UIEdgeInsets {
        return 0
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, zIndexForItemAt indexPath: IndexPath) -> Int {
        return 0
    }
}
