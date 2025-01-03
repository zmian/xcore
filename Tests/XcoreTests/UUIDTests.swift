//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct UUIDTests {
    @Test
    func zeroString() {
        #expect(UUID.zero.uuidString == "00000000-0000-0000-0000-000000000000")
    }

    @Test
    func bytes() {
        let uuid = UUID.zero
        let zeroBytes: [UInt8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        #expect(uuid.bytes == zeroBytes)
    }
}
