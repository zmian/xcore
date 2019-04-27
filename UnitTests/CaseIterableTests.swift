//
// CaseIterableTests.swift
//
// Copyright © 2018 Zeeshan Mian
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import XCTest
@testable import Xcore

final class CaseIterableTests: TestCase {
    func testAllCases() {
        XCTAssert(SomeClass.Counting.allCases.count == 3)
        XCTAssert(SomeClass.NewCounting.allCases.count == 2)
        XCTAssert(SomeStruct.Counting.allCases.count == 3)
    }

    func testCount() {
        XCTAssertEqual(SomeClass.Counting.count, 3)
        XCTAssertEqual(SomeClass.NewCounting.count, 2)
    }

    func testRawValues() {
        let expectedRawValues1 = [
            "one",
            "two",
            "three"
        ]

        let expectedRawValues2 = [
            "one",
            "two"
        ]

        XCTAssertEqual(SomeClass.Counting.rawValues, expectedRawValues1)
        XCTAssertEqual(SomeClass.NewCounting.rawValues, expectedRawValues2)
    }
}

private final class SomeClass { }

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
            return [.one, .two]
        }
    }
}

private struct SomeStruct {
}

extension SomeStruct {
    fileprivate enum Counting: String, CaseIterable {
        case one
        case two
        case three
    }
}
