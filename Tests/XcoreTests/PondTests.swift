//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
import KeychainAccess
@testable import Xcore

@Suite(.serialized)
struct PondTests {
    @Test
    func pond_Basics_inMemory() throws {
        try assertBasicCases(with: .inMemory)
    }

    @Test
    func pond_Basics_UserDefaults() throws {
        let suite = try #require(UserDefaults(suiteName: "pond_test"))
        try assertBasicCases(with: .userDefaults(suite))
    }

    @Test
    func pond_Basics_Composite() throws {
        let suite = try #require(UserDefaults(suiteName: "pond_test"))
        let stub = InMemoryPond()
        let userDefaults = UserDefaultsPond(suite)

        try assertBasicCases(with: .composite(id: "test") { method, key in
            if key == .testValue2 {
                return stub
            }

            return userDefaults
        })
    }

    @Test
    func emptyPond() throws {
        let model = withDependencies {
            $0.pond = .empty
        } operation: {
            ViewModel()
        }

        // Set value
        try model.pond.set(.testValue, value: "Hello")
        #expect(!model.pond.contains(.testValue))
        model.pond.remove(.testValue)
        #expect(!model.pond.contains(.testValue))

        // Set/Get value
        try model.pond.set(.testValue, value: 123)
        #expect(try model.pond.get(Int.self, .testValue) == nil)
    }

    private func assertCases<T: Codable>(for value: T, pond: @autoclosure () -> Pond) throws where T: Equatable {
        let model = withDependencies {
            $0.pond = pond()
        } operation: {
            ViewModel()
        }

        // Set value
        try model.pond.set(.testValue, value: value)
        #expect(model.pond.contains(.testValue))
        model.pond.remove(.testValue)
        #expect(!model.pond.contains(.testValue))

        // Set/Get value
        try model.pond.set(.testValue2, value: value)
        #expect(try model.pond.get(.testValue2) == value)
    }

    private func assertCases(for value: NSNumber, pond: @autoclosure () -> Pond) throws {
        let model = withDependencies {
            $0.pond = pond()
        } operation: {
            ViewModel()
        }

        // Set value
        try model.pond.set(.testValue, value: value)
        #expect(model.pond.contains(.testValue))
        model.pond.remove(.testValue)
        #expect(!model.pond.contains(.testValue))

        // Set/Get value
        try model.pond.set(.testValue2, value: value)
        #expect(try model.pond.get(.testValue2) == value)
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

        let model = withDependencies {
            $0.pond = pond()
        } operation: {
            ViewModel()
        }

        model.pond.remove(.testValue)

        #expect(try model.pond.get(Example.self, .testValue) == nil)
        #expect(model.pond.get(.testValue, default: "My Value") == "My Value")
    }

    private func assertGetCodable(with pond: @autoclosure () -> Pond) throws {
        struct Example: Codable, Equatable {
            let value: String
        }

        let data = Data(#"{"value": "hello world"}"#.utf8)
        try assertCases(for: data, pond: pond())

        let model = withDependencies {
            $0.pond = pond()
        } operation: {
            ViewModel()
        }

        try model.pond.set(.testValue, value: data)
        let example = try #require(try model.pond.get(Example.self, .testValue))
        #expect(example.value == "hello world")
    }

    private func assertGetCodable2(with pond: @autoclosure () -> Pond) throws {
        struct Example: Codable, Equatable {
            let value: String
        }

        let model = withDependencies {
            $0.pond = pond()
        } operation: {
            ViewModel()
        }

        let value = Example(value: "Swift")
        try model.pond.set(.testValue, value: value)

        let example = try #require(try model.pond.get(Example.self, .testValue))
        #expect(example.value == "Swift")
    }

    private func assertGetCodableArray(with pond: @autoclosure () -> Pond) throws {
        struct Example: Codable, Equatable {
            let value: String
        }

        let model = withDependencies {
            $0.pond = pond()
        } operation: {
            ViewModel()
        }

        let values = [Example(value: "Swift"), Example(value: "Language")]
        try model.pond.set(.testValue, value: values)

        let examples = try #require(try model.pond.get([Example].self, .testValue))
        #expect(examples[0].value == "Swift")
    }

    private func assertGetCodableDictionary(with pond: @autoclosure () -> Pond) throws {
        struct Example: Codable, Equatable {
            let value: String
        }

        let model = withDependencies {
            $0.pond = pond()
        } operation: {
            ViewModel()
        }

        let values = ["language": Example(value: "Swift")]
        try model.pond.set(.testValue, value: values)

        let examples = try #require(try model.pond.get([String: Example].self, .testValue))
        #expect(examples["language"] == Example(value: "Swift"))
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
