//
// CollectionTests.swift
//
// Copyright © 2019 Zeeshan Mian
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

final class CollectionTests: TestCase {
    func testRemovingAll() {
        var numbers = [5, 6, 7, 8, 9, 10, 11]
        let removedNumbers = numbers.removingAll { $0 % 2 == 1 }
        XCTAssertEqual(numbers, [6, 8, 10])
        XCTAssertEqual(removedNumbers, [5, 7, 9, 11])
    }

    func testCount() {
        let cast = ["Vivien", "Marlon", "Kim", "Karl"]
        let shortNamesCount = cast.count { $0.count < 5 }
        XCTAssertEqual(shortNamesCount, 2)
    }
}
