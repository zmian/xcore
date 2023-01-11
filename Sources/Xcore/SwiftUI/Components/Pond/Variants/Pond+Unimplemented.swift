//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct UnimplementedPond: Pond {
    public let id = "unimplemented"

    public init() {}

    public func get<T>(_ type: T.Type, _ key: Key) -> T? {
        XCTFail("\(Self.self).get is unimplemented")
        return nil
    }

    public func set<T>(_ key: Key, value: T?) {
        XCTFail("\(Self.self).set is unimplemented")
    }

    public func remove(_ key: Key) {
        XCTFail("\(Self.self).remove is unimplemented")
    }

    public func contains(_ key: Key) -> Bool {
        XCTFail("\(Self.self).contains is unimplemented")
        return false
    }
}

// MARK: - Dot Syntax Support

extension Pond where Self == UnimplementedPond {
    /// Returns unimplemented variant of `Pond`.
    public static var unimplemented: Self { .init() }
}
