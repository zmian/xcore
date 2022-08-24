//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class AsyncValueStreamTests: TestCase {
    func testCurrentValue() async {
        let internalStream = AsyncCurrentValueStream<Int>(5)

        let externalStream = AsyncValueStream(internalStream)

        // Verify current value == initial value
        XCTAssertEqual(externalStream.value, 5)

        // Produce new elements
        internalStream.yield(1)
        XCTAssertEqual(externalStream.value, 1)
        internalStream.yield(2)

        // Finish producing elements
        internalStream.finish()

        // Current Value
        XCTAssertEqual(externalStream.value, 2)
    }

    func testIterations() async {
        let internalStream = AsyncCurrentValueStream<Int>(5)
        let externalStream = AsyncValueStream(internalStream)

        Task {
            // Collection all produced elements
            var values: [Int] = []

            for await value in externalStream {
                values.append(value)
            }

            // Verify collected elements
            XCTAssertEqual(values, [5, 1, 2])
        }

        // Produce new elements
        internalStream.yield(1)
        internalStream.yield(2)

        // Finish producing elements
        internalStream.finish()
    }
}
