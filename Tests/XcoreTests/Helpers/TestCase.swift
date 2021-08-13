//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

class TestCase: XCTestCase {
    public override func setUp() {
        super.setUp()
        DependencyValues.resetAll()
    }
}

// MARK: - Helpers

func assert<T>(
    _ input: T,
    _ comparator: (T, T) -> Bool,
    _ output: T,
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssert(
        comparator(input, output),
        "Expected \(output), found \(input).",
        file: file,
        line: line
    )
}

func assertEqual<T1, T2>(
    _ input: (T1, T2),
    _ output: (T1, T2),
    file: StaticString = #file,
    line: UInt = #line
) where T1: Equatable, T2: Equatable {
    XCTAssertTrue(
        input == output,
        "Expected \(output), found \(input).",
        file: file,
        line: line
    )
}
