//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public protocol PondKey {
    var id: String { get }
}

// MARK: - Auto Implementation for RawRepresentable

extension PondKey where Self: RawRepresentable, RawValue == String {
    public var id: RawValue {
        rawValue
    }
}

extension PondKey where Self: Identifiable, ID == String {}
