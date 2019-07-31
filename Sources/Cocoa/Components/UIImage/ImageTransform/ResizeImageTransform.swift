//
// ResizeImageTransform.swift
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

public struct ResizeImageTransform: ImageTransform {
    private let size: CGSize
    private let scalingMode: ScalingMode

    public var id: String {
        return "\(transformName)-size:(\(size.width)x\(size.height))-scalingMode:(\(scalingMode))"
    }

    public init(to size: CGSize, scalingMode: ScalingMode = .aspectFill) {
        self.size = size
        self.scalingMode = scalingMode
    }

    public func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage {
        let rect = scalingMode.rect(newSize: size, and: image.size)
        return UIGraphicsImageRenderer(bounds: rect).image { _ in
            image.draw(in: rect)
        }
    }
}

extension ResizeImageTransform {
    /// Represents a scaling mode
    public enum ScalingMode {
        case fill
        case aspectFill
        case aspectFit

        /// Calculates the aspect ratio between two sizes.
        ///
        /// - Parameters:
        ///   - size: The first size used to calculate the ratio.
        ///   - otherSize: The second size used to calculate the ratio.
        /// - Returns: the aspect ratio between the two sizes.
        private func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth = size.width / otherSize.width
            let aspectHeight = size.height / otherSize.height

            switch self {
                case .fill:
                    return 1
                case .aspectFill:
                    return max(aspectWidth, aspectHeight)
                case .aspectFit:
                    return min(aspectWidth, aspectHeight)
            }
        }

        fileprivate func rect(newSize: CGSize, and otherSize: CGSize) -> CGRect {
            guard self != .fill else {
                return CGRect(origin: .zero, size: newSize)
            }

            let aspectRatio = self.aspectRatio(between: newSize, and: otherSize)

            // Build the rectangle representing the area to be drawn
            let scaledImageRect = CGRect(
                x: (newSize.width - otherSize.width * aspectRatio) / 2.0,
                y: (newSize.height - otherSize.height * aspectRatio) / 2.0,
                width: otherSize.width * aspectRatio,
                height: otherSize.height * aspectRatio
            )

            return scaledImageRect
        }
    }
}
