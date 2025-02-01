//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct CollectionTests {
    @Test
    func removingAll() {
        var numbers = [5, 6, 7, 8, 9, 10, 11]
        let removedNumbers = numbers.removingAll { $0 % 2 == 1 }
        #expect(numbers == [6, 8, 10])
        #expect(removedNumbers == [5, 7, 9, 11])
    }

    @Test
    func count() {
        let cast = ["Vivien", "Marlon", "Kim", "Karl"]
        let shortNamesCount = cast.count { $0.count < 5 }
        #expect(shortNamesCount == 2)
    }

    @Test
    func unique() {
        let numbers = [1, 2, 3, 4, 2]
        #expect(numbers.uniqued() == [1, 2, 3, 4])
    }
}
