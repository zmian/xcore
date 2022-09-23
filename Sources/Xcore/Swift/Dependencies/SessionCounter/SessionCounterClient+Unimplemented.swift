//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

#if DEBUG
import Foundation

public struct UnimplementedSessionCounterClient: SessionCounterClient {
    public var count: Int {
        internal_XCTFail("\(Self.self).count is unimplemented")
        return 0
    }

    public func increment() {
        internal_XCTFail("\(Self.self).increment is unimplemented")
    }
}

// MARK: - Dot Syntax Support

extension SessionCounterClient where Self == UnimplementedSessionCounterClient {
    /// Returns unimplemented variant of `SessionCounterClient`.
    public static var unimplemented: Self {
        .init()
    }
}
#endif
