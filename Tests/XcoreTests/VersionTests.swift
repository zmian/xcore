//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct VersionTests {
    @Test
    func comparisonCases() {
        let osVersion: Version = "12.1.3"

        #expect(osVersion > "12")
        #expect(!(osVersion < "12"))
        #expect(!(osVersion == "12"))
        #expect(osVersion >= "12")
        #expect(!(osVersion <= "12"))

        #expect(osVersion > "11")
        #expect(!(osVersion < "11"))
        #expect(osVersion != "11")
        #expect(osVersion >= "11")
        #expect(!(osVersion <= "11"))

        #expect(!(osVersion > "12.1.3"))
        #expect(!(osVersion < "12.1.3"))
        #expect(osVersion == "12.1.3")
        #expect(osVersion >= "12.1.3")
        #expect(osVersion <= "12.1.3")
    }

    @Test
    func conformance() {
        let v1: Version = "12.1.3"
        let v2 = Version(rawValue: "12.1.3")

        #expect(v1.rawValue == "12.1.3")
        #expect(v1.rawValue == v1.description)
        #expect(v1.rawValue == v1.playgroundDescription as! String)

        #expect(v1 == v2)
        #expect(v1.hashValue == v2.hashValue)
        #expect(v1.description == v2.description)

        var hasher = Hasher()
        v1.hash(into: &hasher)

        #expect(v1.hashValue == v2.hashValue)
    }
}
