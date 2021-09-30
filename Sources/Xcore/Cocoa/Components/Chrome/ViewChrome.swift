//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - View Helpers

extension View {
    public func statusBarBackground(_ background: ViewChrome.Background) -> some View {
        chrome(.init(bar: .statusBar, background: background))
    }

    public func statusBarBackground(_ background: Color) -> some View {
        statusBarBackground(.colored(background))
    }

    public func navigationBarBackground(_ background: ViewChrome.Background) -> some View {
        chrome(.init(bar: .navigationBar, background: background))
    }

    public func navigationBarBackground(_ background: Color) -> some View {
        navigationBarBackground(.colored(background))
    }

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
        case blurred
        case colored(Color)

        public var description: String {
            switch self {
                case .transparent:
                    return "transparent"
                case .blurred:
                    return "blurred"
                case let .colored(color):
                    return "colored(\(UIColor(color).hex))"
            }
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
                    case .blurred:
                        BlurEffectView()
                            .frame(height: height(geometry))
                            .ignoresSafeArea()
                    case let .colored(color):
                        color
                            .frame(height: height(geometry))
                            .ignoresSafeArea()
                }
            }
        }
    }

    private func height(_ geometry: GeometryProxy) -> CGFloat {
        switch chrome.bar {
            case .statusBar:
                if geometry.safeAreaInsets.top == 0 {
                    // Status bar is hidden, we don't want to set any background.
                    return 0
                }

                return AppConstants.searchBarHeight
            case .navigationBar:
                return geometry.safeAreaInsets.top
        }
    }
}
