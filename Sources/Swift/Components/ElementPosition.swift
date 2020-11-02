//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct ElementPosition: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let primary = Self(rawValue: 1 << 0)
    public static let secondary = Self(rawValue: 1 << 1)
    public static let tertiary = Self(rawValue: 1 << 2)
    public static let quaternary = Self(rawValue: 1 << 3)
}
