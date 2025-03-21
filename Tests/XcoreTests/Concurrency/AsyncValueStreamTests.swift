//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct AsyncValueStreamTests {
    @Test
    func currentValue() async {
        let internalStream = AsyncCurrentValueStream<Int>(5)

        let externalStream = AsyncValueStream(internalStream)

        // Verify current value == initial value
        #expect(externalStream.value == 5)

        // Produce new elements
        internalStream.send(1)
        #expect(externalStream.value == 1)
        internalStream.send(2)

        // Finish producing elements
        internalStream.finish()

        // Current Value
        #expect(externalStream.value == 2)
    }

    @Test
    func iterations() async {
        let internalStream = AsyncCurrentValueStream<Int>(5)
        let externalStream = AsyncValueStream(internalStream)

        Task {
            // Collect all produced elements
            var values: [Int] = []

            for await value in externalStream {
                values.append(value)
            }

            // Verify collected elements
            #expect(values == [5, 1, 2])
        }

        // Produce new elements
        internalStream.send(1)
        internalStream.send(2)

        // Finish producing elements
        internalStream.finish()
    }
}
