//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class CacheTests: TestCase {
    func testCache() {
        let cache = Cache<String, Int>()
        cache.setValue(10, forKey: "hello")
        cache.setValue(20, forKey: "world")
        XCTAssertEqual(cache.value(forKey: "hello"), 10)
        XCTAssertEqual(cache.value(forKey: "world"), 20)

        cache.remove("world")
        XCTAssertNil(cache.value(forKey: "world"))

        cache.removeAll()
        XCTAssertNil(cache.value(forKey: "hello"))
        XCTAssertNil(cache.value(forKey: "world"))
    }
}
