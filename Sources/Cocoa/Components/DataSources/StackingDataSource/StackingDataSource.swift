//
// StackingDataSource.swift
//
// Copyright © 2019 Xcore
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

open class StackingDataSource: XCCollectionViewDataSource {
    public typealias CellProvider = (UICollectionView, IndexPath, Any?) -> XCCollectionViewCell
    public let viewModel: StackingDataSourceViewModel
    private let cellProvider: CellProvider

    private let selectorIndex = 0
    private let mainAlertIndex = 1
    private let stackIndex = 2

    private var _isExtended: Bool = false
    private var isExtended: Bool {
        get { _isExtended }
        set {
            guard _isExtended != newValue else {
                return
            }

            _isExtended = newValue
            let reloadSet = IndexSet(integersIn: globalSection...(globalSection + allSectionsCount - 1))

            // swiftlint:disable:next trailing_closure
            collectionView?.performBatchUpdates({
                collectionView?.collectionViewLayout.invalidateLayout()
                collectionView?.reloadSections(reloadSet)
            })
        }
    }

    private var allSectionsCount: Int {
        guard !viewModel.isEmpty else {
            return 0
        }

        // Selector + MainAlert + stack
        return 1 + 1 + viewModel.numberOfSections
    }

    private var isStackVisible: Bool {
        viewModel.numberOfSections > 1 && !isExtended
    }

    /// A boolean property indicating stack header is visible.
    private var isStackHeaderEnabled: Bool {
        viewModel.numberOfSections > 1 && isExtended
    }

    public init(collectionView: UICollectionView, viewModel: StackingDataSourceViewModel, cellProvider: @escaping CellProvider) {
        self.viewModel = viewModel
        self.cellProvider = cellProvider
        super.init(collectionView: collectionView)

        viewModel.didChange { [weak self] in
            self?.refreshContent()
        }
    }

    private func refreshContent() {
        // If tile is empty we set it to default value
        if allSectionsCount == 0 {
            _isExtended = false
        }
        collectionView?.reloadData()
    }

    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        allSectionsCount
    }

    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case selectorIndex:
                return isStackHeaderEnabled ? 1 : 0
            case stackIndex:
                return isStackVisible ? 1 : 0
            case mainAlertIndex:
                return viewModel.itemsCount(for: 0)
            default:
                return isExtended ? viewModel.itemsCount(for: section - 2) : 0
        }
    }

    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let globalIndex = indexPath.with(globalSection)
        switch indexPath.section {
            case selectorIndex:
                let cell = collectionView.dequeueReusableCell(for: globalIndex) as HeaderCell
                cell.apply {
                    $0.hideButton.text = viewModel.showLessButtonTitle
                    $0.clearButton.text = viewModel.clearButtonTitle
                    $0.clearButton.isHidden = viewModel.isClearButtonHidden
                }

                cell.configure(didTapHide: { [weak self] in
                    self?.isExtended = false
                }, didTapClear: { [weak self] in
                    self?.clearAll()
                })
                return cell
            case stackIndex:
                let cell = collectionView.dequeueReusableCell(for: globalIndex) as StackEffect
                cell.configure(isTwoOrMore: viewModel.numberOfSections >= 3)
                return cell
            default:
                let index = alertIndexFor(indexPath: indexPath)
                let cell = cellProvider(collectionView, globalIndex, viewModel.item(at: index))
                return cell
        }
    }

    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            case selectorIndex, stackIndex:
                return
            default:
                // Expand if first cell is tapped
                if isStackVisible {
                    isExtended = true
                    return
                }
                viewModel.didTap(at: alertIndexFor(indexPath: indexPath))
        }
    }

    public func alertIndexFor(indexPath: IndexPath) -> IndexPath {
        switch indexPath.section {
            case mainAlertIndex:
                return .init(row: indexPath.row, section: 0)
            default:
                return .init(row: indexPath.row, section: indexPath.section - 2)
        }
    }

    private func clearAll() {
        viewModel.clearAll()
    }
}

// MARK: - Layout

extension StackingDataSource: XCCollectionViewTileLayoutCustomizable {
    public func isTileEnabled(in layout: XCCollectionViewTileLayout) -> Bool {
        true
    }

    public func cornerRadius(in layout: XCCollectionViewTileLayout) -> CGFloat {
        layout.cornerRadius
    }

    public func isShadowEnabled(in layout: XCCollectionViewTileLayout, forSectionAt section: Int) -> Bool {
        switch section {
            case selectorIndex, stackIndex:
                return false
            case mainAlertIndex:
                return viewModel.isShadowEnabled
            default:
                return viewModel.isShadowEnabled
        }
    }

    public func verticalBottomSpacing(in layout: XCCollectionViewTileLayout, forSectionAt section: Int) -> CGFloat {
        switch section {
            case selectorIndex:
                return isStackVisible ? 0.0 : layout.verticalIntersectionSpacing
            case mainAlertIndex:
                return isStackVisible ? 0.0 : layout.verticalIntersectionSpacing
            default:
                return layout.verticalIntersectionSpacing
        }
    }

    public func parentIdentifier(in layout: XCCollectionViewTileLayout, forSectionAt section: Int) -> String? {
        switch section {
            case selectorIndex, stackIndex:
                return nil
            default:
                return viewModel.tileIdentifier
        }
    }
}
