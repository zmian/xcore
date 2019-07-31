//
// CompositeImageTransform.swift
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

public struct CompositeImageTransform: ImageTransform, ExpressibleByArrayLiteral {
    private var transforms: [ImageTransform] = []

    public init(_ transforms: [ImageTransform]) {
        self.transforms = transforms
    }

    public init(arrayLiteral elements: ImageTransform...) {
        self.transforms = elements
    }

    /// Adds a new transform at the end of the collection.
    public mutating func add(_ transform: ImageTransform) {
        transforms.append(transform)
    }

    /// Removes the given transform.
    public mutating func remove(_ transform: ImageTransform) {
        let ids = transforms.map { $0.id }

        guard let index = ids.firstIndex(of: transform.id) else {
            return
        }

        transforms.remove(at: index)
    }
}

extension CompositeImageTransform {
    public var id: String {
        return transforms.map { $0.id }.joined(separator: "_")
    }

    public func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage {
        return transforms.reduce(image) { $1.transform($0, source: source) }
    }
}
