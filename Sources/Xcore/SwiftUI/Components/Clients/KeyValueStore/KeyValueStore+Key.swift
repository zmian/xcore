//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// Ideally, We can remove this type when Swift allows us to generalize a
// protocol with "associatedtype" requirement. For example:
//
// `typealias KeyValueStoreKey = Identifiable where ID == String`
public protocol KeyValueStoreKey {
    var id: String { get }
}

extension KeyValueStoreKey where Self: Identifiable, ID == String {}

extension KeyValueStoreKey where Self: RawRepresentable, RawValue == String {
    public var id: RawValue {
        rawValue
    }
}
