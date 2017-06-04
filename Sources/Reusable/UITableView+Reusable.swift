//
// UITableView+Reusable.swift
//
// Copyright © 2017 Zeeshan Mian
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
        get { return objc_getAssociatedObject(self, &AssociatedKey.registeredCells) as? Set<String> ?? Set<String>() }
        set { objc_setAssociatedObject(self, &AssociatedKey.registeredCells, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var registeredHeaderFooterViews: Set<String> {
        get { return objc_getAssociatedObject(self, &AssociatedKey.registeredHeaderFooterViews) as? Set<String> ?? Set<String>() }
        set { objc_setAssociatedObject(self, &AssociatedKey.registeredHeaderFooterViews, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    fileprivate func register<T: UITableViewCell>(_ cell: T.Type) where T: Reusable {
        guard let nib = UINib(named: String(describing: cell), bundle: Bundle(for: T.self)) else {
            register(cell, forCellReuseIdentifier: T.reuseIdentifier)
            return
        }

        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    fileprivate func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ view: T.Type) where T: Reusable {
        guard let nib = UINib(named: String(describing: view), bundle: Bundle(for: T.self)) else {
            register(view, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
            return
        }

        register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    fileprivate func registerIfNeeded<T: UITableViewCell>(_ cell: T.Type) where T: Reusable {
        guard !registeredCells.contains(T.reuseIdentifier) else { return }
        registeredCells.insert(T.reuseIdentifier)
        register(cell)
    }

    fileprivate func registerHeaderFooterViewIfNeeded<T: UITableViewHeaderFooterView>(_ view: T.Type) where T: Reusable {
        guard !registeredHeaderFooterViews.contains(T.reuseIdentifier) else { return }
        registeredHeaderFooterViews.insert(T.reuseIdentifier)
        registerHeaderFooterView(view)
    }
}

extension UITableView {
    /// Returns a reusable `UITableViewHeaderFooterView` instance for the class inferred by the return type.
    ///
    /// - parameter indexPath: An index number that identifies a section of the table.
    ///
    /// - returns: The header view associated with the section, or `nil` if the section does not have a header view.
    public func headerView<T: UITableViewHeaderFooterView>(forSection section: Int) -> T? {
        return headerView(forSection: section) as? T
    }

    /// Returns a reusable `UITableViewHeaderFooterView` instance for the class inferred by the return type.
    ///
    /// - parameter indexPath: An index number that identifies a section of the table.
    ///
    /// - returns: The header view associated with the section, or `nil` if the section does not have a header view.
    public func footerView<T: UITableViewHeaderFooterView>(forSection section: Int) -> T? {
        return footerView(forSection: section) as? T
    }

    /// Returns a reusable header or footer view instance for the class inferred by the return type.
    ///
    /// - returns: A reusable `UITableViewHeaderFooterView` instance.
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: Reusable {
        registerHeaderFooterViewIfNeeded(T.self)

        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Failed to dequeue UITableViewHeaderFooterView with identifier: \(T.reuseIdentifier)")
        }

        return view
    }

    /// Returns a reusable `UITableViewCell` instance for the class inferred by the return type.
    ///
    /// - parameter indexPath: The index path specifying the location of the cell in the table view.
    ///
    /// - returns: A reusable `UITableViewCell` instance.
    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        registerIfNeeded(T.self)

        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue UITableViewCell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }
}
