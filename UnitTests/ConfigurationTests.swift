//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class ConfigurationTests: TestCase {
    func testUIViewConfiguration() {
        let label = UILabel(configuration: .hello)
        XCTAssertEqual(label.text, "Hello, world!")
    }

    func testUIBarButtonItemConfiguration() {
        let barButtonItem = UIBarButtonItem(configuration: .someConfiguration)
        XCTAssertEqual(barButtonItem.textColor, .yellow)
    }

    func testExtend() {
        let greetLabel = UILabel(configuration: .greet(name: "Xcore"))
        XCTAssertEqual(greetLabel.text, "Hello, Xcore!")
        XCTAssertEqual(greetLabel.backgroundColor, .green)
    }

    func testIdentifier() {
        let config1: Configuration<UILabel> = .hello
        XCTAssertEqual(config1.id, "greeting")

        let config2: Configuration<UILabel> = .someConfiguration
        XCTAssertEqual(config2.id, "___defaultId___")
    }

    func testEquality() {
        let config1: Configuration<UILabel> = .hello
        let config2: Configuration<UILabel> = .someConfiguration
        XCTAssertNotEqual(config1, config2)
    }

    func testApply() {
        let label = UILabel(configuration: .hello)
        XCTAssertEqual(label.text, "Hello, world!")
        label.apply(.greet(name: "Xcore"))
        XCTAssertEqual(label.text, "Hello, Xcore!")
    }

    func testArrayConformance() {
        let label = UILabel()
        let button = UIButton()

        XCTAssertEqual(label.isHidden, false)
        XCTAssertEqual(button.isHidden, false)

        [label, button].apply {
            $0.isHidden = true
        }

        XCTAssertEqual(label.isHidden, true)
        XCTAssertEqual(button.isHidden, true)

        let components = [UILabel(), UIButton()].apply {
            $0.isHidden = true
        }

        components.forEach {
            XCTAssertEqual($0.isHidden, true)
        }
    }

    func testUILabelConfiguration() {
        let label = UILabel(text: "Hello, world!", configuration: .someConfiguration)
        XCTAssertEqual(label.text, "Hello, world!")
        XCTAssertEqual(label.backgroundColor, .red)
    }

    func testUILabelAttributes() {
        let label = UILabel(text: "Hello, world!", attributes: [
            .foregroundColor: UIColor.purple
        ])

        XCTAssertEqual(label.text, "Hello, world!")
        XCTAssertNotNil(label.attributedText)

        let attributes = label.attributedText!.attributes(at: 0, effectiveRange: nil)

        var didFind = false

        for attr in attributes where attr.key == .foregroundColor {
            XCTAssertEqual(attr.value as! UIColor, .purple)
            didFind = true
        }

        if !didFind {
            XCTAssert(false, "No foreground color found.")
        }
    }
}

// MARK: - Test Configurations

extension Configuration where Type: UILabel {
    fileprivate static var hello: Self {
        .init(id: "greeting") {
            $0.text = "Hello, world!"
            $0.backgroundColor = .green
        }
    }

    fileprivate static func greet(name: String) -> Self {
        hello.extend(id: "greetWithName") {
            $0.text = "Hello, \(name)!"
        }
    }

    fileprivate static var someConfiguration: Self {
        .init {
            $0.backgroundColor = .red
        }
    }
}

extension Configuration where Type: UIBarButtonItem {
    fileprivate static var someConfiguration: Self {
        .init {
            $0.textColor = .yellow
        }
    }
}
