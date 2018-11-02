//
// ComposedImageTransform.swift
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

final public class ComposedImageTransform: ImageTransform, ExpressibleByArrayLiteral {
    private var transforms: [ImageTransform] = []

    public init(arrayLiteral elements: ImageTransform...) {
        self.transforms = elements
    }

    public func add(_ transform: ImageTransform) {
        transforms.append(transform)
    }

    public func remove(_ transform: ImageTransform) {
        let identifiers = transforms.map { $0.identifier }

        guard let index = identifiers.index(of: transform.identifier) else {
            return
        }

        transforms.remove(at: index)
    }

    public static func == (lhs: ComposedImageTransform, rhs: ComposedImageTransform) -> Bool {
        let lhs = lhs.transforms.map { $0.identifier }.joined()
        let rhs = rhs.transforms.map { $0.identifier }.joined()
        return lhs == rhs
    }
}

extension ComposedImageTransform {
    public func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage {
        var inputImage = image

        for transform in transforms {
            inputImage = transform.transform(inputImage)
        }

        return inputImage
    }
}
