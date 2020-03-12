//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

enum ExampleArrowOptions: String, CaseIterable, OptionsRepresentable {
    case up
    case down
    case left
    case right

    static var title: String? {
        "Please select an arrow"
    }

    static var message: String? {
        "This is a message"
    }

    var description: String {
        rawValue.uppercasedFirst()
    }

    var image: ImageRepresentable? {
        let identifier: ImageAssetIdentifier

        switch self {
            case .up:
                identifier = .caretDirectionUp
            case .down:
                identifier = .caretDirectionDown
            case .left:
                identifier = .caretDirectionBack
            case .right:
                identifier = .caretDirectionForward
        }

        return identifier.transform(imageTransform)
    }

    private var imageTransform: ImageTransform {
        switch self {
            case .up:
                return GradientImageTransform(
                    colors: [UIColor(hex: "8E2DE2"), UIColor(hex: "4A00E0")],
                    direction: .topLeftToBottomRight
                )
            case .down:
                return GradientImageTransform(
                    colors: [UIColor(hex: "c31432"), UIColor(hex: "240b36")],
                    direction: .topLeftToBottomRight
                )
            case .left:
                return GradientImageTransform(
                    colors: [UIColor(hex: "C6FFDD"), UIColor(hex: "f7797d")],
                    direction: .topLeftToBottomRight
                )
            case .right:
                return GradientImageTransform(
                    colors: [UIColor(hex: "11998e"), UIColor(hex: "38ef7d")],
                    direction: .topLeftToBottomRight
                )
        }
    }
}

extension ImageAssetIdentifier {
    private static func propertyName(name: String = #function) -> Self {
        .init(rawValue: name, bundle: .xcore)
    }

    // MARK: Carets
    static var caretDirectionUp: Self { propertyName() }
    static var caretDirectionDown: Self { propertyName() }
    static var caretDirectionBack: Self { propertyName() }
    static var caretDirectionForward: Self { propertyName() }
}
