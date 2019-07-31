//
// ImageTransform.swift
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

public protocol ImageTransform: ImageRepresentablePlugin {
    /// A unique id for the transform.
    var id: String { get }

    /// Invoked to transform the given image.
    ///
    /// - Parameters:
    ///   - image: The image to apply the transform.
    ///   - source: The original source from which the `image` was constructed.
    /// - Returns: The transformed `UIImage` object.
    func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage
}

extension ImageTransform {
    public var id: String {
        return transformName
    }

    var transformName: String {
        return name(of: self)
    }
}

extension ImageTransform {
    /// A convenience function to automatically set source to the input image.
    public func transform(_ image: UIImage) -> UIImage {
        return transform(image, source: image)
    }
}

extension ImageTransform {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
