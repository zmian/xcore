//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class AppStatusSessionStateTests: TestCase {
    func testCanTransition() {
        var state: AppStatus.SessionState

        state = .locked
        XCTAssertFalse(state.canTransition(to: .locked))
        XCTAssertTrue(state.canTransition(to: .unlocked))
        XCTAssertTrue(state.canTransition(to: .signedOut))

        state = .unlocked
        XCTAssertTrue(state.canTransition(to: .locked))
        XCTAssertFalse(state.canTransition(to: .unlocked))
        XCTAssertTrue(state.canTransition(to: .signedOut))

        state = .signedOut
        XCTAssertFalse(state.canTransition(to: .locked))
        XCTAssertTrue(state.canTransition(to: .unlocked))
        XCTAssertFalse(state.canTransition(to: .signedOut))
    }
}
