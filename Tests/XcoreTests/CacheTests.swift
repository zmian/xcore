//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct CacheTests {
    @Test
    func cache() async {
        let cache = Cache<String, Int>()
        await cache.setValue(10, forKey: "hello")
        await cache.setValue(20, forKey: "world")

        let v1 = await cache.value(forKey: "hello")
        let v2 = await cache.value(forKey: "world")

        #expect(v1 == 10)
        #expect(v2 == 20)

        await cache.remove("world")
        let v3 = await cache.value(forKey: "world")
        #expect(v3 == nil)

        await cache.removeAll()

        let v4 = await cache.value(forKey: "hello")
        let v5 = await cache.value(forKey: "world")
        #expect(v4 == nil)
        #expect(v5 == nil)
    }
}
