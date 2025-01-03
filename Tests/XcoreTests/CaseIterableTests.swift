//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct CaseIterableTests {
    @Test
    func allCases() {
        #expect(SomeClass.Counting.allCases.count == 3)
        #expect(SomeClass.NewCounting.allCases.count == 2)
        #expect(SomeStruct.Counting.allCases.count == 3)
    }

    @Test
    func count() {
        #expect(SomeClass.Counting.count == 3)
        #expect(SomeClass.NewCounting.count == 2)
    }

    @Test
    func rawValues() {
        let expectedRawValues1 = [
            "one",
            "two",
            "three"
        ]

        let expectedRawValues2 = [
            "one",
            "two"
        ]

        #expect(SomeClass.Counting.rawValues == expectedRawValues1)
        #expect(SomeClass.NewCounting.rawValues == expectedRawValues2)
    }
}

private final class SomeClass {}

extension SomeClass {
    fileprivate enum Counting: String, CaseIterable {
        case one
        case two
        case three
    }

    fileprivate enum NewCounting: String, CaseIterable {
        case one
        case two
        case three

        static var allCases: [NewCounting] {
            [.one, .two]
        }
    }
}

private struct SomeStruct {}

extension SomeStruct {
    fileprivate enum Counting: String, CaseIterable {
        case one
        case two
        case three
    }
}
