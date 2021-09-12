//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension UUID {
    public static let zero = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!

    /// Returns bytes representation of `self`.
    public var bytes: [UInt8] {
        [
            uuid.0,
            uuid.1,
            uuid.2,
            uuid.3,
            uuid.4,
            uuid.5,
            uuid.6,
            uuid.7,
            uuid.8,
            uuid.9,
            uuid.10,
            uuid.11,
            uuid.12,
            uuid.13,
            uuid.14,
            uuid.15
        ]
    }
}
