//
// Chrome.swift
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
/// - seealso: https://www.nngroup.com/articles/browser-and-gui-chrome/
final public class Chrome {
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

// MARK: Element

extension Chrome {
    public enum Element: String {
        case statusBar
        case navBar

        fileprivate var height: CGFloat {
            switch self {
                case .statusBar:
                    return AppConstants.statusBarHeight
                case .navBar:
                    return AppConstants.statusBarPlusNavBarHeight
            }
        }

        fileprivate func tag(for view: UIView) -> Int {
            let element = "Chrome.Element.\(rawValue)BackgroundView"
            return -(element.hashValue ^ view.hashValue)
        }
    }
}

// MARK: BackgroundStyle

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
                case .color(let color):
                    return color.alpha == 0
            }
        }

        public var description: String {
            switch self {
                case .transparent:
                    return "transparent"
                case .blurred:
                    return "blurred"
                case .color(let color):
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
                $0.height.equalTo(element.height)
            }

            return view
        }

        fileprivate func configure(view: BlurView) {
            view.apply {
                $0.isHidden = self == .transparent
                $0.isSmartBlurEffectEnabled = self == .blurred
                if case .color(let color) = self {
                    $0.backgroundColor = color
                }
            }
        }
    }
}

// MARK: Style

extension Chrome {
    @objc(ChromeStyle)
    final public class Style: NSObject {
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
            return Style(.transparent)
        }

        public static var blurred: Style {
            return Style(.blurred)
        }

        public static func color(_ color: UIColor) -> Style {
            return Style(.color(color))
        }

        public var isTransparent: Bool {
            return type.isTransparent
        }

        public override var description: String {
            return type.description
        }

        public override func isEqual(_ object: Any?) -> Bool {
            guard let object = object as? Style else {
                return false
            }

            return type == object.type
        }
    }
}
