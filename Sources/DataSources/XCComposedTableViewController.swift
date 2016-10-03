//
// XCComposedTableViewController.swift
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

open class XCComposedTableViewController: UIViewController {
    fileprivate var estimatedRowHeightCache = Cache()
    /// Style must be set before accessing `tableView` to ensure that it is applied correctly.
    /// The default value is `.grouped`.
    public var style: UITableViewStyle = .grouped

    open lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: self.style)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.sectionFooterHeight = UITableViewAutomaticDimension
        return tableView
    }()

    // MARK: DataSources

    public let composedDataSource = XCTableViewComposedDataSource()

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        NSLayoutConstraint.constraintsForViewToFillSuperview(tableView).activate()
        setupTableView(forTableView: tableView)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tableView.reloadData() // Fixes invalid scroll position when a ViewController is pushed/popped
    }

    open func dataSources(forTableView tableView: UITableView) -> [XCTableViewDataSource] {
        return []
    }
}

// MARK: Setup Methods

extension XCComposedTableViewController {
    fileprivate func setupTableView(forTableView tableView: UITableView) {
        composedDataSource.dataSources = dataSources(forTableView: tableView)
        composedDataSource.registerClasses(for: tableView)
        tableView.dataSource = composedDataSource
        tableView.delegate = self
    }
}

// MARK: UITableViewDelegate

extension XCComposedTableViewController: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return composedDataSource.heightForRow(at: indexPath)
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dispatch.async.main {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.composedDataSource.tableView(tableView, didSelectRowAt: indexPath)
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
        estimatedRowHeightCache.set(height: cell.frame.size.height, forIndexPath: indexPath)
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
        return estimatedRowHeightCache.get(indexPath: indexPath)
    }
}

extension XCComposedTableViewController {
    /// There is UIKit bug that causes `UITableView` to jump when using `estimatedRowHeight`
    /// and reloading cells/sections or the entire table view.
    ///
    /// This solution patches the said bug of `UITableView` by caching
    /// heights and automatically switching to those when `reloadData`, `reloadCells`,
    /// or `reloadSection` methods are invoked.
    fileprivate struct Cache {
        private var dictionary = [String: CGFloat]()

        private func key(forIndexPath indexPath: IndexPath) -> String {
            return "\(indexPath.section)-\(indexPath.row)"
        }

        /// Set estimated cell height to cache.
        ///
        /// - parameter height:       The height to cache for the given index path.
        /// - parameter forIndexPath: The index path to cache
        mutating func set(height: CGFloat, forIndexPath: IndexPath) {
            dictionary[key(forIndexPath: forIndexPath)] = height
        }

        /// Get estimated cell height from cache.
        ///
        /// - parameter indexPath: The index path to get the cached heigh for.
        ///
        /// - returns: The cached height if exists; otherwise, `UITableViewAutomaticDimension`.
        func get(indexPath: IndexPath) -> CGFloat {
            guard let estimatedHeight = dictionary[key(forIndexPath: indexPath)] else {
                return UITableViewAutomaticDimension
            }

            return estimatedHeight
        }

        mutating func clearAll() {
            dictionary.removeAll(keepingCapacity: false)
        }

        mutating func clear(atIndexPath indexPath: IndexPath) {
            dictionary[key(forIndexPath: indexPath)] = nil
        }

        func heightExists(forIndexPath indexPath: IndexPath) -> Bool {
            return dictionary[key(forIndexPath: indexPath)] != nil
        }
    }
}
