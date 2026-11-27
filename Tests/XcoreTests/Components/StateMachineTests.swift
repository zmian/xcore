//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct StateMachineTests {
    @Test
    func transitionWhenAllowed() throws {
        var machine = StateMachine(AppStatus.SessionState.signedOut)
        try machine.transition(to: .unlocked)
        #expect(machine.state == .unlocked)
    }

    @Test
    func transitionWhenDisallowed() {
        var machine = StateMachine(AppStatus.SessionState.signedOut)
        #expect(throws: InvalidStateTransition<AppStatus.SessionState>.self) {
            try machine.transition(to: .locked)
        }
        #expect(machine.state == .signedOut)
    }

    @Test
    func transitionIfAllowed() {
        var machine = StateMachine(AppStatus.SessionState.unlocked)
        let locked = machine.transitionIfAllowed(to: .locked)
        #expect(locked)
        #expect(machine.state == .locked)
        let lockedAgain = machine.transitionIfAllowed(to: .locked)
        #expect(!lockedAgain)
        #expect(machine.state == .locked)
    }
}

struct HUDPresentationStateTests {
    @Test
    func beginShowConsumesSuppression() {
        var state = HUD.PresentationState.hiddenSuppressingNextShow
        let shouldShow = state.beginShow()
        #expect(!shouldShow)
        #expect(state == .hidden)
        #expect(state.isHidden)
    }

    @Test
    func hidePreservesSuppressionArming() {
        var state = HUD.PresentationState.visibleSuppressingNextShow
        state.beginHide()
        #expect(state == .hiddenSuppressingNextShow)
        let shouldShow = state.beginShow()
        #expect(!shouldShow)
        #expect(state == .hidden)
    }

    @Test
    func armSuppressionFromVisible() {
        var state = HUD.PresentationState.visible
        state.armSuppression()
        #expect(state == .visibleSuppressingNextShow)
        #expect(!state.isHidden)
    }
}
