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
        DependencyValues.withValues {
            $0.appPhase = .live
        } operation: {
            let viewModel = ViewModel()
            var receivedPhase: AppPhase?
            viewModel.receive { receivedPhase = $0 }

            viewModel.send(.launched(launchOptions: nil))
            XCTAssertEqual(receivedPhase, .launched(launchOptions: nil))

            viewModel.send(.background)
            XCTAssertEqual(receivedPhase, .background)
        }
    }
}

extension AppPhaseClientTests {
    private final class ViewModel {
        @Dependency(\.appPhase) private var appPhase
        private var cancellable: AnyCancellable?

        func send(_ phase: AppPhase) {
            appPhase.send(phase)
        }

        func receive(_ callback: @escaping (AppPhase) -> Void) {
            cancellable = appPhase.receive.sink { appPhase in
                callback(appPhase)
            }
        }
    }
}
