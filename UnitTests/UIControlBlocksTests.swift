//
// UIControlBlocksTests.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
