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

    func testIsCodable() {
        XCTAssertEqual(Mirror.isCodable(Array<String>.self), true)

        XCTAssertEqual(Mirror.isCodable(Array(["Hello"])), true)
        XCTAssertEqual(Mirror.isCodable(Set(["Hello"])), true)
        XCTAssertEqual(Mirror.isCodable(["Hello": "World"]), true)

        XCTAssertEqual(Mirror.isCodable([]), false)
        XCTAssertEqual(Mirror.isCodable(Set<Int>()), true)
        XCTAssertEqual(Mirror.isCodable([:]), false)

        var optionalArray: [String]?
        XCTAssertEqual(Mirror.isCodable(optionalArray), true)

        optionalArray = ["Hello"]
        XCTAssertEqual(Mirror.isCodable(optionalArray), true)

        struct Value {}
        XCTAssertEqual(Mirror.isCodable(Value()), false)
        XCTAssertEqual(Mirror.isCodable(Value.self), false)

        struct Custom: Codable {}
        XCTAssertEqual(Mirror.isCodable(Custom()), true)
        XCTAssertEqual(Mirror.isCodable(Custom.self), true)
    }

    func testAsCodable() {
        XCTAssertNotNil(Mirror.asCodable(Array<String>.self))
        XCTAssertNotNil(Mirror.asCodable(Set<String>.self))
        XCTAssertNotNil(Mirror.asCodable([String: String].self))

        struct Custom: Codable {}
        XCTAssertNotNil(Mirror.asCodable(Custom.self))
        XCTAssertNotNil(Mirror.asCodable([Custom].self))
        XCTAssertNotNil(Mirror.asCodable([Int: Custom].self))

        struct Value {}
        XCTAssertNil(Mirror.asCodable(Value.self))
        XCTAssertNil(Mirror.asCodable([Value].self))
        XCTAssertNil(Mirror.asCodable([Int: Value].self))
    }

    func testIsCollection() {
        XCTAssertEqual(Mirror.isCollection(Array<String>.self), true)

        XCTAssertEqual(Mirror.isCollection(Array(["Hello"])), true)
        XCTAssertEqual(Mirror.isCollection(Set(["Hello"])), true)
        XCTAssertEqual(Mirror.isCollection(["Hello": "World"]), true)

        XCTAssertEqual(Mirror.isCollection([]), true)
        XCTAssertEqual(Mirror.isCollection(Set<Int>()), true)
        XCTAssertEqual(Mirror.isCollection([:]), true)

        var optionalArray: [String]?
        XCTAssertEqual(Mirror.isCollection(optionalArray), false)

        optionalArray = ["Hello"]
        XCTAssertEqual(Mirror.isCollection(optionalArray), true)

        struct Value {}
        XCTAssertEqual(Mirror.isCollection(Value()), false)

        XCTAssertEqual(Mirror.isCollection(CollectionOfOne(1)), true)
    }

    func testIsEmpty() {
        var anyValue: Any = Array("Hello")
        XCTAssertEqual(Mirror.isEmpty(anyValue), false)

        anyValue = [String]()
        XCTAssertEqual(Mirror.isEmpty(anyValue), true)

        anyValue = 2
        XCTAssertEqual(Mirror.isEmpty(anyValue), nil)

        anyValue = Set(["World"])
        XCTAssertEqual(Mirror.isEmpty(anyValue), false)

        anyValue = Set<String>()
        XCTAssertEqual(Mirror.isEmpty(anyValue), true)
    }

    func testIsEqual() {
        var lhs: Any = Array("Hello")
        var rhs: Any = Array("Hello")

        XCTAssertEqual(Mirror.isEqual(lhs, rhs), true)

        rhs = Array("World")
        XCTAssertEqual(Mirror.isEqual(lhs, rhs), false)

        rhs = "Hello"
        XCTAssertEqual(Mirror.isEqual(lhs, rhs), false)

        lhs = "Hello"
        XCTAssertEqual(Mirror.isEqual(lhs, rhs), true)
    }
}
