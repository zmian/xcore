//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct BoxTests {
    @Test
    func box() {
        let box = Box("Hello, world!")
        #expect(box.value == "Hello, world!")
    }

    @Test
    func boxEquality() {
        let box1 = Box(1)
        let box2 = Box(1)
        #expect(box1 == box2)

        let box3 = Box(3)
        #expect(box1 != box3)
    }
}
