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
    // Subclasses have to be responsible when using this setting
    // as view controller count stays at one when we are disabling
    // bounce.
    var disableBounceForSinglePage = false
    private var scrollView: UIScrollView? {
        didSet {
            scrollView?.bounces = !disableBounceForSinglePage
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

public class XCPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public enum PageControlPosition { case Top, Center, Bottom }
    public var pageViewController: UIPageViewController!
    public let pageControl = UIPageControl()
    public let pageControlHeight: CGFloat = 40
    public var pageControlPosition = PageControlPosition.Bottom
    public var viewControllers: [UIViewController] = []
    public var disableBounceForSinglePage = true
    /// Spacing between between pages. Default is `0`.
    /// Page spacing is only valid if the transition style is `UIPageViewControllerTransitionStyle.Scroll`.
    public var pageSpacing: CGFloat = 0
    public var transitionStyle = UIPageViewControllerTransitionStyle.Scroll
    public var navigationOrientation = UIPageViewControllerNavigationOrientation.Horizontal

    private var didChangeCurrentPage: ((index: Int) -> Void)?
    /// Closure for listening page change events in subclasses
    public func didChangeCurrentPage(callback: ((index: Int) -> Void)? = nil) {
        didChangeCurrentPage = callback
    }

    public convenience init(viewControllers: [UIViewController], pageSpacing: CGFloat = 0) {
        self.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        self.pageSpacing     = pageSpacing
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        setupPageViewController()
    }

    private func setupPageViewController() {
        pageViewController            = XCUIPageViewController(transitionStyle: transitionStyle, navigationOrientation: navigationOrientation, options: [UIPageViewControllerOptionInterPageSpacingKey: pageSpacing])
        pageViewController.delegate   = self
        pageViewController.dataSource = self
        pageViewController.view.frame = view.frame
        if !viewControllers.isEmpty {
            pageViewController.setViewControllers([viewControllers[0]], direction: .Forward, animated: false, completion: nil)
        }
        addContainerViewController(pageViewController, enableConstraints: true)

        pageControl.userInteractionEnabled = false
        pageControl.numberOfPages          = viewControllers.count
        view.addSubview(pageControl)
        setupConstraints()

        if viewControllers.count == 1 && disableBounceForSinglePage {
            (pageViewController as? XCUIPageViewController)?.disableBounceForSinglePage = true
        }
    }

    private func setupConstraints() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.addConstraint(NSLayoutConstraint(item: pageControl, height: pageControlHeight))
        view.addConstraints(NSLayoutConstraint.constraintsForViewToFillSuperviewHorizontal(pageControl))

        switch pageControlPosition {
            case .Top:
                view.addConstraint(NSLayoutConstraint(item: pageControl, attribute: .Top, toItem: view))
            case .Center:
                view.addConstraint(NSLayoutConstraint(item: pageControl, attribute: .CenterY, toItem: view))
            case .Bottom:
                view.addConstraint(NSLayoutConstraint(item: pageControl, attribute: .Bottom, toItem: view))
        }
    }

    // MARK: UIPageViewControllerDataSource

    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let indexOfCurrentVC = indexOf(viewController)
        return indexOfCurrentVC < viewControllers.count - 1 ? viewControllers[indexOfCurrentVC + 1] : nil
    }

    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?  {
        viewControllers.endIndex
        let indexOfCurrentVC = indexOf(viewController)
        return indexOfCurrentVC > 0 ? viewControllers[indexOfCurrentVC - 1] : nil
    }

    // MARK: UIPageViewControllerDelegate

    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let newViewController = pageViewController.viewControllers?.first {
            pageControl.currentPage = indexOf(newViewController)
            didChangeCurrentPage?(index: pageControl.currentPage)
        }
    }

    // MARK: Navigation

    public func setCurrentPage(index: Int, direction: UIPageViewControllerNavigationDirection = .Forward, animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        guard viewControllers.count > index else { return }
        let viewControllerAtIndex = viewControllers[index]
        pageViewController.setViewControllers([viewControllerAtIndex], direction: direction, animated: animated, completion: completion)
        pageControl.currentPage = index
    }

    public func removeViewController(viewController: UIViewController) {
        if let index = viewControllers.indexOf(viewController) {
            viewControllers.removeAtIndex(index)
            reloadData()
        }
    }

    public func replaceViewController(viewControllerToReplace: UIViewController, withViewControllers: [UIViewController]) {
        if let index = viewControllers.indexOf(viewControllerToReplace) {
            viewControllers.removeAtIndex(index)
            viewControllers.insertContentsOf(withViewControllers, at: index)
            reloadData()
        }
    }

    // MARK: Helpers

    private func indexOf(viewController: UIViewController) -> Int {
        return viewControllers.indexOf(viewController) ?? 0
    }

    private func reloadData() {
        pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
    }
}
