//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct UnimplementedPond: Pond {
    public let id = "unimplemented"

    public init() {}

    public func get<T: Codable>(_ type: T.Type, _ key: Key) -> T? {
        reportIssue("\(Self.self).get is unimplemented")
        return nil
    }

    public func set<T: Codable>(_ key: Key, value: T?) {
        reportIssue("\(Self.self).set is unimplemented")
    }

    public func remove(_ key: Key) {
        reportIssue("\(Self.self).remove is unimplemented")
    }

    public func contains(_ key: Key) -> Bool {
        reportIssue("\(Self.self).contains is unimplemented")
        return false
    }
}

// MARK: - Dot Syntax Support

extension Pond where Self == UnimplementedPond {
    /// Returns the unimplemented variant of `Pond`.
    public static var unimplemented: Self { .init() }
}
