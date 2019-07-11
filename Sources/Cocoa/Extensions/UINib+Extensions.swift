//
// UINib+Extensions.swift
//
// Copyright © 2015 Xcore
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

extension UINib {
    /// A optional initializer to return a `UINib` object initialized to the
    /// nib file in the specified bundle or in `main` bundle if no bundle is provided.
    ///
    /// - Parameters:
    ///   - named: The name of the nib file, without any leading path information.
    ///   - bundle: The bundle in which to search for the nib file. If you specify `nil`,
    ///             this method looks for the nib file in the `main` bundle.
    public convenience init?(named: String, bundle: Bundle? = nil) {
        let bundle = bundle ?? .main

        guard bundle.path(forResource: named, ofType: "nib") != nil else {
            return nil
        }

        self.init(nibName: named, bundle: bundle)
    }
}
