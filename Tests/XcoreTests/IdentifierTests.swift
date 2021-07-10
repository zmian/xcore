//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class IdentifierTests: TestCase {
    func testCodable() throws {
        typealias ID = Identifier<IdentifierTests>

        let values: [ID] = [
            "1",
            "some_id"
        ]

        let encoder = JSONEncoder()
        let data = try encoder.encode(values)
        let encodedValue = String(data: data, encoding: .utf8)!
        let expectedEncodedValue = "[\"1\",\"some_id\"]"
        XCTAssertEqual(encodedValue, expectedEncodedValue)

        let decoder = JSONDecoder()
        let decodedValues = try decoder.decode([ID].self, from: data)
        for (index, value) in values.enumerated() {
            XCTAssertEqual(value, decodedValues[index])
        }
    }
}
