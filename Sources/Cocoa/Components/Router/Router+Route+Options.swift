//
// Router+Route+Options.swift
//
// Copyright © 2019 Xcore
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

extension Router.Route {
    public struct Options {
        public enum Transition {
            /// Use modal on iPad and push on iPhone.
            case automatic
            case push
            case modal
        }

        public let transition: Transition
        public let isAnimated: Bool

        public init(transition: Transition, animated: Bool = true) {
            self.transition = transition
            self.isAnimated = animated
        }
    }
}

// MARK: - Options: Convenience

extension Router.Route.Options {
    // Automatic

    public static var automatic: Router.Route<Type>.Options {
        return .automatic(animated: true)
    }

    public static func automatic(animated: Bool) -> Router.Route<Type>.Options {
        return .init(transition: .automatic, animated: animated)
    }

    // Push

    public static var push: Router.Route<Type>.Options {
        return .push(animated: true)
    }

    public static func push(animated: Bool) -> Router.Route<Type>.Options {
        return .init(transition: .push, animated: animated)
    }

    // Modal

    public static var modal: Router.Route<Type>.Options {
        return .modal(animated: true)
    }

    public static func modal(animated: Bool) -> Router.Route<Type>.Options {
        return .init(transition: .modal, animated: animated)
    }
}

// MARK: - Display

extension Router.Route.Options {
    private var isModal: Bool {
        switch transition {
            case .push:
                return false
            case .modal:
                return true
            case .automatic:
                return UIDevice.current.userInterfaceIdiom == .pad
        }
    }

    /// Show the view controller on the given navigation controller.
    func display(_ vc: UIViewController, navigationController: UINavigationController) {
        guard isModal else {
            navigationController.pushViewController(vc, animated: isAnimated)
            return
        }

        // Wrap the view controller in navigation controller so the router instance when
        // presented modally can be used. Router requires navigation controller.
        let nvc = (vc as? UINavigationController) ?? NavigationController(rootViewController: vc)
        navigationController.present(nvc, animated: isAnimated)
    }

    /// Show the list of view controller on the given navigation controller.
    func display(_ vcs: [UIViewController], navigationController: UINavigationController) {
        guard isModal else {
            navigationController.pushViewController(vcs, animated: isAnimated)
            return
        }

        // Wrap the view controller in navigation controller so the router instance when
        // presented modally can be used. Router requires navigation controller.
        let nvc = NavigationController()
        nvc.setViewControllers(vcs, animated: isAnimated)
        navigationController.present(nvc, animated: isAnimated)
    }
}
