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
            @LazyReset(7)
            var x: Int

            mutating func reset() {
                _x.reset()
            }
        }

        var example = Example()

        XCTAssertEqual(example.x, 7)
        example.x = 100
        XCTAssertEqual(example.x, 100)
        example.reset()
        XCTAssertEqual(example.x, 7)
    }
}
