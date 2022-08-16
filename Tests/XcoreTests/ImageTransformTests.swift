//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class ImageTransformTests: TestCase {
    func testTransformIdentifier() {
        let transforms: [(String, ImageTransform)] = [
            (
                "Xcore.AlphaImageTransform-alpha:(0.2)",
                AlphaImageTransform(alpha: 0.2)
            ),
            (
                "Xcore.AlphaImageTransform-alpha:(0.7)_Xcore.AlphaImageTransform-alpha:(0.7)",
                CompositeImageTransform(arrayLiteral: AlphaImageTransform(alpha: 0.7), AlphaImageTransform(alpha: 0.7))
            ),
            (
                "Xcore.TintColorImageTransform-tintColor:(#FFFFFF)",
                TintColorImageTransform(tintColor: .white)
            ),
            (
                "Xcore.ColorizeImageTransform-color:(#FFFFFF)-kind:(colorize)",
                ColorizeImageTransform(color: .white, kind: .colorize)
            ),
            (
                "Xcore.ColorizeImageTransform-color:(#FFFFFF)-kind:(tintPicto)",
                ColorizeImageTransform(color: .white, kind: .tintPicto)
            ),
            (
                "Xcore.CornerRadiusImageTransform-cornerRadius:(60.0)",
                CornerRadiusImageTransform(cornerRadius: 60)
            ),
            (
                "Xcore.ResizeImageTransform-size:(10.0x100.0)-scalingMode:(aspectFill)",
                ResizeImageTransform(to: CGSize(width: 10, height: 100))
            ),
            (
                "Xcore.BackgroundImageTransform-color:(#000000)-preferredSize:(120.0x300.0)-alignment:(0)",
                BackgroundImageTransform(color: .black, preferredSize: CGSize(width: 120, height: 300))
            )
        ]

        for transform in transforms {
            let input = transform.1.id
            let output = transform.0
            XCTAssertEqual(input, output)
        }
    }
}
