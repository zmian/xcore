//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

@MainActor
final class HapticFeedbackClientTests: TestCase {
    func testDefault() async {
        let triggeredFeedbackIsolated = ActorIsolated<HapticFeedbackClient.Style?>(nil)

        let viewModel = withDependencies {
            $0.hapticFeedback = .init(trigger: { style in
                Task {
                    await triggeredFeedbackIsolated.setValue(style)
                }
            })
        } operation: {
            ViewModel()
        }

        viewModel.triggerSelectionFeedback()

        await Task.megaYield()
        let triggeredFeedback = await triggeredFeedbackIsolated.value
        XCTAssertEqual(triggeredFeedback, .selection)
    }
}

private final class ViewModel {
    @Dependency(\.hapticFeedback) var hapticFeedback

    func triggerSelectionFeedback() {
        hapticFeedback(.selection)
    }
}
