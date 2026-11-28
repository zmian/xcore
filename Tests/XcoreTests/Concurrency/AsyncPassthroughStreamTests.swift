//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct AsyncPassthroughStreamTests {
    @Test
    func iterations() async {
        let stream = AsyncPassthroughStream<Int>()

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

        #expect(await first.value == [1, 2])
        #expect(await second.value == [1, 2])
    }

    @Test
    func iterations_asyncStream_directly() async {
        let stream = AsyncStream<Int> {
            $0.yield(1)
            $0.yield(2)
            $0.finish()
        }

        var values: [Int] = []
        for await value in stream {
            values.append(value)
        }

        #expect(values == [1, 2])
    }
}
