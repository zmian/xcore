//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// Application Chrome
///
/// This class provide the ability to customize Status Bar and Navigation Bar.
///
/// **Why the name Chrome?**
///
/// Chrome is the visual design elements that give users information about or
/// commands to operate on the screen's content (as opposed to being part of that content).
/// These design elements are provided by the underlying system — whether it be an operating system,
/// a website, or an application — and surround the user's data.
///
/// - SeeAlso: https://www.nngroup.com/articles/browser-and-gui-chrome/
public enum Chrome {
    /// Sets a background view for the (status || nav) bar.
    ///
    /// - Parameters:
    ///   - style: The style of (status || nav) bar background.
    ///   - element: The type of element to change the background for.
    ///   - viewController: `UIViewController` the (status || nav) bar should be changed for.
    static func setBackground(style: Style, for element: Element, in viewController: UIViewController) {
        guard viewController.isViewLoaded else {
            return
        }

        if element == .navBar, viewController.prefersNavigationBarHidden {
            return
        }

        let view = style.type.subview(of: viewController.view, for: element)
        style.type.configure(view: view)
    }
}

// MARK: - Element

extension Chrome {
    public enum Element: String {
        case statusBar
        case navBar

        fileprivate func height(for view: UIView) -> CGFloat {
            switch self {
                case .statusBar:
                    return AppConstants.statusBarHeight
                case .navBar:
                    let noStatusBar = view.viewController.map {
                        $0.isModal && $0.modalPresentationStyle == .pageSheet
                    } ?? false
                    return noStatusBar ? 56 : AppConstants.statusBarPlusNavBarHeight
            }
        }

        fileprivate func tag(for view: UIView) -> Int {
            let element = "Chrome.Element.\(rawValue)BackgroundView"
            return -(element.hashValue ^ view.hashValue)
        }
    }
}

// MARK: - BackgroundStyle

extension Chrome {
    public enum BackgroundStyle: Equatable, CustomStringConvertible {
        case transparent
        case blurred
        case color(UIColor)

        public var isTransparent: Bool {
            switch self {
                case .transparent:
                    return true
                case .blurred:
                    return false
                case let .color(color):
                    return color.alpha == 0
            }
        }

        public var description: String {
            switch self {
                case .transparent:
                    return "transparent"
                case .blurred:
                    return "blurred"
                case let .color(color):
                    return "color(\(color.hex))"
            }
        }

        public static func ==(lhs: BackgroundStyle, rhs: BackgroundStyle) -> Bool {
            switch (lhs, rhs) {
                case (.transparent, .transparent):
                    return true
                case (.blurred, .blurred):
                    return true
                case (.color, .color):
                    return true
                default:
                    return false
            }
        }

        fileprivate func subview(of superview: UIView, for element: Element) -> BlurView {
            guard let existingView = superview.viewWithTag(element.tag(for: superview)) as? BlurView else {
                return addAsSubview(to: superview, for: element)
            }

            return existingView
        }

        private func addAsSubview(to superview: UIView, for element: Element) -> BlurView {
            let view = BlurView().apply {
                $0.tag = element.tag(for: superview)
                $0.isUserInteractionEnabled = false
            }.apply(configure)

            superview.addSubview(view)
            view.anchor.make {
                $0.horizontally.equalToSuperview()
                $0.top.equalToSuperview()
                $0.height.equalTo(element.height(for: view))
            }

            return view
        }

        fileprivate func configure(view: BlurView) {
            view.apply {
                $0.isHidden = self == .transparent
                $0.isBlurEffectEnabled = self == .blurred
                if case let .color(color) = self {
                    $0.backgroundColor = color
                }
            }
        }
    }
}

// MARK: - Style

extension Chrome {
    @objc(ChromeStyle)
    public final class Style: NSObject {
        public let type: BackgroundStyle

        @available(*, unavailable)
        override init() {
            fatalError()
        }

        private init(_ type: BackgroundStyle) {
            self.type = type
            super.init()
        }

        public static var transparent: Style {
            .init(.transparent)
        }

        public static var blurred: Style {
            .init(.blurred)
        }

        public static func color(_ color: UIColor) -> Style {
            .init(.color(color))
        }

        public var isTransparent: Bool {
            type.isTransparent
        }

        public override var description: String {
            type.description
        }

        public override func isEqual(_ object: Any?) -> Bool {
            guard let object = object as? Style else {
                return false
            }

            return type == object.type
        }
    }
}
