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

    func testStringEnum() throws {
        struct Example: Codable, Equatable {
            enum CodingKeys: CodingKey {
                case value
            }

            enum Style: String, Codable {
                case style1
                case style2
            }

            let value: Style

            init(value: Style) {
                self.value = value
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                value = try container.decode(.value, format: .rawValue(options: .camelcase))
            }
        }

        // Decode
        let data1 = try XCTUnwrap(#"{"value": "STYLE2"}"#.data(using: .utf8))
        let example1 = try JSONDecoder().decode(Example.self, from: data1)
        XCTAssertEqual(example1.value, .style2)

        // Encode
        let data2 = try JSONEncoder().encode(Example(value: .style2))
        let example2 = try JSONDecoder().decode(Example.self, from: data2)
        XCTAssertEqual(example1, example2)
    }

    func testMapStringEnum() throws {
        struct Example: Codable, Equatable {
            enum CodingKeys: String, CodingKey {
                case value = "isPending"
            }

            enum Status: String, Codable {
                case pending
                case scheduled
            }

            let value: Status

            init(value: Status) {
                self.value = value
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                value = try container.decode(.value, format: .map { value in
                    if let status = value as? String {
                        return Status(rawValue: status)
                    }

                    guard let isPending = value as? Bool else {
                        return nil
                    }

                    return isPending ? .pending : .scheduled
                })
            }
        }

        // Decode
        let data1 = try XCTUnwrap(#"{"isPending": false}"#.data(using: .utf8))
        let example1 = try JSONDecoder().decode(Example.self, from: data1)
        XCTAssertEqual(example1.value, .scheduled)

        // Encode
        let data2 = try JSONEncoder().encode(Example(value: .scheduled))
        let example2 = try JSONDecoder().decode(Example.self, from: data2)
        XCTAssertEqual(example1, example2)
    }

    func testMap() throws {
        struct Example: Decodable, Equatable {
            enum CodingKeys: CodingKey {
                case value
            }

            enum Style {
                case style1
                case style2
            }

            let value: Style

            init(value: Style) {
                self.value = value
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                value = try container.decode(.value, format: .map { input in
                    switch input as? String {
                        case "first":
                            return .style1
                        case "second":
                            return .style2
                        default:
                            struct InvalidValue: Error {}
                            throw InvalidValue()
                    }
                })
            }
        }

        // Valid
        let data1 = try XCTUnwrap(#"{"value": "first"}"#.data(using: .utf8))
        let example1 = try JSONDecoder().decode(Example.self, from: data1)
        XCTAssertEqual(example1.value, .style1)

        // Invalid
        let data2 = try XCTUnwrap(#"{"value": "foobaz"}"#.data(using: .utf8))
        XCTAssertThrowsError(try JSONDecoder().decode(Example.self, from: data2))
    }

    func testStringMap() throws {
        struct Example: Codable, Equatable {
            enum CodingKeys: CodingKey {
                case value
            }

            let value: UIColor
            let isBlueColor: Bool

            init(value: UIColor, isBlueColor: Bool) {
                self.value = value
                self.isBlueColor = isBlueColor
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                value = try container.decode(.value, format: .string(UIColor.init(hex:)))
                isBlueColor = try container.decode(.value, format: .string { hex in
                    hex == "0000FF" || hex == "#0000FF"
                })
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(value, forKey: .value, format: .string { color in
                    color.hex
                })
            }
        }

        // Valid
        let data1 = try XCTUnwrap(#"{"value": "0000FF"}"#.data(using: .utf8))
        let example1 = try JSONDecoder().decode(Example.self, from: data1)
        XCTAssertEqual(example1.value, UIColor(hex: "0000FF"))
        XCTAssertEqual(example1.isBlueColor, true)

        // Invalid
        let data2 = try XCTUnwrap(#"{"value": "foobaz"}"#.data(using: .utf8))
        let example2 = try JSONDecoder().decode(Example.self, from: data2)
        XCTAssertEqual(example2.value, UIColor(hex: "000000"))
        XCTAssertEqual(example2.isBlueColor, false)

        // Encode
        let data3 = try JSONEncoder().encode(Example(value: UIColor(hex: "0000FF"), isBlueColor: true))
        let example3 = try JSONDecoder().decode(Example.self, from: data3)
        XCTAssertEqual(example1, example3)
    }

    func testFormatter() throws {
        struct Example: Codable, Equatable {
            static let dateFormatter = DateFormatter().apply {
                $0.dateFormat = "dd-MM-yyyy"
                $0.timeZone = Calendar.default.timeZone
            }

            enum CodingKeys: CodingKey {
                case value
            }

            let value: Date

            init(value: Date) {
                self.value = value
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                value = try container.decode(.value, format: .formatter(Self.dateFormatter))
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(value, forKey: .value, format: .formatter(Self.dateFormatter))
            }
        }

        // Decode
        let data1 = try XCTUnwrap(#"{"value": "11-06-2014"}"#.data(using: .utf8))
        let example1 = try JSONDecoder().decode(Example.self, from: data1)
        XCTAssertEqual(example1.value, Date(year: 2014, month: 6, day: 11))

        // Encode
        let data2 = try JSONEncoder().encode(Example(value: Date(year: 2014, month: 6, day: 11)))
        let example2 = try JSONDecoder().decode(Example.self, from: data2)
        XCTAssertEqual(example1, example2)
    }

    func testDate() throws {
        struct Example: Codable, Equatable {
            enum CodingKeys: CodingKey {
                case value
            }

            let value: Date

            init(value: Date) {
                self.value = value
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                if let format = decoder.userInfo[.dateFormat] as? Date.Format.Custom {
                    value = try container.decode(.value, format: .date(formats: format))
                } else {
                    value = try container.decode(.value, format: .date())
                }
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(value, forKey: .value, format: .date())
            }
        }

        // Decode
        let data1 = try XCTUnwrap(#"{"value": "2014-06-11"}"#.data(using: .utf8))
        let example1 = try JSONDecoder().decode(Example.self, from: data1)
        XCTAssertEqual(example1.value, Date(year: 2014, month: 6, day: 11, calendar: .iso))

        // Invalid
        let data2 = try XCTUnwrap(#"{"value": "2014"}"#.data(using: .utf8))
        XCTAssertThrowsError(try JSONDecoder().decode(Example.self, from: data2))

        // Dynamically passing date format via the decoder
        let jsonDecoder = JSONDecoder().apply {
            $0.userInfo[.dateFormat] = Date.Format.Custom.yearMonthDash
        }
        let data3 = try XCTUnwrap(#"{"value": "2014-06"}"#.data(using: .utf8))
        let example3 = try jsonDecoder.decode(Example.self, from: data3)
        XCTAssertEqual(example3.value, Date(year: 2014, month: 6, day: 1, calendar: .iso))

        // Encode
        let data4 = try JSONEncoder().encode(Example(value: Date(year: 2014, month: 06, day: 11, calendar: .iso)))
        let example4 = try JSONDecoder().decode(Example.self, from: data4)
        XCTAssertEqual(example1, example4)
    }
}

// MARK: - Helpers

extension CodingUserInfoKey {
    fileprivate static var dateFormat: Self {
        CodingUserInfoKey(rawValue: #function)!
    }
}
