//
// SplitScreenViewController.swift
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

open class SplitScreenViewController: UIViewController {
    open let headerContainerView = UIView()
    open let bodyContainerView = UIView()

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerViews()
        setupConstraints()
    }

    open func addViewController(toHeaderContainerView vc: UIViewController, enableConstraints: Bool = true, padding: UIEdgeInsets = .zero) {
        addContainerViewController(vc, containerView: headerContainerView, enableConstraints: enableConstraints, padding: padding)
    }

    open func addViewController(toBodyContainerView vc: UIViewController, enableConstraints: Bool = true, padding: UIEdgeInsets = .zero) {
        addContainerViewController(vc, containerView: bodyContainerView, enableConstraints: enableConstraints, padding: padding)
    }

    // MARK: Setup Methods: Container Views

    fileprivate func setupContainerViews() {
        view.addSubview(headerContainerView)

        bodyContainerView.clipsToBounds = true
        view.addSubview(bodyContainerView)
    }

    fileprivate func setupConstraints() {
        let headerContainerViewAspectRatio: CGFloat = 16/9.1 // Set to 9.1 to ensure iPhone 5S landscape view doesn't have 1px gap below
        let priority = UILayoutPriorityDefaultHigh

        // Setup constraints: headerContainerView
        NSLayoutConstraint.constraintsForViewToFillSuperviewHorizontal(headerContainerView).activate()
        NSLayoutConstraint(item: headerContainerView, attribute: .top, toItem: view).activate()
        // Set aspect-ratio priority to low this ensures that landscape view works as expected.
        NSLayoutConstraint(item: headerContainerView, attribute: .width, toItem: headerContainerView, attribute: .height, multiplier: headerContainerViewAspectRatio, priority: priority).activate()

        // Setup constraints: bodyContainerView
        NSLayoutConstraint.constraintsForViewToFillSuperviewHorizontal(bodyContainerView).activate()
        NSLayoutConstraint(item: bodyContainerView, attribute: .bottom, toItem: view, priority: priority).activate()
        NSLayoutConstraint(item: bodyContainerView, attribute: .top, toItem: headerContainerView, attribute: .bottom).activate()
    }
}
