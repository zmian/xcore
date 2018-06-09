//
// XcoreSwizzle.swift
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
import WebKit

private var didStart = false
public func xcoreSwizzle(_ options: SwizzleOptions = .all) {
    guard !didStart else { return }
    didStart = true

    if options.contains(.imageView) {
        UIImageView.runOnceSwapSelectors()
    }

    if options.contains(.textField) {
        UITextField.runOnceSwapSelectors()
    }

    if options.contains(.searchBar) {
        UISearchBar.runOnceSwapSelectors()
    }

    if options.contains(.viewController) {
        UIViewController.runOnceSwapSelectors()
    }

    if options.contains(.userContentController) {
        WKUserContentController.runOnceSwapSelectors()
    }
}

/// A list of features available to swizzle.
public struct SwizzleOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let imageView             = SwizzleOptions(rawValue: 1 << 0)
    public static let textField             = SwizzleOptions(rawValue: 1 << 1)
    public static let searchBar             = SwizzleOptions(rawValue: 1 << 2)
    public static let viewController        = SwizzleOptions(rawValue: 1 << 3)
    public static let userContentController = SwizzleOptions(rawValue: 1 << 4)
    public static let all: SwizzleOptions = [imageView, textField, searchBar, viewController, userContentController]
}
