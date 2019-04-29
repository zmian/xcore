//
// XCConfigurationTests.swift
//
// Copyright © 2019 Zeeshan Mian
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

final class XCConfigurationTests: TestCase {
    func testUIViewConfiguration() {
        let label = UILabel(style: .hello)
        XCTAssertEqual(label.text, "Hello, world!")
    }

    func testUIBarButtonItemConfiguration() {
        let barButtonItem = UIBarButtonItem(style: .someStyle)
        XCTAssertEqual(barButtonItem.textColor, .yellow)
    }

    func testExtend() {
        let greetLabel = UILabel(style: .greet(name: "Xcore"))
        XCTAssertEqual(greetLabel.text, "Hello, Xcore!")
        XCTAssertEqual(greetLabel.backgroundColor, .green)
    }

    func testIdentifier() {
        let config1: XCConfiguration<UILabel> = .hello
        XCTAssertEqual(config1.identifier, "greeting")

        let config2: XCConfiguration<UILabel> = .someStyle
        XCTAssertEqual(config2.identifier, "___defaultIdentifier___")
    }

    func testEquality() {
        let config1: XCConfiguration<UILabel> = .hello
        let config2: XCConfiguration<UILabel> = .someStyle
        XCTAssertTrue(config1 != config2)
    }

    func testApply() {
        let label = UILabel(style: .hello)
        XCTAssertEqual(label.text, "Hello, world!")
        label.apply(style: .greet(name: "Xcore"))
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
        let label = UILabel(style: .someStyle, text: "Hello, world!")
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

extension XCConfiguration where Type: UILabel {
    fileprivate static var hello: XCConfiguration {
        return XCConfiguration(identifier: "greeting") {
            $0.text = "Hello, world!"
            $0.backgroundColor = .green
        }
    }

    fileprivate static func greet(name: String) -> XCConfiguration {
        return hello.extend(identifier: "greetWithName") {
            $0.text = "Hello, \(name)!"
        }
    }

    fileprivate static var someStyle: XCConfiguration {
        return XCConfiguration {
            $0.backgroundColor = .red
        }
    }
}

extension XCConfiguration where Type: UIBarButtonItem {
    fileprivate static var someStyle: XCConfiguration {
        return XCConfiguration {
            $0.textColor = .yellow
        }
    }
}
