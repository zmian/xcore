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
        try assertBasicCases(with: .stub)
    }

    func testPond_Basic_UserDefaults() throws {
        let suite = try XCTUnwrap(UserDefaults(suiteName: "pond_test"))
        try assertBasicCases(with: .userDefaults(suite))
    }

    func testPond_Basic_Composit() throws {
        let suite = try XCTUnwrap(UserDefaults(suiteName: "pond_test"))
        let stub = StubPond()
        let userDefaults = UserDefaultsPond(suite)

        try assertBasicCases(with: .composite { key in
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
        model.pond.set(.testValue, value: "Hello")
        XCTAssertFalse(model.pond.contains(.testValue))
        model.pond.remove(.testValue)
        XCTAssertFalse(model.pond.contains(.testValue))

        // Set/Get value
        model.pond.set(.testValue, value: 123)
        XCTAssertNil(model.pond.get(.testValue))
    }

    private func assertCases<T>(for value: T, pond: @autoclosure () -> Pond) where T: Equatable {
        let model = ViewModel()

        DependencyValues.pond(pond())

        // Set value
        model.pond.set(.testValue, value: value)
        XCTAssertTrue(model.pond.contains(.testValue))
        model.pond.remove(.testValue)
        XCTAssertFalse(model.pond.contains(.testValue))

        // Set/Get value
        model.pond.set(.testValue2, value: value)
        XCTAssertEqual(model.pond.get(.testValue2), value)
    }
}

// MARK: - Test Cases

extension PondTests {
    private func assertBasicCases(with pond: @autoclosure () -> Pond) throws {
        assertCases(for: "Hello", pond: pond())
        assertCases(for: ["Hello", "World"], pond: pond())
        assertCases(for: ["Hello": "World"], pond: pond())
        assertCases(for: ["Number": 315.36], pond: pond())
        assertCases(for: [123, 315.36], pond: pond())
        assertCases(for: 123, pond: pond())
        assertCases(for: 315.36, pond: pond())
        assertCases(for: Float(315.36), pond: pond())
        assertCases(for: false, pond: pond())
        assertCases(for: true, pond: pond())

        assertCases(for: NSNumber(315.36), pond: pond())

        assertCases(for: Date().timeIntervalSinceNow, pond: pond())
        assertCases(for: Date(), pond: pond())
        assertCases(for: Date().adjusting(.day, by: 10), pond: pond())

        assertCases(for: URL(string: "http://example.com"), pond: pond())
        assertCases(for: NSURL(string: "http://example.com")! as URL, pond: pond())
        assertCases(for: NSURL(string: "http://example.com"), pond: pond())

        // Test Data
        assertCases(for: Crypt.generateSecureRandom(), pond: pond())
        assertCases(for: Data("Hello World".utf8), pond: pond())

        try assertGetDefaultValue(with: pond())
        try assertGetDecoded(with: pond())
    }

    private func assertGetDefaultValue(with pond: @autoclosure () -> Pond) throws {
        struct Example: Codable, Equatable {
            let value: String
        }

        let model = ViewModel()
        DependencyValues.pond(pond())
        model.pond.remove(.testValue)

        XCTAssertNil(model.pond.getDecoded(.testValue, type: Example.self))
        XCTAssertEqual(model.pond.get(.testValue, default: "My Value"), "My Value")
    }

    private func assertGetDecoded(with pond: @autoclosure () -> Pond) throws {
        struct Example: Codable, Equatable {
            let value: String
        }

        let data = try XCTUnwrap(#"{"value": "hello world"}"#.data(using: .utf8))
        assertCases(for: data, pond: pond())

        let model = ViewModel()
        DependencyValues.pond(pond())
        model.pond.set(.testValue, value: data)

        let example = try XCTUnwrap(model.pond.getDecoded(.testValue, type: Example.self))
        XCTAssertEqual(example.value, "hello world")
    }
}

private struct ViewModel {
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