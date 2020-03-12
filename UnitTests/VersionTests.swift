//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class VersionTests: TestCase {
    func testComparisonCases() {
        let osVersion: Version = "12.1.3"

        XCTAssertTrue(osVersion > "12")
        XCTAssertFalse(osVersion < "12")
        XCTAssertFalse(osVersion == "12")
        XCTAssertTrue(osVersion >= "12")
        XCTAssertFalse(osVersion <= "12")

        XCTAssertTrue(osVersion > "11")
        XCTAssertFalse(osVersion < "11")
        XCTAssertFalse(osVersion == "11")
        XCTAssertTrue(osVersion >= "11")
        XCTAssertFalse(osVersion <= "11")

        XCTAssertFalse(osVersion > "12.1.3")
        XCTAssertFalse(osVersion < "12.1.3")
        XCTAssertTrue(osVersion == "12.1.3")
        XCTAssertTrue(osVersion >= "12.1.3")
        XCTAssertTrue(osVersion <= "12.1.3")
    }

    func testConformance() {
        let v1: Version = "12.1.3"
        let v2 = Version(rawValue: "12.1.3")

        XCTAssertTrue(v1.rawValue == "12.1.3")
        XCTAssertTrue(v1.rawValue == v1.description)
        XCTAssertTrue(v1.rawValue == v1.playgroundDescription as! String)

        XCTAssertTrue(v1 == v2)
        XCTAssertTrue(v1.hashValue == v2.hashValue)
        XCTAssertTrue(v1.description == v2.description)

        var hasher = Hasher()
        v1.hash(into: &hasher)

        XCTAssertTrue(v1.hashValue == v2.hashValue)
    }
}
