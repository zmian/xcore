//
// UITableView+Reusable.swift
//
// Copyright © 2017 Xcore
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

extension UITableView {
    private struct AssociatedKey {
        static var registeredCells = "registeredCells"
        static var registeredHeaderFooterViews = "registeredHeaderFooterViews"
    }

    private var registeredCells: Set<String> {
        get { return associatedObject(&AssociatedKey.registeredCells, default: Set<String>()) }
        set { setAssociatedObject(&AssociatedKey.registeredCells, value: newValue) }
    }

    private var registeredHeaderFooterViews: Set<String> {
        get { return associatedObject(&AssociatedKey.registeredHeaderFooterViews, default: Set<String>()) }
        set { setAssociatedObject(&AssociatedKey.registeredHeaderFooterViews, value: newValue) }
    }

    private func register<T: UITableViewCell>(_ cell: T.Type) {
        guard let nib = UINib(named: String(describing: cell), bundle: Bundle(for: T.self)) else {
            register(cell, forCellReuseIdentifier: T.reuseIdentifier)
            return
        }

        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    private func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ view: T.Type) {
        guard let nib = UINib(named: String(describing: view), bundle: Bundle(for: T.self)) else {
            register(view, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
            return
        }

        register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    private func registerIfNeeded<T: UITableViewCell>(_ cell: T.Type) {
        guard !registeredCells.contains(T.reuseIdentifier) else { return }
        registeredCells.insert(T.reuseIdentifier)
        register(cell)
    }

    private func registerHeaderFooterViewIfNeeded<T: UITableViewHeaderFooterView>(_ view: T.Type) {
        guard !registeredHeaderFooterViews.contains(T.reuseIdentifier) else { return }
        registeredHeaderFooterViews.insert(T.reuseIdentifier)
        registerHeaderFooterView(view)
    }
}

extension UITableView {
    /// Returns a reusable `UITableViewHeaderFooterView` instance for the class inferred by the return type.
    ///
    /// - Parameter indexPath: An index number that identifies a section of the table.
    /// - Returns: The header view associated with the section, or `nil` if the section does not have a header view.
    public func headerView<T: UITableViewHeaderFooterView>(forSection section: Int) -> T? {
        return headerView(forSection: section) as? T
    }

    /// Returns a reusable `UITableViewHeaderFooterView` instance for the class inferred by the return type.
    ///
    /// - Parameter indexPath: An index number that identifies a section of the table.
    /// - Returns: The header view associated with the section, or `nil` if the section does not have a header view.
    public func footerView<T: UITableViewHeaderFooterView>(forSection section: Int) -> T? {
        return footerView(forSection: section) as? T
    }

    /// Returns a reusable header or footer view instance for the class inferred by the return type.
    ///
    /// - Returns: A reusable `UITableViewHeaderFooterView` instance.
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        registerHeaderFooterViewIfNeeded(T.self)

        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError(because: .dequeueFailed(for: "UITableViewHeaderFooterView", identifier: T.reuseIdentifier))
        }

        return view
    }

    /// Returns a reusable `UITableViewCell` instance for the class inferred by the return type.
    ///
    /// - Parameter indexPath: The index path specifying the location of the cell in the table view.
    /// - Returns: A reusable `UITableViewCell` instance.
    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        registerIfNeeded(T.self)

        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError(because: .dequeueFailed(for: "UITableViewCell", identifier: T.reuseIdentifier))
        }

        return cell
    }
}
