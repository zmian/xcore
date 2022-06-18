//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct NoopSessionCounterClient: SessionCounterClient {
    public var count: Int { 0 }
    public func increment() {}
}

// MARK: - Dot Syntax Support

extension SessionCounterClient where Self == NoopSessionCounterClient {
    /// Returns noop variant of `SessionCounterClient`.
    public static var noop: Self {
        .init()
    }
}
