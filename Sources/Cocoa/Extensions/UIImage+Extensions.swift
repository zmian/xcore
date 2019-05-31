//
// UIImage+Extensions.swift
//
// Copyright © 2014 Xcore
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

extension UIImage {
    /// A convenience init identical to `UIImage:named` but does not cache images
    /// in memory. This is great for animations to quickly discard images after use.
    ///
    /// - Parameters:
    ///   - fileName: The name of the file to construct.
    ///   - bundle: The bundle in which this file is located in. The default value is `.main`.
    public convenience init?(fileName: String, in bundle: Bundle = .main) {
        let name = fileName.deletingPathExtension
        let ext = fileName.pathExtension.isEmpty ? "png" : fileName.pathExtension

        guard let path = bundle.path(forResource: name, ofType: ext) else {
            return nil
        }

        self.init(contentsOfFile: path)
    }

    /// Creates an image from specified color and size.
    ///
    /// - Parameters:
    ///   - color: The color used to create the image.
    ///   - size: The size of the image. The default size is `50`.
    public convenience init(color: UIColor, size: CGSize = 50) {
        let rect = CGRect(size)

        let image = UIGraphicsImageRenderer(bounds: rect).image { rendererContext in
            let context = rendererContext.cgContext
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }

        self.init(cgImage: image.cgImage!)
    }
}
