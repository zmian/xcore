//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Combine
@testable import Xcore

struct AppPhaseClientTests {
    @Test
    func basics() {
        let viewModel = withDependencies {
            $0.appPhase = .live
        } operation: {
            ViewModel()
        }

        var receivedPhase: AppPhase?
        viewModel.receive { receivedPhase = $0 }

        viewModel.send(.launched(launchOptions: nil))
        #expect(receivedPhase == .launched(launchOptions: nil))

        viewModel.send(.background)
        #expect(receivedPhase == .background)
    }
}

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
