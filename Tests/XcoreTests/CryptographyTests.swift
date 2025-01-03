//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct CryptographyTests {
    @Test
    func sha256HashString() {
        let string1 = "Hello World"
        #expect(string1.sha256() == "a591a6d40bf420404a011733cfb7b190d62c65bf0bcda32b57b277d9ad9f146e")

        let string2 = "hello world"
        #expect(string2.sha256() == "b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9")

        #expect(string1.sha256() != string2.sha256())
    }

    @Test
    func sha256HashData() {
        let data1 = Data("Hello World".utf8)
        let bytes1: [UInt8] = [165, 145, 166, 212, 11, 244, 32, 64, 74, 1, 23, 51, 207, 183, 177, 144, 214, 44, 101, 191, 11, 205, 163, 43, 87, 178, 119, 217, 173, 159, 20, 110]

        #expect(data1.sha256().bytes == bytes1)

        let data2 = Data("hello world".utf8)
        let bytes2: [UInt8] = [185, 77, 39, 185, 147, 77, 62, 8, 165, 46, 82, 215, 218, 125, 171, 250, 196, 132, 239, 227, 122, 83, 128, 238, 144, 136, 247, 172, 226, 239, 205, 233]
        #expect(data2.sha256().bytes == bytes2)

        #expect(data1.sha256() != data2.sha256())
    }
}
