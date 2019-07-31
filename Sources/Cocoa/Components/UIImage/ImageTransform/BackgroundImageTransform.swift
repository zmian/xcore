//
// BackgroundImageTransform.swift
//
// Copyright © 2017 Xcore
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

public struct BackgroundImageTransform: ImageTransform {
    private let color: UIColor
    private let preferredSize: CGSize
    private let alignment: UIControl.ContentHorizontalAlignment

    public var id: String {
        return "\(transformName)-color:(\(color.hex))-preferredSize:(\(preferredSize.width)x\(preferredSize.height))-alignment:(\(alignment))"
    }

    public init(color: UIColor, preferredSize: CGSize, alignment: UIControl.ContentHorizontalAlignment = .center) {
        self.color = color
        self.preferredSize = preferredSize
        self.alignment = alignment
    }

    public func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage {
        let size = image.size
        let finalSize = CGSize(
            width: max(size.width, preferredSize.width),
            height: max(size.height, preferredSize.width)
        )

        let rect = CGRect(origin: .zero, size: finalSize)
        var drawingPosition = CGPoint(x: 0, y: (finalSize.height - size.height) / 2)

        switch alignment {
            case .center, .fill:
                drawingPosition.x = (finalSize.width - size.width) / 2
            case .left, .leading:
                break
            case .right, .trailing:
                drawingPosition.x = finalSize.width - size.width
            @unknown default:
                fatalError(because: .unknownCaseDetected(alignment))
        }

        return UIGraphicsImageRenderer(bounds: rect).image { rendererContext in
            let context = rendererContext.cgContext
            context.setFillColor(color.cgColor)
            context.fill(rect)
            image.draw(at: drawingPosition)
        }
    }
}
