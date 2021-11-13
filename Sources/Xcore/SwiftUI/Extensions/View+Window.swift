//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Presents a window when a binding to a Boolean value that you provide is true.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the window.
    ///   - style: A structure representing the style of a window.
    ///   - content: A closure that returns the content of the window.
    public func window<Content: View>(
        isPresented: Binding<Bool>,
        style: WindowStyle = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        background(Window(
            isPresented: isPresented,
            style: style,
            content: LazyView(content())
        ))
    }

    /// Presents a window using the given item as a data source for the window's
    /// content.
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the window. When
    ///    `item` is non-`nil`, the system passes the item's content to the
    ///     modifier's closure. You display this content in a window that you create
    ///     that the system displays to the user. If `item` changes, the system
    ///     replaces it with a new one.
    ///   - style: A structure representing the style of a window.
    ///   - content: A closure that returns the content of the window.
    public func window<Item, Content: View>(
        item: Binding<Item?>,
        style: WindowStyle = .init(),
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        window(
            isPresented: .init {
                item.wrappedValue != nil
            } set: { isPresented in
                if !isPresented {
                    item.wrappedValue = nil
                }
            },
            style: style,
            content: {
                if let item = item.wrappedValue {
                    content(item)
                }
            }
        )
    }
}

// MARK: - Style

/// A structure representing the style of a window.
public struct WindowStyle {
    /// A succinct label that identifies the window.
    public let label: String?

    /// The position of the window in the z-axis.
    ///
    /// Window levels provide a relative grouping of windows along the z-axis. All
    /// windows assigned to the same window level appear in front of (or behind) all
    /// windows assigned to a different window level. The ordering of windows within
    /// a given window level is not guaranteed.
    ///
    /// The default value is `.top`.
    public let level: UIWindow.Level

    /// A boolean value that indicates whether to make the receiver the key window.
    ///
    /// The key window receives keyboard and other non-touch related events. Setting
    /// this property to `true` causes the previous key window to resign the key
    /// status.
    ///
    /// The default value is `true`.
    public let isKey: Bool

    /// Creates a window style.
    ///
    /// - Parameters:
    ///   - label: A succinct label that identifies the window.
    ///   - level: The position of the window in the z-axis.
    ///   - isKey: A boolean value that indicates whether to make the receiver the
    ///     key window.
    public init(
        label: String? = nil,
        level: UIWindow.Level = .topMost,
        isKey: Bool = true
    ) {
        self.label = label
        self.level = level
        self.isKey = isKey
    }
}

// MARK: - Representable

private struct Window<Content: View>: UIViewControllerRepresentable {
    let isPresented: Binding<Bool>
    let style: WindowStyle
    let content: Content

    init(isPresented: Binding<Bool>, style: WindowStyle, content: Content) {
        self.isPresented = isPresented
        self.style = style
        self.content = content
    }

    func makeUIViewController(context: Context) -> ViewController {
        .init(
            isPresented: isPresented,
            style: style,
            rootView: .init(content: content, context: context)
        )
    }

    func updateUIViewController(_ viewController: ViewController, context: Context) {
        viewController.isPresented = isPresented
        viewController.style = style
        viewController.rootView.context = context
        viewController.update()

        // Fixes an issue where animations are broken.
        DispatchQueue.main.async {
            viewController.rootView.content = content
        }
    }
}

// MARK: - ViewController

extension Window {
    final class ViewController: UIViewController {
        private var hostingWindow: UIHostingWindow<RootView>?
        fileprivate typealias RootView = Window.RootView<Content>
        var isPresented: Binding<Bool>
        var style: WindowStyle
        var rootView: RootView {
            didSet {
                hostingWindow?.rootView = rootView
            }
        }

        init(isPresented: Binding<Bool>, style: WindowStyle, rootView: RootView) {
            self.isPresented = isPresented
            self.style = style
            self.rootView = rootView
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }

        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            update()
        }

        func update() {
            if isPresented.wrappedValue {
                if hostingWindow == nil {
                    hostingWindow = UIHostingWindow(rootView: rootView)
                    hostingWindow?.windowLevel = style.level
                    hostingWindow?.windowLabel = style.label
                }

                hostingWindow?.show(isKey: style.isKey)
            } else {
                hostingWindow?.hide()
                hostingWindow = nil
            }
        }
    }
}

// MARK: - RootView

extension Window {
    fileprivate struct RootView<Content: View>: View {
        var content: Content
        var context: Window.Context

        var body: some View {
            content
                // TODO: Is there better way to propagate all of the environment values to the window content view?
                .environment(\.font, env.font)
                .foregroundColor(env.theme.textColor)
                .environment(\.isLoading, env.isLoading)
                .environment(\.isEnabled, env.isEnabled)
                .environment(\.defaultMinListRowHeight, env.defaultMinListRowHeight)
                .environment(\.defaultMinListHeaderHeight, env.defaultMinListHeaderHeight)
                .environment(\.defaultMinButtonHeight, env.defaultMinButtonHeight)
                .environment(\.defaultOutlineButtonBorderColor, env.defaultOutlineButtonBorderColor)
                .environment(\.textFieldAttributes, env.textFieldAttributes)
                .environment(\.dynamicTextFieldStyle, env.dynamicTextFieldStyle)
                .environment(\.storyProgressIndicatorColor, env.storyProgressIndicatorColor)
                .environment(\.storyProgressIndicatorInsets, env.storyProgressIndicatorInsets)
                .environment(\.popupCornerRadius, env.popupCornerRadius)
                .environment(\.popupPreferredWidth, env.popupPreferredWidth)
                .environment(\.popupTextAlignment, env.popupTextAlignment)
                .environment(\.xstackStyle, env.xstackStyle)
                .environment(\.theme, env.theme)
                ._xtint(Color(env.theme.tintColor))
        }

        private var env: EnvironmentValues {
            context.environment
        }
    }
}
