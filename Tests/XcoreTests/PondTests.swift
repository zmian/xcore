//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class PondTests: TestCase {
    func testPond() {
        let model = ViewModel()

        DependencyValues.pond(.stub())

        // Set value
        model.pond.set(.testValue, value: "Hello")
        XCTAssertTrue(model.pond.contains(.testValue))
        model.pond.remove(.testValue)
        XCTAssertFalse(model.pond.contains(.testValue))

        // Set/Get value
        model.pond.set(.testValue, value: "World")
        XCTAssertEqual(model.pond.get(.testValue), "World")
    }
}

private struct ViewModel {
    @Dependency(\.pond) var pond
}

extension PondKey {
    fileprivate static var testValue: Self {
        .init(id: #function, storage: .userDefaults)
    }
}
