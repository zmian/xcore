//
// CoreGraphics+Extensions.swift
//
// Copyright © 2018 Xcore
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
import CoreGraphics

extension CGContext {
    /// This method scales the image (disproportionately, if necessary) to fit the bounds
    /// specified by the rect parameter. When the `byTiling` parameter is true, the image is
    /// tiled in user space—thus, unlike when drawing with patterns, the current
    /// transformation (see the `ctm` property) affects the final result.
    ///
    /// - Parameters:
    ///   - image: The image to draw.
    ///   - rect: The rectangle, in user space coordinates, in which to draw the image.
    ///   - byTiling:
    ///     If `true`, this method fills the context's entire clipping region by tiling
    ///     many copies of the image, and the `rect` parameter defines the origin and
    ///     size of the tiling pattern.
    ///
    ///     If `false` (the default), this method draws a single copy of the image in the
    ///     area defined by the `rect` parameter.
    public func draw(_ image: UIImage, in rect: CGRect, byTiling: Bool = false) {
        draw(image.cgImage!, in: rect, byTiling: byTiling)
    }
}
