//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - View Extension

extension View {
    public func popup<Content: View>(
        isPresented: Binding<Bool>,
        style: Popup.Style = .alert,
        dismissMethods: Popup.DismissMethods = [.tapOutside],
        @ViewBuilder content: @escaping () -> Content,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        modifier(PopupViewModifier(
            isPresented: isPresented,
            style: style,
            dismissMethods: dismissMethods,
            content: content,
            onDismiss: onDismiss
        ))
    }

    public func popup<A>(
        _ title: Text,
        message: Text?,
        isPresented: Binding<Bool>,
        dismissMethods: Popup.DismissMethods = [.tapOutside],
        @ViewBuilder actions: @escaping () -> A,
        onDismiss: (() -> Void)? = nil
    ) -> some View where A: View {
        popup(
            isPresented: isPresented,
            style: .alert,
            dismissMethods: dismissMethods,
            content: {
                Popup.AlertContent(
                    isPresented: isPresented,
                    title: title,
                    message: message,
                    dismissMethods: dismissMethods,
                    actions: actions
                )
            },
            onDismiss: onDismiss
        )
    }

    public func popup<A, S1, S2>(
        _ title: S1,
        message: S2?,
        isPresented: Binding<Bool>,
        dismissMethods: Popup.DismissMethods = [.tapOutside],
        @ViewBuilder actions: @escaping () -> A,
        onDismiss: (() -> Void)? = nil
    ) -> some View where A: View, S1: StringProtocol, S2: StringProtocol {
        popup(Text(title), message: message.map { Text.init($0) }, isPresented: isPresented, actions: actions)
    }
}

// MARK: - View Modifier

private struct PopupViewModifier<PopupContent>: ViewModifier where PopupContent: View {
    init(
        isPresented: Binding<Bool>,
        style: Popup.Style,
        dismissMethods: Popup.DismissMethods,
        @ViewBuilder content: @escaping () -> PopupContent,
        onDismiss: (() -> Void)?
    ) {
        self._isPresented = isPresented
        self.style = style
        self.dismissMethods = dismissMethods
        self.content = content
        self.onDismiss = onDismiss
    }

    @State private var workItem: DispatchWorkItem?

    /// A Boolean value that indicates whether the view associated with this
    /// environment is currently being presented.
    @Binding private var isPresented: Bool

    /// A property indicating the popup style.
    private let style: Popup.Style

    /// A block containing the content of popup.
    private let content: () -> PopupContent

    /// A property indicating all of the ways popup can be dismissed.
    private let dismissMethods: Popup.DismissMethods

    /// An action to perform when popup is dismissed.
    private let onDismiss: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .overlay(popupContent)
            .onChange(of: isPresented) { isPresented in
                if isPresented {
                    setupAutomaticDismissalIfNeeded()
                } else {
                    onDismiss?()
                }
            }
    }

    private var popupContent: some View {
        ZStack {
            // Host Content Dim Overlay
            EnvironmentReader(\.screen) { screen in
                if isPresented {
                    Color(white: 0, opacity: 0.20)
                        .frame(width: screen.size.width, height: screen.size.height)
                        .ignoresSafeArea()
                        .transition(.opacity.animation(.easeInOut(duration: 0.15)))
                        .onTapGestureIf(dismissMethods.contains(.tapOutside)) {
                            isPresented = false
                        }
                }
            }

            // Popup Content
            GeometryReader { geometry in
                if isPresented {
                    content()
                        .animation(style.animation)
                        .transition(style.transition)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: style.alignment)
                        .onTapGestureIf(dismissMethods.contains(.tapInside)) {
                            isPresented = false
                        }
                }
            }
        }
    }

    private func setupAutomaticDismissalIfNeeded() {
        guard let duration = style.dismissAfter else {
            return
        }

        workItem?.cancel()

        workItem = DispatchWorkItem {
            isPresented = false
        }

        if isPresented, let work = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: work)
        }
    }
}
