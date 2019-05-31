//
// XCComposedTableViewController.swift
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

open class XCComposedTableViewController: UIViewController {
    public private(set) var tableViewConstraints: NSLayoutConstraint.Edges!

    /// There is UIKit bug that causes `UITableView` to jump when using
    /// `estimatedRowHeight` and reloading cells/sections or the entire table view.
    ///
    /// This solution patches the said bug by caching heights and automatically
    /// switching to those when `reloadData`, `reloadCells`, or `reloadSection`
    /// methods are invoked.
    private var estimatedRowHeightCache = IndexPathCache<CGFloat>(default: UITableView.automaticDimension)

    /// Style must be set before accessing `tableView` to ensure that it is applied
    /// correctly.
    ///
    /// The default value is `.grouped`.
    public var style: UITableView.Style = .grouped

    open lazy var tableView = UITableView(frame: .zero, style: self.style).apply {
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 44
        $0.estimatedSectionHeaderHeight = 0
        $0.estimatedSectionFooterHeight = 0
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.sectionFooterHeight = UITableView.automaticDimension
    }

    /// The distance that the tableView is inset from the enclosing view.
    ///
    /// The default value is `0`.
    @objc open dynamic var contentInset: UIEdgeInsets = 0 {
        didSet {
            tableViewConstraints.update(from: contentInset)
        }
    }

    // MARK: - DataSources

    private let _composedDataSource = XCTableViewComposedDataSource()
    open var composedDataSource: XCTableViewComposedDataSource {
        return _composedDataSource
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        tableView.apply {
            composedDataSource.dataSources = dataSources(for: $0)
            $0.dataSource = composedDataSource
            $0.delegate = self

            view.addSubview($0)
            tableViewConstraints = NSLayoutConstraint.Edges(
                $0.anchor.edges.equalToSuperview().inset(contentInset).constraints
            )
        }
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Fixes invalid scroll position when a view controller is pushed/popped.
        tableView.reloadData()
    }

    open func dataSources(for tableView: UITableView) -> [XCTableViewDataSource] {
        return []
    }

    open func scrollToTop(animated: Bool = true) {
        tableView.scrollToTop(animated: animated)
    }

    deinit {
        #if DEBUG
        Console.info("\(self) deinit")
        #endif
    }
}

// MARK: - UITableViewDelegate

extension XCComposedTableViewController: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return composedDataSource.heightForRow(at: indexPath)
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.composedDataSource.tableView(tableView, didSelectRowAt: indexPath)
        }
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return composedDataSource.heightForHeaderInSection(section)
    }

    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return composedDataSource.heightForFooterInSection(section)
    }

    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        composedDataSource.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        estimatedRowHeightCache[indexPath] = cell.frame.size.height
    }

    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        composedDataSource.tableView(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return composedDataSource.tableView(tableView, viewForHeaderInSection: section)
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return composedDataSource.tableView(tableView, viewForFooterInSection: section)
    }

    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedRowHeightCache[indexPath]
    }
}
