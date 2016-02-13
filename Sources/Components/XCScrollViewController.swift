//
// XCScrollViewController.swift
//
// Copyright © 2015 Zeeshan Mian
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

public class XCScrollViewController: UIViewController {
    public let scrollView = UIScrollView()

    /// A boolean value to determine whether the `scrollView`'s `top` is constrained to `topLayoutGuide`.
    /// The default value is `false`.
    public var constraintToTopLayoutGuide    = false

    /// A boolean value to determine whether the `scrollView`'s `bottom` is constrained to `bottomLayoutGuide`.
    /// The default value is `false`.
    public var constraintToBottomLayoutGuide = false

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
    }

    private func setupContentView() {
        view.addSubview(scrollView)

        NSLayoutConstraint.constraintsForViewToFillSuperviewHorizontal(scrollView).activate()

        NSLayoutConstraint(
            item:      scrollView,
            attribute: .Top,
            toItem:    constraintToTopLayoutGuide ? topLayoutGuide : view,
            attribute: constraintToTopLayoutGuide ? .Bottom : .Top
        ).activate()

        NSLayoutConstraint(
            item:      scrollView,
            attribute: .Bottom,
            toItem:    constraintToBottomLayoutGuide ? bottomLayoutGuide : view,
            attribute: constraintToBottomLayoutGuide ? .Top : .Bottom
        ).activate()

        resolveContentSize()
    }

    private func resolveContentSize() {
        let scrollViewWidthResolver = UIView()
        scrollViewWidthResolver.hidden = true
        scrollView.addSubview(scrollViewWidthResolver)
        NSLayoutConstraint.constraintsForViewToFillSuperviewHorizontal(scrollViewWidthResolver).activate()
        NSLayoutConstraint(item: scrollViewWidthResolver, attribute: .Top, toItem: scrollView).activate()
        NSLayoutConstraint(item: scrollViewWidthResolver, height: 1).activate()

        // Now the important part
        // Setting the `scrollViewWidthResolver` width to `self.view` width correctly defines the content width of the scroll view
        NSLayoutConstraint(item: scrollViewWidthResolver, attribute: .Width, toItem: view).activate()
    }
}
