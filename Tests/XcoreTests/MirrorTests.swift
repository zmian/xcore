//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct MirrorTests {
    @Test
    func isOptional() {
        struct Value {}
        #expect(!Mirror.isOptional(Value.self))

        let value = Value()
        #expect(!Mirror.isOptional(value))

        let optionalValue: Value? = nil
        #expect(Mirror.isOptional(optionalValue))

        let optionalValueType: Value?.Type? = nil
        #expect(Mirror.isOptional(optionalValueType))
    }

    @Test
    func isCodable() {
        #expect(Mirror.isCodable(Array<String>.self) == true)

        #expect(Mirror.isCodable(Array(["Hello"])) == true)
        #expect(Mirror.isCodable(Set(["Hello"])) == true)
        #expect(Mirror.isCodable(["Hello": "World"]) == true)

        #expect(Mirror.isCodable([]) == false)
        #expect(Mirror.isCodable(Set<Int>()) == true)
        #expect(Mirror.isCodable([:]) == false)

        var optionalArray: [String]?
        #expect(Mirror.isCodable(optionalArray) == true)

        optionalArray = ["Hello"]
        #expect(Mirror.isCodable(optionalArray) == true)

        struct Value {}
        #expect(Mirror.isCodable(Value()) == false)
        #expect(Mirror.isCodable(Value.self) == false)

        struct Custom: Codable {}
        #expect(Mirror.isCodable(Custom()) == true)
        #expect(Mirror.isCodable(Custom.self) == true)
    }

    @Test
    func asCodable() {
        #expect(Mirror.asCodable(Array<String>.self) != nil)
        #expect(Mirror.asCodable(Set<String>.self) != nil)
        #expect(Mirror.asCodable([String: String].self) != nil)

        struct Custom: Codable {}
        #expect(Mirror.asCodable(Custom.self) != nil)
        #expect(Mirror.asCodable([Custom].self) != nil)
        #expect(Mirror.asCodable([Int: Custom].self) != nil)

        struct Value {}
        #expect(Mirror.asCodable(Value.self) == nil)
        #expect(Mirror.asCodable([Value].self) == nil)
        #expect(Mirror.asCodable([Int: Value].self) == nil)
    }

    @Test
    func isCollection() {
        #expect(Mirror.isCollection(Array<String>.self) == true)

        #expect(Mirror.isCollection(Array(["Hello"])) == true)
        #expect(Mirror.isCollection(Set(["Hello"])) == true)
        #expect(Mirror.isCollection(["Hello": "World"]) == true)

        #expect(Mirror.isCollection([]) == true)
        #expect(Mirror.isCollection(Set<Int>()) == true)
        #expect(Mirror.isCollection([:]) == true)

        var optionalArray: [String]?
        #expect(Mirror.isCollection(optionalArray) == false)

        optionalArray = ["Hello"]
        #expect(Mirror.isCollection(optionalArray) == true)

        struct Value {}
        #expect(Mirror.isCollection(Value()) == false)

        #expect(Mirror.isCollection(CollectionOfOne(1)) == true)
    }

    @Test func isEmpty() {
        var anyValue: Any = Array("Hello")
        #expect(Mirror.isEmpty(anyValue) == false)

        anyValue = [String]()
        #expect(Mirror.isEmpty(anyValue) == true)

        anyValue = 2
        #expect(Mirror.isEmpty(anyValue) == nil)

        anyValue = Set(["World"])
        #expect(Mirror.isEmpty(anyValue) == false)

        anyValue = Set<String>()
        #expect(Mirror.isEmpty(anyValue) == true)
    }

    @Test func isEqual() {
        var lhs: Any = Array("Hello")
        var rhs: Any = Array("Hello")

        #expect(Mirror.isEqual(lhs, rhs) == true)

        rhs = Array("World")
        #expect(Mirror.isEqual(lhs, rhs) == false)

        rhs = "Hello"
        #expect(Mirror.isEqual(lhs, rhs) == false)

        lhs = "Hello"
        #expect(Mirror.isEqual(lhs, rhs) == true)
    }
}
