//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import UIKit
@testable import Xcore

struct ElapsedTimeTests {
    @Test
    func basics() {
        let et1 = ElapsedTime()
        var et2 = et1

        #expect(et1 == et2)

        et2.reset()
        #expect(et1 != et2)
    }
}
