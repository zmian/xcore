//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public protocol PickerListModel {
    var items: [DynamicTableModel] { get }
    func didChange(_ callback: @escaping () -> Void)
    func didChangeItems(_ callback: @escaping ([IndexPath]) -> Void)
    func configure(indexPath: IndexPath, cell: DynamicTableViewCell, item: DynamicTableModel)
    func reloadItems()
}

// MARK: - Default implementation

extension PickerListModel {
    public func didChange(_ callback: @escaping () -> Void) { }
    public func didChangeItems(_ callback: @escaping ([IndexPath]) -> Void) { }
    public func configure(indexPath: IndexPath, cell: DynamicTableViewCell, item: DynamicTableModel) { }
    public func reloadItems() { }
}
