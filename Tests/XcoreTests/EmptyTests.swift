//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import SwiftUI
@testable import Xcore

struct EmptyTests {
    @Test
    func equality() {
        #expect(Empty() == Empty())
    }

    @Test
    func identifiable() {
        #expect(Empty().id == Empty().id)
    }

    @Test
    func comparable() {
        #expect(!(Empty() < Empty()))
        #expect(!(Empty() > Empty()))

        #expect(Empty() <= Empty())
        #expect(Empty() >= Empty())
    }
}
