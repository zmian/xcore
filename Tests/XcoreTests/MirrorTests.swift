//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class MirrorTests: TestCase {
    func testIsOptional() {
        struct Cat {}
        XCTAssertFalse(Mirror.isOptional(Cat.self))

        let cat = Cat()
        XCTAssertFalse(Mirror.isOptional(cat))

        let optionalCat: Cat? = nil
        XCTAssertTrue(Mirror.isOptional(optionalCat))
    }

    // RawValue: String

    func testEnumRawValueString() {
        enum Color: String, Codable {
            case red
            case green
            case blue
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.string), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color.blue
        let actual2 = Mirror.type(of: color2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.string), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    func testRawRepresentableString() {
        struct Color: RawRepresentable, Codable {
            let rawValue: String?
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.string), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color(rawValue: "blue")
        let actual2 = Mirror.type(of: color2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.string), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // RawValue: Int

    func testEnumRawValueInt() {
        enum Color: Int, Codable {
            case red
            case green
            case blue
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.int)), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color.blue
        let actual2 = Mirror.type(of: color2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.int)), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    func testRawRepresentableInt() {
        struct Color: RawRepresentable, Codable {
            let rawValue: Int?
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.int)), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color(rawValue: 2)
        let actual2 = Mirror.type(of: color2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.int)), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // RawValue: UInt

    func testEnumRawValueUInt() {
        enum Color: UInt, Codable {
            case red
            case green
            case blue
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.uint)), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color.blue
        let actual2 = Mirror.type(of: color2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.uint)), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    func testRawRepresentableUInt() {
        struct Color: RawRepresentable, Codable {
            let rawValue: UInt?
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.uint)), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color(rawValue: 2)
        let actual2 = Mirror.type(of: color2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.uint)), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // RawValue: Float

    func testEnumRawValueFloat() {
        enum Color: Float, Codable {
            case red
            case green
            case blue
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.float)), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color.blue
        let actual2 = Mirror.type(of: color2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.float)), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    func testRawRepresentableFloat() {
        struct Color: RawRepresentable, Codable {
            let rawValue: Float?
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.float)), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color(rawValue: 2)
        let actual2 = Mirror.type(of: color2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.float)), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // RawValue: Double

    func testEnumRawValueDouble() {
        enum Color: Double {
            case red
            case green
            case blue
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: true, isCodable: false)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color.blue
        let actual2 = Mirror.type(of: color2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: false, isCodable: false)
        XCTAssertEqual(actual2, expected2)
    }

    func testRawRepresentableDouble() {
        struct Color: RawRepresentable {
            let rawValue: Double? // Optional
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: true, isCodable: false)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color(rawValue: 2)
        let actual2 = Mirror.type(of: color2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: false, isCodable: false)
        XCTAssertEqual(actual2, expected2)
    }

    func testRawRepresentableDoubleNonOptional() {
        struct Color: RawRepresentable {
            let rawValue: Double // Non-Optional
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: true, isCodable: false)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color(rawValue: 2)
        let actual2 = Mirror.type(of: color2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: false, isCodable: false)
        XCTAssertEqual(actual2, expected2)
    }

    // RawValue: Bool

    func testRawRepresentableBool() {
        struct Color: RawRepresentable {
            let rawValue: Bool?
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.bool), isOptional: true, isCodable: false)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color(rawValue: false)
        let actual2 = Mirror.type(of: color2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.bool), isOptional: false, isCodable: false)
        XCTAssertEqual(actual2, expected2)
    }

    // RawValue: CGFloat

    func testEnumRawValueCGFloat() {
        enum Color: CGFloat, Codable {
            case red
            case green
            case blue
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color.blue
        let actual2 = Mirror.type(of: color2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    func testRawRepresentableCGFloat() {
        struct Color: RawRepresentable {
            let rawValue: CGFloat?
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: true, isCodable: false)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color(rawValue: 2)
        let actual2 = Mirror.type(of: color2)
        let expected2 = Mirror.TypeInfo(kind: .rawRepresentable(.numeric(.double)), isOptional: false, isCodable: false)
        XCTAssertEqual(actual2, expected2)
    }

    // RawValue: Some

    func testRawRepresentableSome() {
        enum Value {
            case this
            case that
        }

        struct Color: RawRepresentable {
            let rawValue: Value
        }

        // Optional
        let color1: Color? = nil
        let actual1 = Mirror.type(of: color1)
        let expected1 = Mirror.TypeInfo(kind: .rawRepresentable(.some), isOptional: true, isCodable: false)
        XCTAssertEqual(actual1, expected1)

        // Non-Optional
        let color2 = Color(rawValue: .this)
        let actual2 = Mirror.type(of: color2)
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

        // Optional
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

        // Optional
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

        // Optional
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

        // Optional
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

        // Optional
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

        // Optional
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

        // Optional
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

        // Optional
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

        // Optional
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

        // Optional
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

        // Optional
        let value2 = Data()
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .data, isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }

    // Unknown

    func testUnknown() {
        struct Color: OtherProtocol, Codable {}

        // Optional
        let value1: Color? = nil
        let actual1 = Mirror.type(of: value1)
        let expected1 = Mirror.TypeInfo(kind: .unknown, isOptional: true, isCodable: true)
        XCTAssertEqual(actual1, expected1)

        // Optional
        let value2 = Color()
        let actual2 = Mirror.type(of: value2)
        let expected2 = Mirror.TypeInfo(kind: .unknown, isOptional: false, isCodable: true)
        XCTAssertEqual(actual2, expected2)
    }
}

// MARK: - Helpers

private protocol OtherProtocol {}
