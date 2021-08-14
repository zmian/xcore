//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
import Combine
@testable import Xcore

final class AppDelegatePhaseClientTests: TestCase {
    func testDefault() {
        DependencyValues.appDelegatePhase(.live)

        var viewModel = ViewModel()
        var receivedPhase: AppDelegatePhase?
        viewModel.receive { receivedPhase = $0 }

        viewModel.send(.finishedLaunching)
        XCTAssertEqual(receivedPhase, .finishedLaunching)
    }
}

extension AppDelegatePhaseClientTests {
    private struct ViewModel {
        @Dependency(\.appDelegatePhase) private var appPhase
        private var cancellable: AnyCancellable?

        func send(_ phase: AppDelegatePhase) {
            appPhase.send(phase)
        }

        mutating func receive(_ callback: @escaping (AppDelegatePhase) -> Void) {
            cancellable = appPhase.receive.sink { phase in
                callback(phase)
            }
        }
    }
}
