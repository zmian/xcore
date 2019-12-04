//
// Interstitial+HUD.swift
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

extension Interstitial {
    /// The position of the Interstitial window in the z-axis.
    public static var windowLevel: UIWindow.Level = .normal + 0.1
}

extension Interstitial {
    final class HUD: Xcore.HUD {
        private var isPresenting = false
        private var _navigationController: PageNavigationController?
        var navigationController: PageNavigationController {
            // `UINavigationController` has a known bug which prevents setting new view
            // controllers after setting it to an empty array.
            //
            // For example:
            //
            // ```swift
            // navigationController.setViewControllers([], animated: false)
            // // This won't allow setting any new view controller.
            // navigationController.setViewControllers([UIViewController()], animated: false)
            // ```
            //
            // https://openradar.appspot.com/48067497
            guard let navigationController = _navigationController else {
                _navigationController = PageNavigationController().apply {
                    $0.willShow { [weak self] vc in
                        self?.willShow?(vc)
                    }
                }
                add(_navigationController!)
                return _navigationController!
            }
            return navigationController
        }

        var currentViewController: InterstitialCompatibleViewController? {
            _navigationController?.rootViewController as? InterstitialCompatibleViewController
        }

        override init() {
            super.init()
            windowLabel = "Interstitial Window"
            adjustWindowAttributes {
                $0.windowLevel = Interstitial.windowLevel
            }
        }

        private var willShow: ((_ viewController: UIViewController) -> Void)?
        func willShow(_ callback: @escaping (_ viewController: UIViewController) -> Void) {
            willShow = callback
        }

        func showIfNeeded(_ completion: (() -> Void)? = nil) {
            guard
                !isPresenting,
                !isEnabled
            else {
                return
            }

            show(completion)
        }

        // MARK: - Presentation

        override func show(delay delayDuration: TimeInterval = 0, animated: Bool = true, _ completion: (() -> Void)? = nil) {
            isPresenting = true
            super.show(delay: delayDuration, animated: animated) { [weak self] in
                self?.isPresenting = false
                completion?()
            }
        }

        override func hide(delay delayDuration: TimeInterval = 0, animated: Bool = true, _ completion: (() -> Void)? = nil) {
            isPresenting = false
            super.hide(delay: delayDuration, animated: animated) { [weak self] in
                self?._navigationController?.removeFromContainerViewController()
                self?._navigationController = nil
                completion?()
            }
        }
    }
}
