//
//  LazyResetTests.swift
//  UnitTests
//
//  Created by Zeeshan Mian on 3/18/20.
//  Copyright © 2020 Xcore. All rights reserved.
//

import Testing
@testable import Xcore

struct LazyResetTests {
    @Test
    func allCases() {
        struct Example {
            @LazyReset(7)
            var x: Int

            mutating func reset() {
                _x.reset()
            }
        }

        var example = Example()

        #expect(example.x == 7)
        example.x = 100
        #expect(example.x == 100)
        example.reset()
        #expect(example.x == 7)
    }
}
