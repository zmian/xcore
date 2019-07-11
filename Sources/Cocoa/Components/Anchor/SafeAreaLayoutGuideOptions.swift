//
// SafeAreaLayoutGuideOptions.swift
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

public struct SafeAreaLayoutGuideOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let top = SafeAreaLayoutGuideOptions(rawValue: 1 << 0)
    public static let bottom = SafeAreaLayoutGuideOptions(rawValue: 1 << 1)
    public static let leading = SafeAreaLayoutGuideOptions(rawValue: 1 << 2)
    public static let trailing = SafeAreaLayoutGuideOptions(rawValue: 1 << 3)

    public static let vertical: SafeAreaLayoutGuideOptions = [top, bottom]
    public static let horizontal: SafeAreaLayoutGuideOptions = [leading, trailing]

    public static let all: SafeAreaLayoutGuideOptions = [vertical, horizontal]
    public static let none: SafeAreaLayoutGuideOptions = []
}

extension SafeAreaLayoutGuideOptions {
    func topAnchor(_ view: UIView) -> NSLayoutAnchor<NSLayoutYAxisAnchor> {
        return contains(.top) ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
    }

    func bottomAnchor(_ view: UIView) -> NSLayoutAnchor<NSLayoutYAxisAnchor> {
        return contains(.bottom) ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor
    }

    func leadingAnchor(_ view: UIView) -> NSLayoutAnchor<NSLayoutXAxisAnchor> {
        return contains(.leading) ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor
    }

    func trailingAnchor(_ view: UIView) -> NSLayoutAnchor<NSLayoutXAxisAnchor> {
        return contains(.trailing) ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor
    }
}
