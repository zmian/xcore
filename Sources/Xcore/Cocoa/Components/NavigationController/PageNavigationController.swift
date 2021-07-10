//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
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
        get { pageControl.numberOfPages }
        set {
            pageControl.numberOfPages = newValue
            pageControl.isHidden = newValue <= 2
        }
    }

    /// A Boolean value that determines whether the page control is hidden.
    open var isPageControlHidden: Bool {
        get { pageControl.isHidden }
        set { pageControl.isHidden = newValue }
    }

    /// The current page, shown by the receiver as a active dot.
    ///
    /// The property value is an integer specifying the current page shown minus
    /// one; thus a value of zero (the default) indicates the first page. A page
    /// control shows the current page as a white dot. Values outside the possible
    /// range are pinned to either `0` or `numberOfPages` minus `1`.
    open var currentPage: Int {
        get { pageControl.currentPage }
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
            $0.leading.greaterThanOrEqualToSuperview().inset(CGFloat.s6)
            $0.trailing.lessThanOrEqualToSuperview().inset(CGFloat.s6)
        }
    }
}
