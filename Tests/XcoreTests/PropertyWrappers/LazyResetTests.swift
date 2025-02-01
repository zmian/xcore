//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct LazyResetTests {
    @Test
    func basics() {
        struct Example {
            @LazyReset(7)
            var x: Int

            mutating func reset() {
                _x.reset()
            }
        }

        var example = Example()

        #expect(example.x == 7)
        example.x = 100
        #expect(example.x == 100)
        example.reset()
        #expect(example.x == 7)
    }
}
