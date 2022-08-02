//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Swift

// MARK: - Identifiable Auto Implementation for RawRepresentable

extension Identifiable where Self: RawRepresentable, RawValue == String {
    public var id: RawValue {
        rawValue
    }
}
