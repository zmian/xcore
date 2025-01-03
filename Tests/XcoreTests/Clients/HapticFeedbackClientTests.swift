//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

@MainActor
struct HapticFeedbackClientTests {
    @Test
    func basics() {
        let triggeredFeedback = LockIsolated<HapticFeedbackClient.Style?>(nil)

        let viewModel = withDependencies {
            $0.hapticFeedback = .init(trigger: { style in
                triggeredFeedback.setValue(style)
            })
        } operation: {
            ViewModel()
        }

        viewModel.triggerSelectionFeedback()

        #expect(triggeredFeedback.value == .selection)
    }
}

private final class ViewModel {
    @Dependency(\.hapticFeedback) var hapticFeedback

    func triggerSelectionFeedback() {
        hapticFeedback(.selection)
    }
}
