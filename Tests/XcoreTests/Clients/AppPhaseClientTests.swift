//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
import Combine
@testable import Xcore

final class AppPhaseClientTests: TestCase {
    func testDefault() {
        DependencyValues.appPhase(.live)

        var viewModel = ViewModel()
        var receivedPhase: AppPhase?
        viewModel.receive { receivedPhase = $0 }

        viewModel.send(.launched)
        XCTAssertEqual(receivedPhase, .launched)

        viewModel.send(.background)
        XCTAssertEqual(receivedPhase, .background)
    }
}

extension AppPhaseClientTests {
    private struct ViewModel {
        @Dependency(\.appPhase) private var appPhase
        private var cancellable: AnyCancellable?

        func send(_ phase: AppPhase) {
            appPhase.send(phase)
        }

        mutating func receive(_ callback: @escaping (AppPhase) -> Void) {
            cancellable = appPhase.receive.sink { phase in
                callback(phase)
            }
        }
    }
}
