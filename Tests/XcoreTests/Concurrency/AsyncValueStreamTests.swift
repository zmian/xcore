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

        let collected = Task {
            var values: [Int] = []
            for await value in externalStream {
                values.append(value)
            }
            return values
        }

        internalStream.send(1)
        internalStream.send(2)
        internalStream.finish()

        #expect(await collected.value == [5, 1, 2])
    }
}
