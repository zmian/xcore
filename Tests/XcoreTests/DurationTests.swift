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
    func seconds() {
        let duration = Duration.seconds(2.5)
        let timeInterval = duration.seconds
        #expect(timeInterval == 2.5)
    }

    @Test
    func nanoseconds() {
        let ns1 = Duration.seconds(2.5).nanoseconds
        #expect(ns1 == 2500000000)

        let ns2 = Duration.nanoseconds(1929).nanoseconds
        #expect(ns2 == 1929)
    }

    @Test
    func minutes() {
        let s1 = Duration.minutes(2.5)
        #expect(s1.seconds == 150)
        #expect(s1 == .seconds(2.5 * 60))

        let s2 = Duration.minutes(5)
        #expect(s2.seconds == 300)
        #expect(s2 == .seconds(5 * 60))
    }
}
