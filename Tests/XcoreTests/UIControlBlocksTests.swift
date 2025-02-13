//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import UIKit
@testable import Xcore

@MainActor
struct UIControlBlocksTests {
    @Test
    func addAction() {
        let button = MockButton()
        #expect(button.values.count == 0)
        button.tap()
        #expect(button.values == ["hello"])

        button.attachAddAction(withValue: "world")
        #expect(button.values == ["hello"])
        button.tap()
        #expect(button.values == ["hello", "world"])

        button.removeAddAction()
        #expect(button.values == ["hello", "world"])
        button.values.removeAll()
        button.tap()
        #expect(button.values.count == 0)
    }

    @Test
    func action() {
        let button = MockButton()
        #expect(button.values.count == 0)
        button.tap()
        #expect(button.values == ["hello"])

        button.attachAddAction(withValue: "world")
        #expect(button.values == ["hello"])
        button.tap()
        #expect(button.values == ["hello", "world"])

        button.attachAction(withValue: "greetings")
        #expect(button.values == ["hello", "world"])
        button.tap()
        #expect(button.values == ["hello", "world", "greetings"])

        button.removeAction()
        #expect(button.values == ["hello", "world", "greetings"])
        button.values.removeAll()
        button.tap()
        #expect(button.values.count == 0)
    }
}

private final class MockButton: XCView {
    private let button = UIButton()
    fileprivate var values: [String] = []

    override func commonInit() {
        button.addAction(.primaryActionTriggered) { [weak self] _ in
            self?.values.append("hello")
        }
    }

    func attachAddAction(withValue value: String) {
        button.addAction(.primaryActionTriggered) { [weak self] _ in
            self?.values.append(value)
        }
    }

    func tap() {
        button.sendActions(for: .primaryActionTriggered)
    }

    func removeAddAction() {
        button.removeAction(.primaryActionTriggered)
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
