//
// PageNavigationController.swift
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

open class PageNavigationController: NavigationController {
    private let pageControl = LinePageControl()

    /// The number of pages the receiver shows (as dots).
    ///
    /// The value of the property is the number of pages for the page control to
    /// show as dots.
    ///
    /// The default value is `0`.
    open var numberOfPages: Int {
        get { return pageControl.numberOfPages }
        set {
            pageControl.numberOfPages = newValue
            pageControl.isHidden = newValue <= 2
        }
    }

    /// A Boolean value that determines whether the page control is hidden.
    open var isPageControlHidden: Bool {
        get { return pageControl.isHidden }
        set { pageControl.isHidden = newValue }
    }

    /// The current page, shown by the receiver as a active dot.
    ///
    /// The property value is an integer specifying the current page shown minus
    /// one; thus a value of zero (the default) indicates the first page. A page
    /// control shows the current page as a white dot. Values outside the possible
    /// range are pinned to either `0` or `numberOfPages` minus `1`.
    open var currentPage: Int {
        get { return pageControl.currentPage }
        set { pageControl.currentPage = newValue }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        createPageControl()
    }

    private func createPageControl() {
        navigationBar.addSubview(pageControl)

        pageControl.anchor.make {
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(CGFloat.maximumPadding)
            $0.trailing.lessThanOrEqualToSuperview().inset(CGFloat.maximumPadding)
        }
    }
}
