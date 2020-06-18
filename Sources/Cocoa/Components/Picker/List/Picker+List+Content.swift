//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Picker.List {
    class Content: DynamicTableViewController {
        private var contentViewportHeightConstraint: NSLayoutConstraint?
        private let model: PickerListModel

        var isToolbarHidden = false

        /// The animation to use when reloading the table.
        var reloadAnimation: UITableView.RowAnimation = .automatic

        /// The preferred maximum number of items visible without scrolling.
        var preferredMaxVisibleItemsCount = Picker.List.appearance().preferredMaxVisibleItemsCount

        init(model: PickerListModel) {
            self.model = model
            super.init(nibName: nil, bundle: nil)
            self.style = .plain
        }

        @available(*, unavailable, message: "Use init(model:)")
        public required init?(coder aDecoder: NSCoder) {
            fatalError()
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            view.backgroundColor = .clear
            tableView.apply {
                $0.alwaysBounceVertical = false
                $0.isEmptyCellsHidden = true
                $0.isLastCellSeparatorHidden = true
                $0.contentInsetAdjustmentBehavior = .never
                $0.configureCell { [weak self] indexPath, cell, item in
                    guard let strongSelf = self else { return }
                    cell.accessibilityTraits = .button
                    cell.highlightedBackgroundColor = .appHighlightedBackground
                    cell.imageSize = 30
                    cell.avatarCornerRadius = 0
                    cell.avatarBorderWidth = 0
                    cell.subtitleFont = .app(style: .caption1)
                    strongSelf.model.configure(indexPath: indexPath, cell: cell, item: item)
                }
                $0.didScroll { [weak self] scrollView in
                    if scrollView.isTracking {
                        self?.didScrollToSelectedItem = true
                    }
                }
            }

            model.didChange { [weak self] in
                self?.reloadData()
            }
            model.didChangeItems { [weak self] in
                self?.reloadItems(indexPaths: $0)
            }

            reloadData()

            tableView.anchor.make {
                contentViewportHeightConstraint = $0.height.equalTo(contentViewportHeight).constraints.first
            }

            addContentSizeKvoObservers()
        }

        private var kvoToken: NSKeyValueObservation?
        private func addContentSizeKvoObservers() {
            kvoToken = tableView.observe(\.contentSize, options: .new) { [weak self] _, _ in
                self?.contentSizeUpdated()
                self?.scrollToSelectedItemIfNeeded()
            }
        }

        private func contentSizeUpdated() {
            contentViewportHeightConstraint?.constant = contentViewportHeight
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            UIAccessibility.post(notification: .screenChanged, argument: nil)
        }

        private func reloadItems(indexPaths: [IndexPath]) {
            guard !indexPaths.isEmpty, !tableView.sections.isEmpty else {
                reloadData()
                return
            }

            guard canReloadItems() else {
                return
            }

            let items = model.items
            indexPaths.forEach {
                tableView.sections[$0.section][$0.item] = items[$0.item]
            }

            tableView.reloadRows(at: indexPaths, with: reloadAnimation)
        }

        func reloadData() {
            guard canReloadItems() else {
                return
            }

            let hasSections = !tableView.sections.isEmpty

            tableView.sections = [
                Section(items: model.items)
            ]

            if hasSections {
                tableView.reloadSections(IndexSet(integer: 0), with: reloadAnimation)
            } else {
                tableView.reloadData()
            }
        }

        private func canReloadItems() -> Bool {
            model.reloadItems()

            guard !model.items.isEmpty else {
                // Nothing to display. Dismiss the picker view.
                DrawerScreen.dismiss()
                return false
            }

            return true
        }

        private var contentViewportHeight: CGFloat {
            var preferredContentHeight: CGFloat {
                let contentHeight = tableView.contentSize.height
                let itemHeight = contentHeight / CGFloat(model.items.count)
                return min(contentHeight, itemHeight * CGFloat(preferredMaxVisibleItemsCount))
            }

            let screenHeight = UIScreen.main.bounds.height
            var remainingViewportHeight = screenHeight - (AppConstants.statusBarHeight * 2)

            if !isToolbarHidden {
                remainingViewportHeight -= DrawerScreen.appearance().toolbarHeight
            }

            remainingViewportHeight /= 2

            return min(preferredContentHeight, remainingViewportHeight)
        }

        private var didScrollToSelectedItem = false
        private func scrollToSelectedItemIfNeeded() {
            guard !didScrollToSelectedItem else {
                return
            }

            guard let index = model.items.firstIndex(where: { $0.isSelected }) else {
                return
            }

            let indexPath = IndexPath(item: index, section: 0)
            tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        }
    }
}

extension Picker.List.Content: DrawerScreen.Content {
    var drawerContentView: UIView {
        view
    }
}
