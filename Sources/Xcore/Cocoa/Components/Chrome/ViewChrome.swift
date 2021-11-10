//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - View Helpers

extension View {
    /// Configures the status bar background.
    ///
    /// - Parameter background: The background style for the status bar.
    public func statusBarBackground(_ background: ViewChrome.Background) -> some View {
        chrome(.init(bar: .statusBar, background: background))
    }

    /// Configures the status bar background color.
    ///
    /// - Parameter color: The background color for the status bar.
    public func statusBarBackground(_ color: Color) -> some View {
        statusBarBackground(.colored(color))
    }

    /// Configures the status bar background view.
    ///
    /// - Parameter view: The background view for the status bar.
    @_disfavoredOverload
    public func statusBarBackground<V: View>(_ view: V) -> some View {
        statusBarBackground(.view(view))
    }

    /// Configures the navigation bar background.
    ///
    /// - Parameter background: The background style for the navigation bar.
    public func navigationBarBackground(_ background: ViewChrome.Background) -> some View {
        chrome(.init(bar: .navigationBar, background: background))
    }

    /// Configures the navigation bar background color.
    ///
    /// - Parameter color: The background color for the navigation bar.
    public func navigationBarBackground(_ color: Color) -> some View {
        navigationBarBackground(.colored(color))
    }

    /// Configures the navigation bar background view.
    ///
    /// - Parameter view: The background view for the navigation bar.
    @_disfavoredOverload
    public func navigationBarBackground<V: View>(_ view: V) -> some View {
        navigationBarBackground(.view(view))
    }

    /// Configures the view's chrome.
    ///
    /// - Parameter chrome: The chrome of the view.
    private func chrome(_ chrome: ViewChrome) -> some View {
        modifier(ViewChromeModifier(chrome: chrome))
    }
}

// MARK: - ViewChrome

/// A structure to customize Status Bar and Navigation Bar.
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
public struct ViewChrome: Hashable {
    public let bar: Bar
    public let background: Background

    public init(bar: Bar, background: Background) {
        self.bar = bar
        self.background = background
    }
}

// MARK: - Types

extension ViewChrome {
    /// An enumeration representing the elements of the chrome to customize.
    public enum Bar: Hashable {
        case statusBar
        case navigationBar
    }

    /// An enumeration representing the background style of the element.
    public enum Background: Hashable, CustomStringConvertible {
        case transparent
        case blurred(UIBlurEffect.Style)
        case colored(Color)
        case view(AnyView)

        public static var blurred: Self {
            .blurred(.prominent)
        }

        public static func view<V: View>(_ view: V) -> Self {
            Self.view(view.eraseToAnyView())
        }

        public var description: String {
            switch self {
                case .transparent:
                    return "transparent"
                case .blurred:
                    return "blurred"
                case let .colored(color):
                    return "colored(\(UIColor(color).hex))"
                case .view:
                    return "view"
            }
        }

        public static func ==(lhs: Self, rhs: Self) -> Bool {
            String(reflecting: lhs) == String(reflecting: rhs)
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(String(reflecting: self))
        }
    }
}

// MARK: - ViewChromeModifier

private struct ViewChromeModifier: ViewModifier {
    let chrome: ViewChrome

    func body(content: Content) -> some View {
        ZStack {
            content

            GeometryReader { geometry in
                switch chrome.background {
                    case .transparent:
                        EmptyView()
                    case let .blurred(style):
                        bar(BlurEffectView(style: style), in: geometry)
                    case let .colored(color):
                        bar(color, in: geometry)
                    case let .view(view):
                        bar(view, in: geometry)
                }
            }
        }
    }

    private func bar<V: View>(_ view: V, in geometry: GeometryProxy) -> some View {
        view
            .frame(height: height(geometry))
            .ignoresSafeArea()
    }

    private func height(_ geometry: GeometryProxy) -> CGFloat {
        switch chrome.bar {
            case .statusBar:
                if geometry.safeAreaInsets.top == 0 {
                    // Status bar is hidden, we don't want to set any background.
                    return 0
                }

                return AppConstants.statusBarHeight
            case .navigationBar:
                return geometry.safeAreaInsets.top
        }
    }
}
