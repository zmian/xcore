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
    var isScrollEnabled = true {
        didSet {
            scrollView?.isScrollEnabled = isScrollEnabled
        }
    }

    // Subclasses have to be responsible when using this setting
    // as view controller count stays at one when the bounce is disabled.
    var isBounceForSinglePageEnabled = true

    private var scrollView: UIScrollView? {
        didSet {
            scrollView?.bounces = isBounceForSinglePageEnabled
            scrollView?.isScrollEnabled = isScrollEnabled
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard scrollView == nil else { return }

        for view in view.subviews {
            if let aScrollView = view as? UIScrollView {
                scrollView = aScrollView
            }
        }
    }
}

open class XCPageViewController: UIViewController {
    public enum PageControlPosition {
        case top
        case center
        case bottom
    }

    open var pageViewController: UIPageViewController!
    public let pageControl = UIPageControl()
    public let pageControlHeight: CGFloat = 40
    open var pageControlPosition: PageControlPosition = .bottom
    open var viewControllers: [UIViewController] = []
    /// The default value is `false`.
    open var isBounceForSinglePageEnabled = false
    open var isScrollEnabled = true {
        didSet { (pageViewController as? XCUIPageViewController)?.isScrollEnabled = isScrollEnabled }
    }
    /// Spacing between between pages. The default value is `0`.
    /// Page spacing is only valid if the transition style is `.scroll`.
    open var pageSpacing: CGFloat = 0
    open var transitionStyle: UIPageViewController.TransitionStyle = .scroll
    open var navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal

    private var didChangeCurrentPage: ((_ index: Int) -> Void)?
    /// A callback for listening to page change events.
    open func didChangeCurrentPage(_ callback: ((_ index: Int) -> Void)? = nil) {
        didChangeCurrentPage = callback
    }

    public convenience init(viewControllers: [UIViewController], pageSpacing: CGFloat = 0) {
        self.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        self.pageSpacing = pageSpacing
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        setupPageViewController()
    }

    private func setupPageViewController() {
        pageViewController = XCUIPageViewController(transitionStyle: transitionStyle, navigationOrientation: navigationOrientation, options: [.interPageSpacing: pageSpacing])
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.view.frame = view.frame
        if !viewControllers.isEmpty {
            pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: false)
        }
        addViewController(pageViewController, enableConstraints: true)

        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = viewControllers.count
        view.addSubview(pageControl)
        setupConstraints()

        if viewControllers.count == 1 {
            (pageViewController as? XCUIPageViewController)?.isBounceForSinglePageEnabled = isBounceForSinglePageEnabled
        }

        (pageViewController as? XCUIPageViewController)?.isScrollEnabled = isScrollEnabled
    }

    private func setupConstraints() {
        pageControl.anchor.make {
            $0.height.equalTo(pageControlHeight)
            $0.horizontally.equalToSuperview()

            switch pageControlPosition {
                case .top:
                    $0.top.equalTo(view)
                case .center:
                    $0.centerY.equalTo(view)
                case .bottom:
                    $0.bottom.equalTo(view)
            }
        }
    }
}

// MARK: UIPageViewControllerDataSource & UIPageViewControllerDelegate

extension XCPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let indexOfCurrentVC = indexOf(viewController)
        return indexOfCurrentVC < viewControllers.count - 1 ? viewControllers[indexOfCurrentVC + 1] : nil
    }

    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let indexOfCurrentVC = indexOf(viewController)
        return indexOfCurrentVC > 0 ? viewControllers[indexOfCurrentVC - 1] : nil
    }

    open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let newViewController = pageViewController.viewControllers?.first else { return }
        let index = indexOf(newViewController)
        pageControl.currentPage = index
        updateStatusBar(for: index)
        didChangeCurrentPage?(pageControl.currentPage)
    }
}

// MARK: Navigation API

extension XCPageViewController {
    /// Set current view controller index to be displayed.
    ///
    /// - Parameters:
    ///   - index: The index of the view controller to be displayed.
    ///   - direction: The navigation direction. The default value is `.forward`.
    ///   - animated: A boolean value that indicates whether the transition is to be animated. The default value is `false`.
    ///   - completion: A block to be called when setting the current view controller animation completes. The default value is `nil`.
    open func setCurrentPage(_ index: Int, direction: UIPageViewController.NavigationDirection = .forward, animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        guard viewControllers.count > index else { return }
        let viewControllerAtIndex = viewControllers[index]
        pageViewController.setViewControllers([viewControllerAtIndex], direction: direction, animated: animated, completion: completion)
        pageControl.currentPage = index
        updateStatusBar(for: index)
    }

    open func removeViewController(_ viewController: UIViewController) {
        guard let index = viewControllers.firstIndex(of: viewController) else { return }
        viewControllers.remove(at: index)
        reloadData()
    }

    open func replaceViewController(_ viewControllerToReplace: UIViewController, withViewControllers: [UIViewController]) {
        guard let index = viewControllers.firstIndex(of: viewControllerToReplace) else { return }
        viewControllers.remove(at: index)
        viewControllers.insert(contentsOf: withViewControllers, at: index)
        reloadData()
    }

    open func reloadData() {
        setCurrentPage(pageControl.currentPage)
    }
}

// MARK: Helpers

extension XCPageViewController {
    private func indexOf(_ viewController: UIViewController) -> Int {
        return viewControllers.firstIndex(of: viewController) ?? 0
    }

    private func updateStatusBar(for index: Int) {
        guard let vc = viewControllers.at(index) else { return }

        if let nvc = vc as? UINavigationController {
            statusBarStyle = nvc.preferredStatusBarStyle
        } else {
            statusBarStyle = vc.statusBarStyle ?? vc.preferredStatusBarStyle
        }
    }
}

// MARK: Statusbar and Orientation

extension XCPageViewController {
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
