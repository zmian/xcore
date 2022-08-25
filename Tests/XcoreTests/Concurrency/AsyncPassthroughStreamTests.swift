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
        stream.send(1)
        stream.send(2)

        // Finish producing elements
        stream.finish()
    }

    func testIterations_makeAsyncStream() async {
        let stream = AsyncPassthroughStream<Int>()

        let asyncStream = stream.makeAsyncStream()

        Task {
            // Collection all produced elements
            var values: [Int] = []

            for await value in asyncStream {
                values.append(value)
            }

            // Verify collected elements
            XCTAssertEqual(values, [1, 2])
        }

        Task {
            // Collection all produced elements
            var values: [Int] = []

            for await value in asyncStream {
                values.append(value)
            }

            // Verify collected elements
            XCTAssertEqual(values, [1, 2])
        }

        // Produce new elements
        stream.send(1)
        stream.send(2)

        // Finish producing elements
        stream.finish()
    }

    func testIterations_asyncStream_directly() async {
        let stream = AsyncStream<Int> {
            $0.yield(1)
            $0.yield(2)
            $0.finish()
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

        Task {
            // Collection all produced elements
            var values: [Int] = []

            for await value in stream {
                values.append(value)
            }

            // Verify collected elements
            XCTAssertEqual(values, [])
        }
    }
}
