//
// XCPageViewController.swift
//
// Copyright © 2014 Zeeshan Mian
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

private class XCUIPageViewController: UIPageViewController {
    var swipeEnabled = true {
        didSet { scrollView?.isScrollEnabled = swipeEnabled }
    }

    // Subclasses have to be responsible when using this setting
    // as view controller count stays at one when we are disabling
    // bounce.
    var disableBounceForSinglePage = false
    private var scrollView: UIScrollView? {
        didSet {
            scrollView?.bounces       = !disableBounceForSinglePage
            scrollView?.isScrollEnabled = swipeEnabled
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if scrollView == nil {
            for v in view.subviews {
                if let sv = v as? UIScrollView {
                    scrollView = sv
                }
            }
        }
    }
}

open class XCPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public enum PageControlPosition { case top, center, bottom }
    open var pageViewController: UIPageViewController!
    open let pageControl = UIPageControl()
    open let pageControlHeight: CGFloat = 40
    open var pageControlPosition = PageControlPosition.bottom
    open var viewControllers: [UIViewController] = []
    open var disableBounceForSinglePage = true
    open var swipeEnabled = true {
        didSet { (pageViewController as? XCUIPageViewController)?.swipeEnabled = swipeEnabled }
    }
    /// Spacing between between pages. Default is `0`.
    /// Page spacing is only valid if the transition style is `UIPageViewControllerTransitionStyle.Scroll`.
    open var pageSpacing: CGFloat = 0
    open var transitionStyle = UIPageViewControllerTransitionStyle.scroll
    open var navigationOrientation = UIPageViewControllerNavigationOrientation.horizontal

    private var didChangeCurrentPage: ((_ index: Int) -> Void)?
    /// Closure for listening page change events in subclasses
    open func didChangeCurrentPage(_ callback: ((_ index: Int) -> Void)? = nil) {
        didChangeCurrentPage = callback
    }

    public convenience init(viewControllers: [UIViewController], pageSpacing: CGFloat = 0) {
        self.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        self.pageSpacing     = pageSpacing
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        setupPageViewController()
    }

    private func setupPageViewController() {
        pageViewController            = XCUIPageViewController(transitionStyle: transitionStyle, navigationOrientation: navigationOrientation, options: [UIPageViewControllerOptionInterPageSpacingKey: pageSpacing])
        pageViewController.delegate   = self
        pageViewController.dataSource = self
        pageViewController.view.frame = view.frame
        if !viewControllers.isEmpty {
            pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: false)
        }
        addContainerViewController(pageViewController, enableConstraints: true)

        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages          = viewControllers.count
        view.addSubview(pageControl)
        setupConstraints()

        if viewControllers.count == 1 && disableBounceForSinglePage {
            (pageViewController as? XCUIPageViewController)?.disableBounceForSinglePage = true
        }

        (pageViewController as? XCUIPageViewController)?.swipeEnabled = swipeEnabled
    }

    private func setupConstraints() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: pageControl, height: pageControlHeight).activate()
        NSLayoutConstraint.constraintsForViewToFillSuperviewHorizontal(pageControl).activate()

        switch pageControlPosition {
            case .top:
                NSLayoutConstraint(item: pageControl, attribute: .top, toItem: view).activate()
            case .center:
                NSLayoutConstraint(item: pageControl, attribute: .centerY, toItem: view).activate()
            case .bottom:
                NSLayoutConstraint(item: pageControl, attribute: .bottom, toItem: view).activate()
        }
    }

    // MARK: UIPageViewControllerDataSource

    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let indexOfCurrentVC = indexOf(viewController)
        return indexOfCurrentVC < viewControllers.count - 1 ? viewControllers[indexOfCurrentVC + 1] : nil
    }

    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let indexOfCurrentVC = indexOf(viewController)
        return indexOfCurrentVC > 0 ? viewControllers[indexOfCurrentVC - 1] : nil
    }

    // MARK: UIPageViewControllerDelegate

    open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let newViewController = pageViewController.viewControllers?.first {
            let index = indexOf(newViewController)
            pageControl.currentPage = index
            updateStatusBar(forIndex: index)
            didChangeCurrentPage?(pageControl.currentPage)
        }
    }

    // MARK: Navigation

    open func setCurrentPage(_ index: Int, direction: UIPageViewControllerNavigationDirection = .forward, animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        guard viewControllers.count > index else { return }
        let viewControllerAtIndex = viewControllers[index]
        pageViewController.setViewControllers([viewControllerAtIndex], direction: direction, animated: animated, completion: completion)
        pageControl.currentPage = index
        updateStatusBar(forIndex: index)
    }

    open func removeViewController(_ viewController: UIViewController) {
        if let index = viewControllers.index(of: viewController) {
            viewControllers.remove(at: index)
            reloadData()
        }
    }

    open func replaceViewController(_ viewControllerToReplace: UIViewController, withViewControllers: [UIViewController]) {
        if let index = viewControllers.index(of: viewControllerToReplace) {
            viewControllers.remove(at: index)
            viewControllers.insert(contentsOf: withViewControllers, at: index)
            reloadData()
        }
    }

    // MARK: Helpers

    private func indexOf(_ viewController: UIViewController) -> Int {
        return viewControllers.index(of: viewController) ?? 0
    }

    open func reloadData() {
        setCurrentPage(pageControl.currentPage)
    }

    private func updateStatusBar(forIndex index: Int) {
        guard let vc = viewControllers.at(index) else { return }
        if let nvc = vc as? UINavigationController {
            statusBarStyle = nvc.preferredStatusBarStyle
        } else {
            statusBarStyle = vc.statusBarStyle ?? vc.preferredStatusBarStyle
        }
    }

    // MARK: Statusbar and Orientation

    open override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden ?? super.prefersStatusBarHidden
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle ?? super.preferredStatusBarStyle
    }

    open override var shouldAutorotate: Bool {
        return isAutorotateEnabled ?? super.shouldAutorotate
    }

    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return statusBarUpdateAnimation ?? super.preferredStatusBarUpdateAnimation
    }
}
