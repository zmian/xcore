//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class DataStatusTests: TestCase {
    func testIsFailureOrEmpty() {
        var data = DataStatus<[String]>.idle
        XCTAssertEqual(data.isFailureOrEmpty, false)

        data = .loading
        XCTAssertEqual(data.isFailureOrEmpty, false)

        // True, collection is empty
        data = .failure(.general)
        XCTAssertEqual(data.isFailureOrEmpty, true)

        // False, collection is empty
        data = .success(["Hello"])
        XCTAssertEqual(data.isFailureOrEmpty, false)

        // True, collection is empty
        data = .success([])
        XCTAssertEqual(data.isFailureOrEmpty, true)
    }

    func testIsFailureOrEmpty_ReloadableDataStatus() {
        var data = ReloadableDataStatus<[String]>.idle
        XCTAssertEqual(data.isFailureOrEmpty, false)

        data = .loading
        XCTAssertEqual(data.isFailureOrEmpty, false)

        // True, collection is empty
        data = .failure(.general)
        XCTAssertEqual(data.isFailureOrEmpty, true)

        // False, collection is empty
        data = .success(["Hello"])
        XCTAssertEqual(data.isFailureOrEmpty, false)

        // True, collection is empty
        data = .success([])
        XCTAssertEqual(data.isFailureOrEmpty, true)

        // True, collection is empty
        data = .reloading([])
        XCTAssertEqual(data.isFailureOrEmpty, true)

        // False, collection is empty
        data = .reloading(["Hello"])
        XCTAssertEqual(data.isFailureOrEmpty, false)
    }
}
