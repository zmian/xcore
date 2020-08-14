//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class StackViewArrangedSubviewsTests: TestCase {
    private let stackView = UIStackView().apply {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }

    private lazy var views = makeViews()
    private lazy var red = views[0]
    private lazy var blue = views[1]
    private lazy var yellow = views[2]
    private lazy var purple = views[3]

    override func setUp() {
        super.setUp()
        stackView.addArrangedSubviews(views)
    }

    override func tearDown() {
        super.tearDown()
        stackView.removeAllArrangedSubviews()
    }

    func testAfterMovingToSameLocation() {
        stackView.moveArrangedSubview(yellow, after: blue)
        XCTAssertEqual(stackView.arrangedSubviews, [red, blue, yellow, purple])
    }

    func testAfterSwappingSiblingViews() {
        stackView.moveArrangedSubview(blue, after: yellow)
        XCTAssertEqual(stackView.arrangedSubviews, [red, yellow, blue, purple])
    }

    func testBeforeMovingToSameLocation() {
        stackView.moveArrangedSubview(blue, before: yellow)
        XCTAssertEqual(stackView.arrangedSubviews, [red, blue, yellow, purple])
    }

    func testBeforeSwappingSiblingViews() {
        stackView.moveArrangedSubview(yellow, before: blue)
        XCTAssertEqual(stackView.arrangedSubviews, [red, yellow, blue, purple])
    }
}

// MARK: - Helpers

extension StackViewArrangedSubviewsTests {
    private enum Tag: Int, CustomStringConvertible {
        case red = 100
        case blue
        case yellow
        case purple

        var description: String {
            switch self {
                case .red:
                    return "red"
                case .blue:
                    return "blue"
                case .yellow:
                    return "yellow"
                case .purple:
                    return "purple"
            }
        }
    }

    private func makeViews() -> [UIView] {
        class CustomView: UIView {
            override var description: String {
                Tag(rawValue: tag)!.description
            }
        }

        let red = CustomView().apply {
            $0.tag = Tag.red.rawValue
        }

        let blue = CustomView().apply {
            $0.tag = Tag.blue.rawValue
        }

        let yellow = CustomView().apply {
            $0.tag = Tag.yellow.rawValue
        }

        let purple = CustomView().apply {
            $0.tag = Tag.purple.rawValue
        }

        return [red, blue, yellow, purple]
    }
}
