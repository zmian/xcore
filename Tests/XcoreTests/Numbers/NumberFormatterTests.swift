//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct NumberFormatterTests {
    @Test
    func fractionLength() {
        let formatter = NumberFormatter()
        formatter.fractionLength = 2...2

        #expect(formatter.fractionLength == 2...2)
        #expect(formatter.minimumFractionDigits == 2)
        #expect(formatter.maximumFractionDigits == 2)

        formatter.fractionLength = 0...8
        #expect(formatter.fractionLength == 0...8)
        #expect(formatter.minimumFractionDigits == 0)
        #expect(formatter.maximumFractionDigits == 8)
    }
}
