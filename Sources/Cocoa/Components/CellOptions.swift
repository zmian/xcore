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

    public static let move = CellOptions(rawValue: 1 << 0)
    public static let delete = CellOptions(rawValue: 1 << 1)
    public static let none: CellOptions = []
    public static let all: CellOptions = [move, delete]
}
