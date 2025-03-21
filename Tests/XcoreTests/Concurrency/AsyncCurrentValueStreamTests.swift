//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct AsyncCurrentValueStreamTests {
    @Test
    func currentValue() async {
        let stream = AsyncCurrentValueStream<Int>(5)

        // Verify current value == initial value
        #expect(stream.value == 5)

        // Produce new elements
        stream.send(1)
        #expect(stream.value == 1)

        stream.send(2)

        // Finish producing elements
        stream.finish()

        // Current Value
        #expect(stream.value == 2)
    }

    @Test
    func iterations() async {
        let stream = AsyncCurrentValueStream<Int>(5)

        Task {
            // Collect all produced elements
            var values: [Int] = []

            for await value in stream {
                values.append(value)
            }

            // Verify collected elements
            #expect(values == [5, 1, 2])
        }

        Task {
            // Collect all produced elements
            var values: [Int] = []

            for await value in stream {
                values.append(value)
            }

            // Verify collected elements
            #expect(values == [5, 1, 2])
        }

        // Produce new elements
        stream.send(1)
        stream.send(2)

        // Finish producing elements
        stream.finish()
    }
}
