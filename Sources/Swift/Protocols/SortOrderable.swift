//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public protocol SortOrderable {
    var sortOrder: Int { get }
}

extension Sequence where Element: SortOrderable {
    public func sorted() -> [Element] {
        sorted { $0.sortOrder < $1.sortOrder }
    }
}
