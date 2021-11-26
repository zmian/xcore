//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

#if DEBUG
import Foundation

public struct FailingPond<Key>: Pond where Key: Identifiable, Key.ID == String {
    public init() {}

    public func get<T>(_ type: T.Type, _ key: Key) -> T? {
        internal_XCTFail("\(Self.self).get is unimplemented")
        return nil
    }

    public func set<T>(_ key: Key, value: T?) {
        internal_XCTFail("\(Self.self).set is unimplemented")
    }

    public func remove(_ key: Key) {
        internal_XCTFail("\(Self.self).remove is unimplemented")
    }

    public func contains(_ key: Key) -> Bool {
        internal_XCTFail("\(Self.self).contains is unimplemented")
        return false
    }
}

// MARK: - Dot Syntax Support

extension Pond {
    /// Returns failing variant of `Pond`.
    public static func failing<Key>() -> Self where Self == FailingPond<Key> {
        .init()
    }
}
#endif
