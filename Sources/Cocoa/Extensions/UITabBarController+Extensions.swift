//
// UITabBarController+Extensions.swift
//
// Copyright © 2017 Xcore
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

extension UITabBarController {
    // Autorotation Fix. Simply override `supportedInterfaceOrientations`
    // method in any view controller and it would respect that orientation
    // setting per view controller.
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return selectedViewController?.preferredInterfaceOrientations ?? preferredInterfaceOrientations ?? selectedViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return selectedViewController?.interfaceOrientationForPresentation ?? interfaceOrientationForPresentation ?? selectedViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }

    open override var shouldAutorotate: Bool {
        return selectedViewController?.isAutorotateEnabled ?? isAutorotateEnabled ?? selectedViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
}

extension UITabBarController {
    open func setTabBarHidden(_ hide: Bool, animated: Bool) {
        let frame = tabBar.frame
        let offsetY = hide ? frame.size.height : -frame.size.height
        var newFrame = frame
        newFrame.origin.y = view.frame.maxY + offsetY
        tabBar.isHidden = false

        UIView.animate(withDuration: animated ? 0.35 : 0.0, delay: 0, options: .beginFromCurrentState, animations: {
            self.tabBar.frame = newFrame
        }, completion: { complete in
            if complete {
                self.tabBar.isHidden = hide
            }
        })
    }
}

extension UITabBarController {
    func isRootViewController(_ viewController: UIViewController) -> Bool {
        guard let viewControllers = viewControllers else {
            return false
        }

        if let navigationController = viewController.navigationController {
            return viewControllers.contains(navigationController)
        }

        return viewControllers.contains(viewController)
    }
}
