//
// XCPageViewController.swift
//
// Copyright © 2014 Xcore
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

// MARK: - PageControlPosition

extension XCPageViewController {
    public enum PageControlPosition {
        case none
        case top
        case center
        case bottom
    }
}

// MARK: - XCPageViewController

open class XCPageViewController: UIViewController {
    public let pageControlHeight: CGFloat = 40
    open var pageControlPosition: PageControlPosition = .bottom
    public let pageControl = UIPageControl().apply {
        $0.isUserInteractionEnabled = false
    }
    private var _pageViewController: XCUIPageViewController? {
        return pageViewController as? XCUIPageViewController
    }
    open private(set) var pageViewController: UIPageViewController!
    open var viewControllers: [UIViewController] = [] {
        didSet {
            guard isViewLoaded else { return }
            updateIfNeeded(shouldSetInitialViewController: oldValue.isEmpty)
        }
    }

    /// The default value is `false`.
    open var isBounceForSinglePageEnabled = false
    open var isScrollEnabled = true {
        didSet { _pageViewController?.isScrollEnabled = isScrollEnabled }
    }

    /// Spacing between between pages. The default value is `0`.
    ///
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
        setupPageViewController()
    }

    private func setupPageViewController() {
        pageViewController = XCUIPageViewController(
            transitionStyle: transitionStyle,
            navigationOrientation: navigationOrientation,
            options: [.interPageSpacing: pageSpacing]
        ).apply {
            $0.delegate = self
            $0.dataSource = self
        }

        addViewController(pageViewController, enableConstraints: true)
        _pageViewController?.isScrollEnabled = isScrollEnabled
        view.addSubview(pageControl)
        setupConstraints()
        updateIfNeeded(shouldSetInitialViewController: true)
    }

    private func updateIfNeeded(shouldSetInitialViewController: Bool) {
        pageControl.numberOfPages = viewControllers.count
        pageControl.isHidden = viewControllers.count < 2

        if viewControllers.count == 1 {
            _pageViewController?.isBounceForSinglePageEnabled = isBounceForSinglePageEnabled
        }

        if shouldSetInitialViewController {
            setCurrentPage(0)
        }
    }

    private func setupConstraints() {
        pageControl.anchor.make {
            $0.height.equalTo(pageControlHeight)

            guard pageControlPosition != .none else { return }

            $0.horizontally.equalToSuperview()

            switch pageControlPosition {
                case .none:
                    break
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

// MARK: - UIPageViewControllerDataSource & UIPageViewControllerDelegate

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

// MARK: - Navigation API

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

// MARK: - Helpers

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

// MARK: - Statusbar and Orientation

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

// MARK: - XCUIPageViewController

#warning("Remove this class and add support to UIPageViewController directly. Using Xcore.subview like scrollView in UISearchBar.")
private final class XCUIPageViewController: UIPageViewController {
    // Subclasses have to be responsible when using this setting
    // as view controller count stays at one when the bounce is disabled.
    var isBounceForSinglePageEnabled = true

    var isScrollEnabled = true {
        didSet {
            scrollView?.isScrollEnabled = isScrollEnabled
        }
    }

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
