//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct CacheTests {
    @Test
    func basics() {
        let cache = Cache<String, Int>()
        cache["hello"] = 10
        cache["world"] = 20

        let v1 = cache["hello"]
        let v2 = cache["world"]

        #expect(v1 == 10)
        #expect(v2 == 20)

        cache["world"] = nil
        let v3 = cache["world"]
        #expect(v3 == nil)

        cache.removeAll()

        let v4 = cache["hello"]
        let v5 = cache["world"]
        #expect(v4 == nil)
        #expect(v5 == nil)
    }
}
