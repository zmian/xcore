//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class CacheTests: TestCase {
    func testCache() async {
        let cache = Cache<String, Int>()
        await cache.setValue(10, forKey: "hello")
        await cache.setValue(20, forKey: "world")

        let v1 = await cache.value(forKey: "hello")
        let v2 = await cache.value(forKey: "world")

        XCTAssertEqual(v1, 10)
        XCTAssertEqual(v2, 20)

        await cache.remove("world")
        let v3 = await cache.value(forKey: "world")
        XCTAssertNil(v3)

        await cache.removeAll()

        let v4 = await cache.value(forKey: "hello")
        let v5 = await cache.value(forKey: "world")
        XCTAssertNil(v4)
        XCTAssertNil(v5)
    }
}
