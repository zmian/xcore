//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

open class StackingDataSource: XCCollectionViewDataSource, XCCollectionViewTileLayoutCustomizable {
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

    // MARK: - Layout

    open func sectionConfiguration(in layout: XCCollectionViewTileLayout, for section: Int) -> XCCollectionViewTileLayout.SectionConfiguration {
        var configuration = layout.defaultSectionConfiguration
        configuration.isTileEnabled = isTileEnabled(forSectionAt: section)
        configuration.isShadowEnabled = isShadowEnabled(forSectionAt: section)
        configuration.bottomSpacing = bottomSpacing(forSectionAt: section) ?? configuration.bottomSpacing
        configuration.parentIdentifier = parentIdentifier(forSectionAt: section)
        return configuration
    }
}

extension StackingDataSource {
    private func isTileEnabled(forSectionAt section: Int) -> Bool {
        switch section {
            case selectorIndex, stackIndex:
                return false
            case mainAlertIndex:
                return true
            default:
                return true
        }
    }

    private func isShadowEnabled(forSectionAt section: Int) -> Bool {
        switch section {
            case selectorIndex, stackIndex:
                return false
            case mainAlertIndex:
                return viewModel.isShadowEnabled
            default:
                return viewModel.isShadowEnabled
        }
    }

    private func bottomSpacing(forSectionAt section: Int) -> CGFloat? {
        switch section {
            case selectorIndex:
                return isStackVisible ? 0.0 : nil
            case mainAlertIndex:
                return isStackVisible ? 0.0 : nil
            default:
                return nil
        }
    }

    private func parentIdentifier(forSectionAt section: Int) -> String? {
        switch section {
            case selectorIndex, stackIndex:
                return nil
            default:
                return viewModel.tileIdentifier
        }
    }
}
