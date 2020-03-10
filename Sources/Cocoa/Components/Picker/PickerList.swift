//
// PickerList.swift
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

// MARK: - PickerListModel

public protocol PickerListModel {
    var items: [DynamicTableModel] { get }
    func didChange(_ callback: @escaping () -> Void)
    func didChangeItems(_ callback: @escaping ([IndexPath]) -> Void)
    func configure(indexPath: IndexPath, cell: DynamicTableViewCell, item: DynamicTableModel)
}

extension PickerListModel {
    public func didChange(_ callback: @escaping () -> Void) { }
    public func didChangeItems(_ callback: @escaping ([IndexPath]) -> Void) { }
    public func configure(indexPath: IndexPath, cell: DynamicTableViewCell, item: DynamicTableModel) { }
}

// MARK: - PickerList

open class PickerList: DynamicTableViewController {
    private var contentViewportHeightConstraint: NSLayoutConstraint?
    private let model: PickerListModel

    /// The animation to use when reloading the table.
    open var reloadAnimation: UITableView.RowAnimation = .automatic

    /// The maximum number of items visible without scrolling.
    open var maxVisibleItemsCount = 4

    public init(model: PickerListModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        self.style = .plain
    }

    @available(*, unavailable, message: "Use init(model:)")
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    open override func viewDidLoad() {
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

        view.anchor.make {
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

    open override func viewDidAppear(_ animated: Bool) {
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

    private func reloadData() {
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

extension PickerList: DrawerScreen.Content {
    open var drawerContentView: UIView {
        view
    }
}

// MARK: - API

extension PickerList {
    open func present() {
        DrawerScreen.present(self)
    }

    open func dismiss() {
        DrawerScreen.dismiss()
    }
}
