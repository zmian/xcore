//
// Xcore
// Copyright © 2026 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct JSONValueTests {
    @Test
    func decodesJSONPrimitives() throws {
        let json = Data(
            """
            {
                "null": null,
                "bool": true,
                "int": 42,
                "double": 3.14,
                "string": "hello",
                "array": [1, "two", false],
                "object": { "a": 1 }
            }
            """.utf8
        )

        struct Payload: Decodable {
            let null: JSONValue
            let bool: JSONValue
            let int: JSONValue
            let double: JSONValue
            let string: JSONValue
            let array: JSONValue
            let object: JSONValue
        }

        let payload = try JSONDecoder().decode(Payload.self, from: json)

        #expect(payload.null == JSONValue.null)
        #expect(payload.bool == JSONValue.bool(true))
        #expect(payload.int == JSONValue.int(42))
        #expect(payload.double == JSONValue.double(3.14))
        #expect(payload.string == JSONValue.string("hello"))
        #expect(payload.array == JSONValue.array([JSONValue.int(1), JSONValue.string("two"), JSONValue.bool(false)]))
        #expect(payload.object == JSONValue.object(["a": JSONValue.int(1)]))
    }

    @Test
    func encodesJSONPrimitives() throws {
        let value: [String: JSONValue] = [
            "null": JSONValue.null,
            "bool": JSONValue.bool(false),
            "int": JSONValue.int(7),
            "double": JSONValue.double(1.5),
            "string": JSONValue.string("world"),
            "array": JSONValue.array([JSONValue.string("a")]),
            "object": JSONValue.object(["key": JSONValue.bool(true)])
        ]

        let decoded = try JSONDecoder().decode([String: JSONValue].self, from: try JSONEncoder().encode(value))

        #expect(decoded == value)
    }

    @Test
    func fromSendableValues() {
        #expect(JSONValue.from(true) == JSONValue.bool(true))
        #expect(JSONValue.from(123) == JSONValue.int(123))
        #expect(JSONValue.from(1.25) == JSONValue.double(1.25))
        #expect(JSONValue.from("text") == JSONValue.string("text"))
    }

    @Test
    func fromDecimalValue() throws {
        let decimal = try #require(Decimal(string: "9.99", locale: .us))
        let decoded = try DecimalCodingFormatStyle().decode(JSONValue.from(decimal))

        #expect(decoded == decimal)
    }

    @Test
    func anyValueMatchesJSONTypes() {
        #expect(JSONValue.null.anyValue is NSNull)
        #expect(JSONValue.bool(true).anyValue as? Bool == true)
        #expect(JSONValue.int(10).anyValue as? Int == 10)
        #expect(JSONValue.string("x").anyValue as? String == "x")
    }

    @Test
    func decodeOrderMatchesStringBeforeNumber() throws {
        let stringValue = try JSONDecoder().decode(JSONValue.self, from: Data(#""123""#.utf8))
        let intValue = try JSONDecoder().decode(JSONValue.self, from: Data("123".utf8))

        #expect(stringValue == JSONValue.string("123"))
        #expect(intValue == JSONValue.int(123))
    }

    @Test
    func roundTripThroughFormatStyleContainer() throws {
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

        let fromNumber = try JSONDecoder().decode(Example.self, from: Data(#"{"value": 5}"#.utf8))
        let fromString = try JSONDecoder().decode(Example.self, from: Data(#"{"value": "5"}"#.utf8))
        let encoded = try JSONEncoder().encode(Example(value: 5))
        let roundTrip = try JSONDecoder().decode(Example.self, from: encoded)

        #expect(fromNumber.value == 5)
        #expect(fromString.value == 5)
        #expect(roundTrip.value == 5)
    }
}
