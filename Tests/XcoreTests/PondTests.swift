//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
import KeychainAccess
@testable import Xcore

final class PondTests: TestCase {
    func testPond_Basic_Stub() throws {
        try assertBasicCases(with: .inMemory)
    }

    func testPond_Basic_UserDefaults() throws {
        let suite = try XCTUnwrap(UserDefaults(suiteName: "pond_test"))
        try assertBasicCases(with: .userDefaults(suite))
    }

    func testPond_Basic_Composit() throws {
        let suite = try XCTUnwrap(UserDefaults(suiteName: "pond_test"))
        let stub = InMemoryPond()
        let userDefaults = UserDefaultsPond(suite)

        try assertBasicCases(with: .composite(id: "test") { method, key in
            if key == .testValue2 {
                return stub
            }

            return userDefaults
        })
    }

    func testEmptyPond() throws {
        let model = ViewModel()

        DependencyValues.pond(.empty)

        // Set value
        try model.pond.set(.testValue, value: "Hello")
        XCTAssertFalse(model.pond.contains(.testValue))
        model.pond.remove(.testValue)
        XCTAssertFalse(model.pond.contains(.testValue))

        // Set/Get value
        try model.pond.set(.testValue, value: 123)
        XCTAssertNil(try model.pond.get(.testValue))
    }

    private func assertCases<T>(for value: T, pond: @autoclosure () -> Pond) throws where T: Equatable {
        let model = ViewModel()

        DependencyValues.pond(pond())

        // Set value
        try model.pond.set(.testValue, value: value)
        XCTAssertTrue(model.pond.contains(.testValue))
        model.pond.remove(.testValue)
        XCTAssertFalse(model.pond.contains(.testValue))

        // Set/Get value
        try model.pond.set(.testValue2, value: value)
        XCTAssertEqual(try model.pond.get(.testValue2), value)
    }
}

// MARK: - Test Cases

extension PondTests {
    private func assertBasicCases(with pond: @autoclosure () -> Pond) throws {
        try assertCases(for: "Hello", pond: pond())
        try assertCases(for: ["Hello", "World"], pond: pond())
        try assertCases(for: ["Hello": "World"], pond: pond())
        try assertCases(for: ["Number": 315.36], pond: pond())
        try assertCases(for: [123, 315.36], pond: pond())
        try assertCases(for: 123, pond: pond())
        try assertCases(for: 315.36, pond: pond())
        try assertCases(for: Float(315.36), pond: pond())
        try assertCases(for: false, pond: pond())
        try assertCases(for: true, pond: pond())

        try assertCases(for: NSNumber(315.36), pond: pond())

        try assertCases(for: Date().timeIntervalSinceNow, pond: pond())
        try assertCases(for: Date(), pond: pond())
        try assertCases(for: Date().adjusting(.day, by: 10), pond: pond())

        try assertCases(for: URL(string: "http://example.com"), pond: pond())
        try assertCases(for: NSURL(string: "http://example.com")! as URL, pond: pond())
        try assertCases(for: NSURL(string: "http://example.com"), pond: pond())

        // Test Data
        try assertCases(for: Crypt.generateSecureRandom(), pond: pond())
        try assertCases(for: Data("Hello World".utf8), pond: pond())

        try assertGetDefaultValue(with: pond())

        // Codable
        try assertGetCodable(with: pond())
        try assertGetCodable2(with: pond())
        try assertGetCodableArray(with: pond())
        try assertGetCodableDictionary(with: pond())
    }

    private func assertGetDefaultValue(with pond: @autoclosure () -> Pond) throws {
        struct Example: Codable, Equatable {
            let value: String
        }

        let model = ViewModel()
        DependencyValues.pond(pond())
        model.pond.remove(.testValue)

        XCTAssertNil(model.pond.getCodable(.testValue, type: Example.self))
        XCTAssertEqual(model.pond.get(.testValue, default: "My Value"), "My Value")
    }

    private func assertGetCodable(with pond: @autoclosure () -> Pond) throws {
        struct Example: Codable, Equatable {
            let value: String
        }

        let data = try XCTUnwrap(#"{"value": "hello world"}"#.data(using: .utf8))
        try assertCases(for: data, pond: pond())

        let model = ViewModel()
        DependencyValues.pond(pond())
        try model.pond.set(.testValue, value: data)

        let example = try XCTUnwrap(model.pond.getCodable(.testValue, type: Example.self))
        XCTAssertEqual(example.value, "hello world")
    }

    private func assertGetCodable2(with pond: @autoclosure () -> Pond) throws {
        struct Example: Codable, Equatable {
            let value: String
        }

        let model = ViewModel()
        DependencyValues.pond(pond())

        let value = Example(value: "Swift")
        model.pond.setCodable(.testValue, value: value)

        let example = try XCTUnwrap(model.pond.getCodable(.testValue, type: Example.self))
        XCTAssertEqual(example.value, "Swift")
    }

    private func assertGetCodableArray(with pond: @autoclosure () -> Pond) throws {
        struct Example: Codable, Equatable {
            let value: String
        }

        let model = ViewModel()
        DependencyValues.pond(pond())

        let values = [Example(value: "Swift"), Example(value: "Language")]
        model.pond.setCodable(.testValue, value: values)

        let examples = try XCTUnwrap(model.pond.getCodable(.testValue, type: [Example].self))
        XCTAssertEqual(examples[0].value, "Swift")
    }

    private func assertGetCodableDictionary(with pond: @autoclosure () -> Pond) throws {
        struct Example: Codable, Equatable {
            let value: String
        }

        let model = ViewModel()
        DependencyValues.pond(pond())

        let values = ["language": Example(value: "Swift")]
        model.pond.setCodable(.testValue, value: values)

        let examples = try XCTUnwrap(model.pond.getCodable(.testValue, type: [String: Example].self))
        XCTAssertEqual(examples["language"], Example(value: "Swift"))
    }
}

private final class ViewModel {
    @Dependency(\.pond) var pond
}

extension PondKey {
    fileprivate static var testValue: Self {
        .init(id: #function, storage: .userDefaults)
    }

    fileprivate static var testValue2: Self {
        .init(id: #function, storage: .userDefaults)
    }
}
