//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class MirrorTests: TestCase {
    func testIsOptional() {
        struct Value {}
        XCTAssertFalse(Mirror.isOptional(Value.self))

        let value = Value()
        XCTAssertFalse(Mirror.isOptional(value))

        let optionalValue: Value? = nil
        XCTAssertTrue(Mirror.isOptional(optionalValue))

        let optionalValueType: Value?.Type? = nil
        XCTAssertTrue(Mirror.isOptional(optionalValueType))
    }

    // RawValue: String

    func testEnumRawValueString() {
        enum Value: String, Codable {
            case one
            case two
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.string), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value.two
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.string), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    func testRawRepresentableString() {
        struct Value: RawRepresentable, Codable {
            let rawValue: String?
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.string), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value(rawValue: "blue")
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.string), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // RawValue: Int

    func testEnumRawValueInt() {
        enum Value: Int, Codable {
            case one
            case two
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.int)), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value.two
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.int)), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    func testRawRepresentableInt() {
        struct Value: RawRepresentable, Codable {
            let rawValue: Int?
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.int)), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value(rawValue: 2)
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.int)), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // RawValue: UInt

    func testEnumRawValueUInt() {
        enum Value: UInt, Codable {
            case one
            case two
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.uint)), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value.two
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.uint)), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    func testRawRepresentableUInt() {
        struct Value: RawRepresentable, Codable {
            let rawValue: UInt?
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.uint)), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value(rawValue: 2)
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.uint)), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // RawValue: Float

    func testEnumRawValueFloat() {
        enum Value: Float, Codable {
            case one
            case two
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.float)), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value.two
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.float)), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    func testRawRepresentableFloat() {
        struct Value: RawRepresentable, Codable {
            let rawValue: Float?
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.float)), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value(rawValue: 2)
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.float)), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // RawValue: Double

    func testEnumRawValueDouble() {
        enum Value: Double {
            case one
            case two
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: true, isCodable: false)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value.two
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: false, isCodable: false)
        XCTAssertEqual(actual2, expected2)
    }

    func testRawRepresentableDouble() {
        struct Value: RawRepresentable {
            let rawValue: Double? // Optional
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: true, isCodable: false)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value(rawValue: 2)
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: false, isCodable: false)
        XCTAssertEqual(actual2, expected2)
    }

    func testRawRepresentableDoubleNonOptional() {
        struct Value: RawRepresentable {
            let rawValue: Double // Non-Optional
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: true, isCodable: false)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value(rawValue: 2)
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: false, isCodable: false)
        XCTAssertEqual(actual2, expected2)
    }

    // RawValue: Bool

    func testRawRepresentableBool() {
        struct Value: RawRepresentable {
            let rawValue: Bool?
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.bool), isOptional: true, isCodable: false)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value(rawValue: false)
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.bool), isOptional: false, isCodable: false)
        XCTAssertEqual(actual2, expected2)
    }

    // RawValue: CGFloat

    func testEnumRawValueCGFloat() {
        enum Value: CGFloat, Codable {
            case one
            case two
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value.two
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    func testRawRepresentableCGFloat() {
        struct Value: RawRepresentable {
            let rawValue: CGFloat?
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: true, isCodable: false)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value(rawValue: 2)
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: false, isCodable: false)
        XCTAssertEqual(actual2, expected2)
    }

    // RawValue: Some

    func testRawRepresentableSome() {
        enum Raw {
            case this
            case that
        }

        struct Value: RawRepresentable {
            let rawValue: Raw
        }

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.some), isOptional: true, isCodable: false)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value(rawValue: .this)
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.some), isOptional: false, isCodable: false)
        XCTAssertEqual(actual2, expected2)
    }

    // Void

    func testVoid() {
        // Optional
        let value1: Void? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .void, isOptional: true, isCodable: false)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2: Void = ()
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .void, isOptional: false, isCodable: false)
        XCTAssertEqual(actual2, expected2)
    }

    // Bool

    func testBool() {
        // Optional
        let value1: Bool? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .bool, isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2: Bool = false
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .bool, isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // String

    func testString() {
        // Optional
        let value1: String? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .string, isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2: String = "hello"
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .string, isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // Float

    func testFloat() {
        // Optional
        let value1: Float? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .numeric(.float), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2: Float = 2
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .numeric(.float), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // Double

    func testDouble() {
        // Optional
        let value1: Double? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .numeric(.double), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2: Double = 2
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .numeric(.double), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // Double

    func testCGFloat() {
        // Optional
        let value1: CGFloat? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .numeric(.double), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2: CGFloat = 2
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .numeric(.double), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // Int

    func testInt() {
        // Optional
        let value1: Int? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .numeric(.int), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2: Int = 2
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .numeric(.int), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // UInt

    func testUInt() {
        // Optional
        let value1: UInt? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .numeric(.uint), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2: UInt = 2
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .numeric(.uint), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // URL

    func testURL() {
        // Optional
        let value1: URL? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .url, isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = URL(string: "https://example.com")!
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .url, isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // Date

    func testDate() {
        // Optional
        let value1: Date? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .date, isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Date(year: 2014, month: 6, day: 11)
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .date, isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // Data

    func testData() {
        // Optional
        let value1: Data? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .data, isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Data()
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .data, isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // Unknown

    func testUnknown() {
        struct Value: SomeProtocol, Codable {}

        // Optional
        let value1: Value? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .unknown, isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let value2 = Value()
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .unknown, isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    func testWithMirror() throws {
        // Non-RawRepresentable
        enum Style1: Equatable, Codable {
            case one
            case two
        }

        // RawRepresentable<String>
        enum Style2: String, Codable {
            case one
            case two
        }

        // RawRepresentable<Empty>
        struct Style3: RawRepresentable, Equatable, Codable {
            let rawValue: String
        }

        struct Value: Equatable, Codable {
            var id: String = ""
            var name: String?
            var age: Float?
            var style1: Style1 = .two
            var style2: Style2?
            var style3: Style3?
        }

        let mirror = Mirror(reflecting: Value())

        for (label, value) in mirror.children {
            let label = try XCTUnwrap(label)

            let type = Mirror.type(of: value)

            switch label {
                case "id":
                    let expected = Mirror.TypeInfo(kind: .string, isOptional: false, isCodable: true)
                    XCTAssertEqual(type, expected)
                case "name":
                    let expected = Mirror.TypeInfo(kind: .string, isOptional: true, isCodable: true)
                    XCTAssertEqual(type, expected)
                case "age":
                    let expected = Mirror.TypeInfo(kind: .numeric(.float), isOptional: true, isCodable: true)
                    XCTAssertEqual(type, expected)
                case "style1":
                    let expected = Mirror.TypeInfo(kind: .unknown, isOptional: false, isCodable: true)
                    XCTAssertEqual(type, expected)
                case "style2":
                    let expected = Mirror.TypeInfo(kind: .rawRepresentable(.string), isOptional: true, isCodable: true)
                    XCTAssertEqual(type.isCodable, expected.isCodable)
                    XCTAssertEqual(type.isOptional, expected.isOptional)
                    XCTExpectFailure("RawRepresentable types are not resolved when using Mirror(reflecting:)")
                    XCTAssertEqual(type.kind, expected.kind)
                case "style3":
                    let expected = Mirror.TypeInfo(kind: .rawRepresentable(.some), isOptional: true, isCodable: true)
                    XCTAssertEqual(type.isCodable, expected.isCodable)
                    XCTAssertEqual(type.isOptional, expected.isOptional)
                    XCTExpectFailure("RawRepresentable types are not resolved when using Mirror(reflecting:)")
                    XCTAssertEqual(type.kind, expected.kind)
                default:
                    XCTFail("Unhandled label: \(label)")
            }
        }
    }
}

// MARK: - Helpers

private protocol SomeProtocol {}
