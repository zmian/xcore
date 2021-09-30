//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A enumeration to customize Status Bar and Navigation Bar.
///
/// **Why the name Chrome?**
///
/// Chrome is the visual design elements that give users information about or
/// commands to operate on the screen's content (as opposed to being part of
/// that content). These design elements are provided by the underlying system
/// — whether it be an operating system, a website, or an application — and
/// surround the user's data.
///
/// - SeeAlso: https://www.nngroup.com/articles/browser-and-gui-chrome/
public enum ViewControllerChrome {
    /// Sets a background view for the (status || nav) bar.
    ///
    /// - Parameters:
    ///   - style: The style of (status || nav) bar background.
    ///   - bar: The type of bar to change the background for.
    ///   - viewController: `UIViewController` the (status || nav) bar should be changed for.
    static func setBackground(_ style: Style, for bar: Bar, in viewController: UIViewController) {
        guard viewController.isViewLoaded else {
            return
        }

        if bar == .navigationBar, viewController.prefersNavigationBarHidden {
            return
        }

        let view = style.background.subview(of: viewController.view, for: bar)
        style.background.configure(view: view)
    }
}

// MARK: - Bar

extension ViewControllerChrome {
    /// An enumeration representing the elements of the chrome to customize.
    public enum Bar: String, Hashable {
        case statusBar
        case navigationBar

        fileprivate func height(for view: UIView) -> CGFloat {
            switch self {
                case .statusBar:
                    return AppConstants.statusBarHeight
                case .navigationBar:
                    let noStatusBar = view.viewController.map {
                        $0.isModal && $0.modalPresentationStyle == .pageSheet
                    } ?? false
                    return noStatusBar ? 56 : AppConstants.statusBarPlusNavBarHeight
            }
        }

        fileprivate func tag(for view: UIView) -> Int {
            let bar = "Chrome.Bar.\(rawValue)BackgroundView"
            return -(bar.hashValue ^ view.hashValue)
        }
    }
}

// MARK: - Background

extension ViewControllerChrome {
    /// An enumeration representing the background style of the element.
    public enum Background: Equatable, CustomStringConvertible {
        case transparent
        case blurred
        case colored(UIColor)

        public var isTransparent: Bool {
            switch self {
                case .transparent:
                    return true
                case .blurred:
                    return false
                case let .colored(color):
                    return color.alpha == 0
            }
        }

        public var description: String {
            switch self {
                case .transparent:
                    return "transparent"
                case .blurred:
                    return "blurred"
                case let .colored(color):
                    return "colored(\(color.hex))"
            }
        }

        public static func ==(lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
                case (.transparent, .transparent):
                    return true
                case (.blurred, .blurred):
                    return true
                case (.colored, .colored):
                    return true
                default:
                    return false
            }
        }

        fileprivate func subview(of superview: UIView, for bar: Bar) -> BlurView {
            guard let existingView = superview.viewWithTag(bar.tag(for: superview)) as? BlurView else {
                return addAsSubview(to: superview, for: bar)
            }

            return existingView
        }

        private func addAsSubview(to superview: UIView, for bar: Bar) -> BlurView {
            let view = BlurView().apply {
                $0.tag = bar.tag(for: superview)
                $0.isUserInteractionEnabled = false
            }.apply(configure)

            superview.addSubview(view)
            view.anchor.make {
                $0.horizontally.equalToSuperview()
                $0.top.equalToSuperview()
                $0.height.equalTo(bar.height(for: view))
            }

            return view
        }

        fileprivate func configure(view: BlurView) {
            view.apply {
                $0.isHidden = self == .transparent
                $0.isBlurEffectEnabled = self == .blurred
                if case let .colored(color) = self {
                    $0.backgroundColor = color
                }
            }
        }
    }
}

// MARK: - Style

extension ViewControllerChrome {
    @objc(ChromeStyle)
    public final class Style: NSObject {
        public let background: Background

        @available(*, unavailable)
        override init() {
            fatalError()
        }

        private init(_ background: Background) {
            self.background = background
            super.init()
        }

        public static var transparent: Style {
            .init(.transparent)
        }

        public static var blurred: Style {
            .init(.blurred)
        }

        public static func colored(_ color: UIColor) -> Style {
            .init(.colored(color))
        }

        public var isTransparent: Bool {
            background.isTransparent
        }

        public override var description: String {
            background.description
        }

        public override func isEqual(_ object: Any?) -> Bool {
            guard let object = object as? Style else {
                return false
            }

            return background == object.background
        }
    }
}
