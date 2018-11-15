//
// ImageTransformTests.swift
//
// Copyright © 2018 Zeeshan Mian
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
                "Xcore.GradientImageTransform-type:(axial)-colors:(#FF0000,#00FF00)-direction:(topToBottom)-locations:(nil)-blendMode:(20)",
                GradientImageTransform(type: .axial, colors: [.red, .green], direction: .topToBottom, locations: nil, blendMode: .sourceAtop)
            ),
            (
                "Xcore.GradientImageTransform-type:(axial)-colors:(#FF0000,#00FF00)-direction:(topToBottom)-locations:(0.5,0.8)-blendMode:(17)",
                GradientImageTransform(type: .axial, colors: [.red, .green], direction: .topToBottom, locations: [0.5, 0.8], blendMode: .copy)
            ),
            (
                "Xcore.ResizeImageTransform-size:(10.0x100.0)-scalingMode:(aspectFill)",
                ResizeImageTransform(to: CGSize(width: 10, height: 100))
            ),
            (
                "Xcore.BackgroundImageTransform-color:(#000000)-preferredSize:(120.0x300.0)-alignment:(UIControlContentHorizontalAlignment)",
                BackgroundImageTransform(color: .black, preferredSize: CGSize(width: 120, height: 300))
            )
        ]

        for transform in transforms {
            let input = transform.1.identifier
            let output = transform.0
            XCTAssertTrue(input == output, "Expected identifier to be \"\(output)\", instead found \"\(input).\"")
        }
    }
}
