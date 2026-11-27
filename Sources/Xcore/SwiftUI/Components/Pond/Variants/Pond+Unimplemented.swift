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
        reportIssue(#"Unimplemented: @Dependency(\.pond).get"#)
        return nil
    }

    public func set<T: Codable>(_ key: Key, value: T?) {
        reportIssue(#"Unimplemented: @Dependency(\.pond).set"#)
    }

    public func remove(_ key: Key) {
        reportIssue(#"Unimplemented: @Dependency(\.pond).remove"#)
    }

    public func contains(_ key: Key) -> Bool {
        reportIssue(#"Unimplemented: @Dependency(\.pond).contains"#)
        return false
    }
}

// MARK: - Dot Syntax Support

extension Pond where Self == UnimplementedPond {
    /// Returns the unimplemented variant of `Pond`.
    public static var unimplemented: Self { .init() }
}