//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class CodingFormatStyleTests: TestCase {
    func testBool() throws {
        struct Example: Codable, Equatable {
            enum CodingKeys: CodingKey {
                case value
            }

            let value: Bool

            init(value: Bool) {
                self.value = value
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                value = try container.decode(.value, format: .bool)
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(value, forKey: .value, format: .bool)
            }
        }

        // Decode from Bool
        let data1 = try XCTUnwrap(#"{"value": true}"#.data(using: .utf8))
        let example1 = try JSONDecoder().decode(Example.self, from: data1)
        XCTAssertEqual(example1.value, true)

        // Decode from String
        let data2 = try XCTUnwrap(#"{"value": "true"}"#.data(using: .utf8))
        let example2 = try JSONDecoder().decode(Example.self, from: data2)
        XCTAssertEqual(example2.value, true)

        // Encode
        let data3 = try JSONEncoder().encode(Example(value: true))
        let example3 = try JSONDecoder().decode(Example.self, from: data3)
        XCTAssertEqual(example1, example3)
    }

    func testInt() throws {
        struct Example: Codable, Equatable {
            enum CodingKeys: CodingKey {
                case value
            }

            let value: Int

            init(value: Int) {
                self.value = value
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                value = try container.decode(.value, format: .int)
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(value, forKey: .value, format: .int)
            }
        }

        // Decode from Int
        let data1 = try XCTUnwrap(#"{"value": 123}"#.data(using: .utf8))
        let example1 = try JSONDecoder().decode(Example.self, from: data1)
        XCTAssertEqual(example1.value, 123)

        // Decode from String
        let data2 = try XCTUnwrap(#"{"value": "123"}"#.data(using: .utf8))
        let example2 = try JSONDecoder().decode(Example.self, from: data2)
        XCTAssertEqual(example2.value, 123)

        // Encode
        let data3 = try JSONEncoder().encode(Example(value: 123))
        let example3 = try JSONDecoder().decode(Example.self, from: data3)
        XCTAssertEqual(example1, example3)
    }

    func testDouble() throws {
        struct Example: Codable, Equatable {
            enum CodingKeys: CodingKey {
                case value
            }

            let value: Double

            init(value: Double) {
                self.value = value
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                value = try container.decode(.value, format: .double)
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(value, forKey: .value, format: .double)
            }
        }

        // Decode from Double
        let data1 = try XCTUnwrap(#"{"value": 123.45}"#.data(using: .utf8))
        let example1 = try JSONDecoder().decode(Example.self, from: data1)
        XCTAssertEqual(example1.value, 123.45)

        // Decode from String
        let data2 = try XCTUnwrap(#"{"value": "123.45"}"#.data(using: .utf8))
        let example2 = try JSONDecoder().decode(Example.self, from: data2)
        XCTAssertEqual(example2.value, 123.45)

        // Encode
        let data3 = try JSONEncoder().encode(Example(value: 123.45))
        let example3 = try JSONDecoder().decode(Example.self, from: data3)
        XCTAssertEqual(example1, example3)

        // Decode from Int
        let data4 = try XCTUnwrap(#"{"value": 123}"#.data(using: .utf8))
        let example4 = try JSONDecoder().decode(Example.self, from: data4)
        XCTAssertEqual(example4.value, 123.0)
    }

    func testAbsoluteValue() throws {
        struct Example: Codable, Equatable {
            enum CodingKeys: CodingKey {
                case value
            }

            let value: Double

            init(value: Double) {
                self.value = value
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                value = try container.decode(.value, format: .absolute)
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(value, forKey: .value, format: .absolute)
            }
        }

        // Decode from Double
        let data1 = try XCTUnwrap(#"{"value": -123.45}"#.data(using: .utf8))
        let example1 = try JSONDecoder().decode(Example.self, from: data1)
        XCTAssertEqual(example1.value, 123.45)

        // Encode
        let data2 = try JSONEncoder().encode(Example(value: 123.45))
        let example2 = try JSONDecoder().decode(Example.self, from: data2)
        XCTAssertEqual(example1, example2)

        // Decode from Int
        let data3 = try XCTUnwrap(#"{"value": -123}"#.data(using: .utf8))
        let example3 = try JSONDecoder().decode(Example.self, from: data3)
        XCTAssertEqual(example3.value, 123.0)
    }

    func testUrl() throws {
        struct Example: Codable, Equatable {
            enum CodingKeys: CodingKey {
                case value
            }

            let value: URL

            init(value: URL) {
                self.value = value
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                value = try container.decode(.value, format: .url)
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(value, forKey: .value, format: .url)
            }
        }

        // Decode valid url
        let data1 = try XCTUnwrap(#"{"value": "https://example.com"}"#.data(using: .utf8))
        let example1 = try JSONDecoder().decode(Example.self, from: data1)
        XCTAssertEqual(example1.value, URL(string: "https://example.com")!)

        // Encode
        let data2 = try JSONEncoder().encode(Example(value: URL(string: "https://example.com")!))
        let example2 = try JSONDecoder().decode(Example.self, from: data2)
        XCTAssertEqual(example1, example2)

        // Escaped url
        let data3 = try XCTUnwrap(#"{"value": "https://example.com/_hello.html?DAT=A.B.cd&app=XC≻=ABC456&id=F5"}"#.data(using: .utf8))
        let example3 = try JSONDecoder().decode(Example.self, from: data3)
        let urlString = "https://example.com/_hello.html?DAT=A.B.cd&app=XC≻=ABC456&id=F5"
        XCTAssertNil(URL(string: urlString)) // this should be nil as the above string should be encoded properly.
        let validUrlString = try XCTUnwrap(urlString.urlEscaped())
        let validUrl = try XCTUnwrap(URL(string: validUrlString))
        XCTAssertEqual(example3.value, validUrl)
    }

    func testString() throws {
        struct Example: Codable, Equatable {
            enum CodingKeys: CodingKey {
                case value
            }

            let value: String

            init(value: String) {
                self.value = value
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                value = try container.decode(.value, format: .string(options: [.lowercase]))
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(value, forKey: .value, format: .string(options: [.lowercase]))
            }
        }

        // Decode
        let data1 = try XCTUnwrap(#"{"value": "HELLO"}"#.data(using: .utf8))
        let example1 = try JSONDecoder().decode(Example.self, from: data1)
        XCTAssertEqual(example1.value, "hello")

        // Decode
        let data2 = try XCTUnwrap(#"{"value": "HeLlO"}"#.data(using: .utf8))
        let example2 = try JSONDecoder().decode(Example.self, from: data2)
        XCTAssertEqual(example2.value, "hello")

        // Encode
        let data3 = try JSONEncoder().encode(Example(value: "HELLO"))
        let example3 = try JSONDecoder().decode(Example.self, from: data3)
        XCTAssertEqual(example1, example3)
    }
}
