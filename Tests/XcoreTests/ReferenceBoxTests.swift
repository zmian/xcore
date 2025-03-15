//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct ReferenceBoxTests {
    @Test
    func box() {
        let box = ReferenceBox("Hello, world!")
        #expect(box.value == "Hello, world!")
    }

    @Test
    func boxEquality() {
        let box1 = ReferenceBox(1)
        let box2 = ReferenceBox(1)
        #expect(box1 == box2)

        let box3 = ReferenceBox(3)
        #expect(box1 != box3)
    }
}
