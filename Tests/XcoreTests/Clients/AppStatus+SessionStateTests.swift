//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct AppStatusSessionStateTests {
    @Test
    func canTransition() {
        var state: AppStatus.SessionState

        state = .locked
        #expect(!state.canTransition(to: .locked))
        #expect(state.canTransition(to: .unlocked))
        #expect(state.canTransition(to: .signedOut))

        state = .unlocked
        #expect(state.canTransition(to: .locked))
        #expect(!state.canTransition(to: .unlocked))
        #expect(state.canTransition(to: .signedOut))

        state = .signedOut
        #expect(!state.canTransition(to: .locked))
        #expect(state.canTransition(to: .unlocked))
        #expect(!state.canTransition(to: .signedOut))
    }
}
