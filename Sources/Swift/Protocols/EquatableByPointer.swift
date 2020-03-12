//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

public protocol EquatableByPointer: class, Equatable {
}

extension EquatableByPointer {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        let lhs = Unmanaged<Self>.passUnretained(lhs).toOpaque()
        let rhs = Unmanaged<Self>.passUnretained(rhs).toOpaque()
        return lhs == rhs
    }
}
