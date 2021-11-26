//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public protocol KeyValueStoreKey {
    var id: String { get }
}

// MARK: - Auto Implementation for RawRepresentable

extension KeyValueStoreKey where Self: RawRepresentable, RawValue == String {
    public var id: RawValue {
        rawValue
    }
}
