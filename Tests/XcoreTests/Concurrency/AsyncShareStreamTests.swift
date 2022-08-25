//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class AsyncShareStreamTests: TestCase {
    func testIterations() async {
        let stream = AsyncStream<Int> {
            $0.yield(1)
            $0.yield(2)
            $0.yield(3)
            $0.finish()
        }
        .map { $0 * 10 }
        .share()

        await collectValues(from: stream)

//        XCTAssertEqual(values, ["d"])

//        XCTAssertEqual(values, [
//            "Stream 1 received: 10",
//            "Stream 2 received: 10",
//            "Stream 1 received: 20",
//            "Stream 2 received: 20",
//            "Stream 1 received: 30",
//            "Stream 2 received: 30"
//        ])
    }

    private func collectValues(from stream: some AsyncSequence) async {
        Task {
            print("Stream 1 Kicked off")

            for try await value in stream {
                print("Stream 1 received: \(value)")
//                values.append("Stream 1 received: \(value)")
            }
        }

        Task {
            print("Stream 2 Kicked off")

            for try await value in stream {
//                values.append("Stream 2 received: \(value)")
                print("Stream 2 received: \(value)")
            }
        }
    }
}

private var values: [String] = []
