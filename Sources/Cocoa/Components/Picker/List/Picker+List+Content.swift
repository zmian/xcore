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

        /// The animation to use when reloading the table.
        var reloadAnimation: UITableView.RowAnimation = .automatic

        /// The maximum number of items visible without scrolling.
        var maxVisibleItemsCount = 5

        var isToolbarHidden = false

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

            let items = model.items
            indexPaths.forEach {
                tableView.sections[$0.section][$0.item] = items[$0.item]
            }

            tableView.reloadRows(at: indexPaths, with: reloadAnimation)
        }

        func reloadData() {
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

        private var contentViewportHeight: CGFloat {
            let contentHeight = tableView.contentSize.height
            let itemHeight = contentHeight / CGFloat(model.items.count)
            return min(contentHeight, itemHeight * CGFloat(maxVisibleItemsCount))
        }
    }
}

extension Picker.List.Content: DrawerScreen.Content {
    var drawerContentView: UIView {
        view
    }
}
