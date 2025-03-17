//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct LargestRemainderRoundingTests {
    @Test
    func roundingToIntegerTotal() {
        let values: [Double] = [4.2857, 2.8571, 2.8571]
        let result = values.roundedUsingLargestRemainder(to: 10)

        #expect(result == [4.0, 3.0, 3.0])
        #expect(result.sum() == 10)
    }

    @Test
    func roundingToPercentageTotal() {
        let values: [Double] = [0.42857, 0.28571, 0.28571]
        let result = values.roundedUsingLargestRemainder(to: 1.0)

        #expect(values.sum() == 0.99999)
        #expect(result.sum() == 1.0)
        #expect(result == [0.43, 0.29, 0.28])
    }

    @Test
    func totalLargerThanSum() {
        let values: [Double] = [1.2, 2.3, 3.4]
        let result = values.roundedUsingLargestRemainder(to: 10)

        #expect(result.sum() == 10)
        #expect(result == [2.0, 3.0, 5.0])
    }

    @Test
    func totalSmallerThanSum() {
        let values: [Double] = [4.8, 3.2, 2.0]
        let result = values.roundedUsingLargestRemainder(to: 9)

        #expect(result.sum() == 9)
        #expect(result == [4.0, 3.0, 2.0])
    }

    @Test
    func equalValues() {
        let values: [Double] = [3.3333, 3.3333, 3.3333]
        let result = values.roundedUsingLargestRemainder(to: 10)

        #expect(result.sum() == 10)
        #expect(result.sorted() == [3, 3, 4])
    }

    @Test
    func emptyArray() {
        let values: [Double] = []
        let result = values.roundedUsingLargestRemainder(to: 10)

        #expect(result.isEmpty)
    }

    @Test
    func alreadySummedCorrectly() {
        let values: [Double] = [5.0, 3.0, 2.0]
        let result = values.roundedUsingLargestRemainder(to: 10)

        #expect(result.sum() == 10)
        #expect(result == [5.0, 3.0, 2.0])
    }

    @Test
    func smallNumbers() {
        let values: [Double] = [0.0004, 0.0003, 0.0003]
        let result = values.roundedUsingLargestRemainder(to: 1.0)

        #expect(result.sum() == 1.0)
        #expect(result == [0.4, 0.3, 0.3])
    }

    @Test
    func negativeNumbers() {
        let values: [Double] = [-1.2, -2.3, -3.4]
        let result = values.roundedUsingLargestRemainder(to: -10)

        #expect(result.sum() == -10)
        #expect(result == [-2.0, -3.0, -5.0])
    }

    @Test
    func inputSumZero() {
        let values: [Double] = [-5, 5, 10, -10]
        let result = values.roundedUsingLargestRemainder(to: 50)

        #expect(values.sum() == 0)
        #expect(result == [0.0, 0.0, 0.0, 0.0])
    }
}
