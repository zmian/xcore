//
// ResizeImageTransform.swift
//
// Copyright © 2017 Zeeshan Mian
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

final class ResizeImageTransform: ImageTransform {
    private let newSize: CGSize
    private let scalingMode: UIImage.ScalingMode

    init(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill) {
        self.newSize = newSize
        self.scalingMode = scalingMode
    }

    func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage {
        let rect = scalingMode.rect(newSize: newSize, and: image.size)
        return UIGraphicsImageRenderer(bounds: rect).image { _ in
            image.draw(in: rect)
        }
    }
}

extension UIImage {
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

    /// Scales an image to fit within a bounds of the given size.
    ///
    /// - Parameters:
    ///   - newSize: The size of the bounds the image must fit within.
    ///   - scalingMode: The desired scaling mode. The default value is `.aspectFill`.
    ///   - tintColor: An optional tint color to apply. The default value is `nil`.
    ///
    /// - Returns: A new scaled image.
    public func scaled(to newSize: CGSize, scalingMode: ScalingMode = .aspectFill, tintColor: UIColor? = nil) -> UIImage {
        let transformers: CompositeImageTransform = [ResizeImageTransform(to: newSize, scalingMode: scalingMode)]

        if let tintColor = tintColor {
            transformers.add(TintColorImageTransform(tintColor: tintColor))
        }

        return transformers.transform(self)
    }

    /// Scales an image to fit within a bounds of the given size.
    ///
    /// - Parameters:
    ///   - newSize: The size of the bounds the image must fit within.
    ///   - scalingMode: The desired scaling mode. The default value is `.aspectFill`.
    ///   - tintColor: An optional tint color to apply. The default value is `nil`.
    ///   - completionHandler: The completion handler to invoke on the `.main` thread when the scaled operation completes.
    public func scaled(to newSize: CGSize, scalingMode: ScalingMode = .aspectFill, tintColor: UIColor? = nil, completionHandler: @escaping (_ scaledImage: UIImage) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let strongSelf = self else { return }

            let finalImage = strongSelf.scaled(to: newSize, scalingMode: scalingMode, tintColor: tintColor)

            DispatchQueue.main.async {
                completionHandler(finalImage)
            }
        }
    }
}
