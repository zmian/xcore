//
// ExampleArrowOptions.swift
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
