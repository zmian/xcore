//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class AsyncCurrentValueStreamTests: TestCase {
    func testCurrentValue() async {
        let stream = AsyncCurrentValueStream<Int>(5)

        // Verify current value == initial value
        XCTAssertEqual(stream.value, 5)

        // Produce new elements
        stream.send(1)
        XCTAssertEqual(stream.value, 1)

        stream.send(2)

        // Finish producing elements
        stream.finish()

        // Current Value
        XCTAssertEqual(stream.value, 2)
    }

    func testIterations() async {
        let stream = AsyncCurrentValueStream<Int>(5)

        Task {
            // Collection all produced elements
            var values: [Int] = []

            for await value in stream {
                values.append(value)
            }

            // Verify collected elements
            XCTAssertEqual(values, [5, 1, 2])
        }

        Task {
            // Collection all produced elements
            var values: [Int] = []

            for await value in stream {
                values.append(value)
            }

            // Verify collected elements
            XCTAssertEqual(values, [5, 1, 2])
        }

        // Produce new elements
        stream.send(1)
        stream.send(2)

        // Finish producing elements
        stream.finish()
    }
}
