//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct Base64Tests {
    @Test
    func base64EncodedString() {
        let string1 = "Hello World"
        #expect(string1.base64Encoded() == "SGVsbG8gV29ybGQ=")
        #expect(string1.base64UrlEncoded() == "SGVsbG8gV29ybGQ")

        let string2 = "aGVsbG8gd29ybGQ="
        #expect(string2 == "hello world".base64Encoded())
        #expect(string2.base64ToBase64UrlEncoded() == "aGVsbG8gd29ybGQ")

        let string3 = "aGVsbG8gd29ybGQ"
        #expect(string3.base64UrlToBase64Encoded() == "aGVsbG8gd29ybGQ=")
    }

    @Test
    func base64EncodedStringToUInt8Array() {
        let string1 = "aGVsbG8gd29ybGQ="
        let bytes: [UInt8] = [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100]

        #expect(string1 == "hello world".base64Encoded())
        #expect(string1.base64UrlToUInt8Array() == bytes)
        #expect(bytes.base64EncodedString() == string1)
        #expect(bytes.base64UrlEncodedString() == string1.base64ToBase64UrlEncoded())
    }
}
