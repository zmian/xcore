//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class AsyncPassthroughStreamTests: TestCase {
    func testIterations() async {
        let stream = AsyncPassthroughStream<Int>()

        Task {
            // Collection all produced elements
            var values: [Int] = []

            for await value in stream {
                values.append(value)
            }

            // Verify collected elements
            XCTAssertEqual(values, [1, 2])
        }

        Task {
            // Collection all produced elements
            var values: [Int] = []

            for await value in stream {
                values.append(value)
            }

            // Verify collected elements
            XCTAssertEqual(values, [1, 2])
        }

        // Produce new elements
        stream.yield(1)
        stream.yield(2)

        // Finish producing elements
        stream.finish()
    }
}
