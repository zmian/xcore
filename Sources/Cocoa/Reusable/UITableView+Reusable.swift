//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UITableView {
    private struct AssociatedKey {
        static var registeredCells = "registeredCells"
        static var registeredHeaderFooterViews = "registeredHeaderFooterViews"
    }

    private var registeredCells: Set<String> {
        get { associatedObject(&AssociatedKey.registeredCells, default: Set<String>()) }
        set { setAssociatedObject(&AssociatedKey.registeredCells, value: newValue) }
    }

    private var registeredHeaderFooterViews: Set<String> {
        get { associatedObject(&AssociatedKey.registeredHeaderFooterViews, default: Set<String>()) }
        set { setAssociatedObject(&AssociatedKey.registeredHeaderFooterViews, value: newValue) }
    }

    private func register<T: UITableViewCell>(_ cell: T.Type) {
        register(cell, forCellReuseIdentifier: T.reuseIdentifier)
    }

    private func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ view: T.Type) {
        register(view, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
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
    func headerView<T: UITableViewHeaderFooterView>(forSection section: Int) -> T? {
        headerView(forSection: section) as? T
    }

    /// Returns a reusable `UITableViewHeaderFooterView` instance for the class inferred by the return type.
    ///
    /// - Parameter indexPath: An index number that identifies a section of the table.
    /// - Returns: The header view associated with the section, or `nil` if the section does not have a header view.
    func footerView<T: UITableViewHeaderFooterView>(forSection section: Int) -> T? {
        footerView(forSection: section) as? T
    }

    /// Returns a reusable header or footer view instance for the class inferred by the return type.
    ///
    /// - Returns: A reusable `UITableViewHeaderFooterView` instance.
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
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
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        registerIfNeeded(T.self)

        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError(because: .dequeueFailed(for: "UITableViewCell", identifier: T.reuseIdentifier))
        }

        return cell
    }
}
