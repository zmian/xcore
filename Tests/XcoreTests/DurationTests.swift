//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct DurationTests {
    @Test
    func timeIntervalInit() {
        let duration = Duration.seconds(2.5)
        let timeInterval = TimeInterval(duration)
        #expect(timeInterval == 2.5)
    }
}
