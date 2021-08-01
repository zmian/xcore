//
// Xcore
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
        // swiftlint:disable:next icc_action_block
        button.addAction(.touchUpInside) { [weak self] _ in
            self?.values.append("hello")
        }
    }

    func attachAddAction(withValue value: String) {
        // swiftlint:disable:next icc_action_block
        button.addAction(.touchUpInside) { [weak self] _ in
            self?.values.append(value)
        }
    }

    func tap() {
        button.simulateSendAction(.touchUpInside)
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

// MARK: - Helper

extension UIControl {
    /// Simulate send action for testing target.
    ///
    /// When ``sendActions(for:)`` is called on a ``UIControl``, the control will
    /// call the ``UIApplication``'s ``sendAction(_:to:from:for:)`` to deliver the
    /// event to the registered target. See [overview] of the issue and solution
    /// [snippet].
    ///
    /// Testing a library without any Host Application, there is no
    /// ``UIApplication`` object. Hence, the ``.touchUpInside`` event is not
    /// dispatched and the observe method does not get called.
    ///
    /// [overview]: https://stackoverflow.com/a/39856918
    /// [snippet]: https://stackoverflow.com/a/58521288
    fileprivate func simulateSendAction(_ event: UIControl.Event) {
        for target in allTargets {
            let target = target as NSObjectProtocol
            for actionName in actions(forTarget: target, forControlEvent: event) ?? [] {
                let selector = Selector(actionName)
                target.perform(selector, with: self)
            }
        }
    }
}
