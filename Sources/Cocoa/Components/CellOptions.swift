//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

public struct CellOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let move = Self(rawValue: 1 << 0)
    public static let delete = Self(rawValue: 1 << 1)
    public static let none: Self = []
    public static let all: Self = [move, delete]
}
