//
//  LazyResetTests.swift
//  UnitTests
//
//  Created by Zeeshan Mian on 3/18/20.
//  Copyright © 2020 Xcore. All rights reserved.
//

import XCTest
@testable import Xcore

final class LazyResetTests: TestCase {
    func testAllCases() {
        struct Example {
            @LazyReset
            var x: Int = 7

            mutating func reset() {
                _x.reset()
            }
        }

        var example = Example()

        XCTAssert(example.x == 7)
        example.x = 100
        XCTAssert(example.x == 100)
        example.reset()
        XCTAssert(example.x == 7)
    }
}
