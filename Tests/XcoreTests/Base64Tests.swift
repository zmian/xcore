//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class Base64Tests: TestCase {
    func testBase64EncodedString() {
        let string1 = "Hello World"
        XCTAssertEqual(string1.base64Encoded(), "SGVsbG8gV29ybGQ=")
        XCTAssertEqual(string1.base64UrlEncoded(), "SGVsbG8gV29ybGQ")

        let string2 = "aGVsbG8gd29ybGQ="
        XCTAssertEqual(string2, "hello world".base64Encoded())
        XCTAssertEqual(string2.base64ToBase64UrlEncoded(), "aGVsbG8gd29ybGQ")

        let string3 = "aGVsbG8gd29ybGQ"
        XCTAssertEqual(string3.base64UrlToBase64Encoded(), "aGVsbG8gd29ybGQ=")
    }

    func testBase64EncodedStringToUInt8Array() {
        let string1 = "aGVsbG8gd29ybGQ="
        let bytes: [UInt8] = [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100]

        XCTAssertEqual(string1, "hello world".base64Encoded())
        XCTAssertEqual(string1.base64UrlToUInt8Array(), bytes)
        XCTAssertEqual(bytes.base64EncodedString(), string1)
        XCTAssertEqual(bytes.base64UrlEncodedString(), string1.base64ToBase64UrlEncoded())
    }
}
