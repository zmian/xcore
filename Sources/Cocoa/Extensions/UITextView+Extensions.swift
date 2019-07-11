//
// UITextView+Extensions.swift
//
// Copyright © 2019 Xcore
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

extension UITextView {
    /// The maximum number of lines to use for rendering text.
    ///
    /// This property controls the maximum number of lines to use in order to fit
    /// the label’s text into its bounding rectangle. The default value for this
    /// property is `1`. To remove any maximum limit, and use as many lines as
    /// needed, set the value of this property to `0`.
    ///
    /// If you constrain your text using this property, any text that does not fit
    /// within the maximum number of lines and inside the bounding rectangle of the
    /// label is truncated using the appropriate line break mode, as specified by
    /// the `lineBreakMode` property.
    ///
    /// When the label is resized using the `sizeToFit()` method, resizing takes
    /// into account the value stored in this property. For example, if this
    /// property is set to `3`, the `sizeToFit()` method resizes the receiver so
    /// that it is big enough to display three lines of text.
    public var numberOfLines: Int {
        get {
            guard let font = font else {
                return 0
            }

            return Int(contentSize.height / font.lineHeight)
        }
        set { textContainer.maximumNumberOfLines = newValue }
    }
}
