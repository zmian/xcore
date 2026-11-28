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

        let first = Task {
            var values: [Int] = []
            for await value in stream {
                values.append(value)
            }
            return values
        }

        let second = Task {
            var values: [Int] = []
            for await value in stream {
                values.append(value)
            }
            return values
        }

        stream.send(1)
        stream.send(2)
        stream.finish()

        #expect(await first.value == [5, 1, 2])
        #expect(await second.value == [5, 1, 2])
    }
}
