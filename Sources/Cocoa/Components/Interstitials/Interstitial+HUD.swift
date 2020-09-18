//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIWindow.Level {
    public static var interstitial: Self = .normal + 0.1
}

extension Interstitial {
    final class HUD: Xcore.HUD {
        private(set) var isPresenting = false
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
                $0.makeKey()
                $0.windowLevel = .interstitial
            }
        }

        private var willShow: ((_ viewController: UIViewController) -> Void)?
        func willShow(_ callback: @escaping (_ viewController: UIViewController) -> Void) {
            willShow = callback
        }

        func showIfNeeded(_ completion: (() -> Void)? = nil) {
            guard isHidden, !isPresenting else {
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
                self?._navigationController?.removeFromContainerView()
                self?._navigationController = nil
                completion?()
            }
        }
    }
}
