//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class HapticFeedbackClientTests: TestCase {
    func testDefault() {
        var triggeredFeedback: HapticFeedbackClient.Style?

        let viewModel = withDependencies {
            $0.hapticFeedback = .init(trigger: { style in
                triggeredFeedback = style
            })
        } operation: {
            ViewModel()
        }

        viewModel.triggerSelectionFeedback()
        XCTAssertEqual(triggeredFeedback, .selection)
    }
}

private final class ViewModel {
    @Dependency(\.hapticFeedback) var hapticFeedback

    func triggerSelectionFeedback() {
        hapticFeedback(.selection)
    }
}
