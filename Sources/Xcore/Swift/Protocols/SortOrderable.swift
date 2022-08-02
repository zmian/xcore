//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public protocol SortOrderable {
    var sortOrder: Int { get }
}

extension Sequence where Element: SortOrderable {
    public func sorted() -> [Element] {
        sorted { $0.sortOrder < $1.sortOrder }
    }
}

// MARK: - Mutable

public protocol MutableSortOrderable: SortOrderable {
    var sortOrder: Int { get set }
}
