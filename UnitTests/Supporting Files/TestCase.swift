//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

class TestCase: XCTestCase {
}

func expect<T>(_ input: T, _ comparator: (T, T) -> Bool, _ output: T) {
    XCTAssert(comparator(input, output), "Expected \(output), found \(input).")
}
