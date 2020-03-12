//
// UIControlBlocksTests.swift
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class UIControlBlocksTests: TestCase {
    func testAddAction() {
        let button = MockButton()
        XCTAssertEqual(button.values.count, 0)
        button.tap()
        XCTAssertEqual(button.values, ["hello"])

        button.attachAddAction(withValue: "world")
        XCTAssertEqual(button.values, ["hello"])
        button.tap()
        XCTAssertEqual(button.values, ["hello", "world"])

        button.removeAddAction()
        XCTAssertEqual(button.values, ["hello", "world"])
        button.values.removeAll()
        button.tap()
        XCTAssertEqual(button.values.count, 0)
    }

    func testAction() {
        let button = MockButton()
        XCTAssertEqual(button.values.count, 0)
        button.tap()
        XCTAssertEqual(button.values, ["hello"])

        button.attachAddAction(withValue: "world")
        XCTAssertEqual(button.values, ["hello"])
        button.tap()
        XCTAssertEqual(button.values, ["hello", "world"])

        button.attachAction(withValue: "greetings")
        XCTAssertEqual(button.values, ["hello", "world"])
        button.tap()
        XCTAssertEqual(button.values, ["hello", "world", "greetings"])

        button.removeAction()
        XCTAssertEqual(button.values, ["hello", "world", "greetings"])
        button.values.removeAll()
        button.tap()
        XCTAssertEqual(button.values.count, 0)
    }
}

private final class MockButton: XCView {
    private let button = UIButton()
    fileprivate var values: [String] = []

    override func commonInit() {
        // swiftlint:disable:next inconsistent_code_convention_action_block
        button.addAction(.touchUpInside) { [weak self] _ in
            self?.values.append("hello")
        }
    }

    func attachAddAction(withValue value: String) {
        // swiftlint:disable:next inconsistent_code_convention_action_block
        button.addAction(.touchUpInside) { [weak self] _ in
            self?.values.append(value)
        }
    }

    func tap() {
        button.sendActions(for: .touchUpInside)
    }

    func removeAddAction() {
        button.removeAction(.touchUpInside)
    }
}

extension MockButton {
    func attachAction(withValue value: String) {
        button.action { [weak self] _ in
            self?.values.append(value)
        }
    }

    func removeAction() {
        button.action(nil)
    }
}
