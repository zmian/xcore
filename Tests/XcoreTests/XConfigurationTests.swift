//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import UIKit
@testable import Xcore

@MainActor
struct XConfigurationTests {
    @Test
    func uiViewConfiguration() {
        let label = UILabel(configuration: .hello)
        #expect(label.text == "Hello, world!")
    }

    @Test
    func extend() {
        let greetLabel = UILabel(configuration: .greet(name: "Xcore"))
        #expect(greetLabel.text == "Hello, Xcore!")
        #expect(greetLabel.backgroundColor == .green)
    }

    @Test
    func identifier() {
        let config1: XConfiguration<UILabel> = .hello
        #expect(config1.id == "greeting")

        let config2: XConfiguration<UILabel> = .someConfiguration
        #expect(config2.id.rawValue == UUID(uuidString: config2.id.rawValue)?.uuidString)
    }

    @Test
    func equality() {
        let config1: XConfiguration<UILabel> = .hello
        let config2: XConfiguration<UILabel> = .someConfiguration
        #expect(config1 != config2)
    }

    @Test
    func apply() {
        let label = UILabel(configuration: .hello)
        #expect(label.text == "Hello, world!")
        label.apply(.greet(name: "Xcore"))
        #expect(label.text == "Hello, Xcore!")
    }

    @Test
    func arrayConformance() {
        let label = UILabel()
        let button = UIButton()

        #expect(label.isHidden == false)
        #expect(button.isHidden == false)

        [label, button].apply {
            $0.isHidden = true
        }

        #expect(label.isHidden == true)
        #expect(button.isHidden == true)

        let components = [UILabel(), UIButton()].apply {
            $0.isHidden = true
        }

        components.forEach {
            #expect($0.isHidden == true)
        }
    }

    @Test
    func uiLabelConfiguration() {
        let label = UILabel(text: "Hello, world!", configuration: .someConfiguration)
        #expect(label.text == "Hello, world!")
        #expect(label.backgroundColor == .red)
    }

    @Test
    func uiLabelAttributes() {
        let label = UILabel(text: "Hello, world!", attributes: [
            .foregroundColor: UIColor.purple
        ])

        #expect(label.text == "Hello, world!")
        #expect(label.attributedText != nil)

        let attributes = label.attributedText!.attributes(at: 0, effectiveRange: nil)

        var didFind = false

        for attr in attributes where attr.key == .foregroundColor {
            #expect(attr.value as! UIColor == .purple)
            didFind = true
        }

        if !didFind {
            Issue.record("No foreground color found.")
        }
    }
}

// MARK: - Test Configurations

@MainActor
extension XConfiguration<UILabel> {
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

@MainActor
extension XConfiguration<UIBarButtonItem> {
    fileprivate static var someConfiguration: Self {
        .init {
            $0.textColor = .yellow
        }
    }
}
