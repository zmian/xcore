//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - View Extension

extension View {
    /// Presents a popup when a binding to a Boolean value that you provide is
    /// `true`.
    ///
    /// Use this method when you want to present a popup view to the user when a
    /// Boolean value you provide is `true`. The example below displays a popup view
    /// of the mockup for a software license agreement when the user toggles the
    /// `isShowingPopup` variable by clicking or tapping on the "Show License
    /// Agreement" button:
    ///
    /// ```swift
    /// struct ShowLicenseAgreement: View {
    ///     @State private var isShowingPopup = false
    ///
    ///     var body: some View {
    ///         Button {
    ///             isShowingPopup.toggle()
    ///         } label: {
    ///             Text("Show License Agreement")
    ///         }
    ///         .popup(isPresented: $isShowingPopup) {
    ///             VStack {
    ///                 Text("License Agreement")
    ///                 Text("Terms and conditions go here.")
    ///                 Button("Dismiss") {
    ///                     isShowingPopup.toggle()
    ///                 }
    ///             }
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value indicating whether to present
    ///     the popup that you create in the modifier's `content` closure.
    ///   - style: The style of the popup.
    ///   - dismissMethods: An option set specifying the dismissal methods for the
    ///     popup.
    ///   - content: A closure returning the content of the popup.
    public func popup<Content>(
        isPresented: Binding<Bool>,
        style: Popup.Style = .alert,
        dismissMethods: Popup.DismissMethods = [.tapOutside],
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content: View {
        // Widgets & Extension does not support UIWindow & DispatchWorkItem.
        applyIf(AppInfo.target == .app) {
            $0.modifier(PopupViewModifier(
                isPresented: isPresented,
                style: style,
                dismissMethods: dismissMethods,
                content: content
            ))
        }
    }

    /// Presents a popup using the given item as a data source for the popup's
    /// content.
    ///
    /// Use this method when you need to present a popup view with content from a
    /// custom data source. The example below shows a custom data source
    /// `InventoryItem` that the `content` closure uses to populate the display the
    /// action popup shows to the user:
    ///
    /// ```swift
    /// struct ShowPartDetail: View {
    ///     @State var popupDetail: InventoryItem?
    ///
    ///     var body: some View {
    ///         Button("Show Part Details") {
    ///             popupDetail = InventoryItem(
    ///                 id: "0123456789",
    ///                 partNumber: "Z-1234A",
    ///                 quantity: 100,
    ///                 name: "Widget"
    ///             )
    ///         }
    ///         .popup(item: $popupDetail) { detail in
    ///             VStack(alignment: .leading, spacing: 20) {
    ///                 Text("Part Number: \(detail.partNumber)")
    ///                 Text("Name: \(detail.name)")
    ///                 Text("Quantity On-Hand: \(detail.quantity)")
    ///             }
    ///             .onTapGesture {
    ///                 popupDetail = nil
    ///             }
    ///         }
    ///     }
    /// }
    ///
    /// struct InventoryItem: Identifiable {
    ///     var id: String
    ///     let partNumber: String
    ///     let quantity: Int
    ///     let name: String
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the popup. When
    ///    `item` is non-`nil`, the system passes the item's content to the
    ///     modifier's closure. You display this content in a popup that you create
    ///     that the system displays to the user. If `item` changes, the system
    ///     dismisses the popup and replaces it with a new one using the same
    ///     process.
    ///   - style: The style of the popup.
    ///   - dismissMethods: An option set specifying the dismissal methods for the
    ///     popup.
    ///   - content: A closure returning the content of the popup.
    public func popup<Item, Content>(
        item: Binding<Item?>,
        style: Popup.Style = .alert,
        dismissMethods: Popup.DismissMethods = [.tapOutside],
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View where Content: View {
        popup(
            isPresented: .init {
                item.wrappedValue != nil
            } set: { isPresented in
                if !isPresented {
                    item.wrappedValue = nil
                }
            },
            style: style,
            dismissMethods: dismissMethods,
            content: {
                if let item = item.wrappedValue {
                    content(item)
                }
            }
        )
    }

    public func popup<F>(
        _ title: Text,
        message: Text?,
        isPresented: Binding<Bool>,
        dismissMethods: Popup.DismissMethods = [.tapOutside],
        @ViewBuilder footer: @escaping () -> F
    ) -> some View where F: View {
        popup(
            isPresented: isPresented,
            style: .alert,
            dismissMethods: dismissMethods,
            content: {
                StandardPopupAlert(title, message: message, footer: footer)
            }
        )
    }

    public func popup<F, S1, S2>(
        _ title: S1,
        message: S2?,
        isPresented: Binding<Bool>,
        dismissMethods: Popup.DismissMethods = [.tapOutside],
        @ViewBuilder footer: @escaping () -> F
    ) -> some View where F: View, S1: StringProtocol, S2: StringProtocol {
        popup(
            Text(title),
            message: message.map { Text($0) },
            isPresented: isPresented,
            dismissMethods: dismissMethods,
            footer: footer
        )
    }
}

// MARK: - View Modifier

private struct PopupViewModifier<PopupContent>: ViewModifier where PopupContent: View {
    init(
        isPresented: Binding<Bool>,
        style: Popup.Style,
        dismissMethods: Popup.DismissMethods,
        @ViewBuilder content: @escaping () -> PopupContent
    ) {
        self._isPresented = isPresented
        self.style = style
        self.dismissMethods = dismissMethods
        self.content = content
    }

    @State private var workItem: DispatchWorkItem?

    /// A Boolean value indicating whether the popup associated with this
    /// environment is currently being presented.
    @Binding private var isPresented: Bool

    /// A property indicating the popup style.
    private let style: Popup.Style

    /// A closure containing the content of popup.
    private let content: () -> PopupContent

    /// A property indicating all of the ways popup can be dismissed.
    private let dismissMethods: Popup.DismissMethods

    func body(content: Content) -> some View {
        content
            .window(isPresented: $isPresented, style: style.windowStyle) {
                popupContent
            }
            .onChange(of: isPresented) { isPresented in
                if isPresented {
                    setupAutomaticDismissalIfNeeded()
                    UIAccessibility.post(notification: .screenChanged, argument: nil)
                    UIAccessibility.post(notification: .announcement, argument: "Alert")
                }
            }
    }

    private var popupContent: some View {
        ZStack {
            if isPresented {
                if style.allowDimming {
                    // Host Content Dim Overlay
                    Color(white: 0, opacity: 0.20)
                        .frame(max: .infinity)
                        .ignoresSafeArea()
                        .onTapGestureIf(dismissMethods.contains(.tapOutside)) {
                            isPresented = false
                        }
                        .zIndex(1)
                        .transition(.opacity)
                }

                content()
                    .frame(max: .infinity, alignment: style.alignment)
                    .ignoresSafeArea(edges: style.ignoresSafeAreaEdges)
                    .onTapGestureIf(dismissMethods.contains(.tapInside)) {
                        isPresented = false
                    }
                    .zIndex(2)
                    .transition(style.transition)
            }
        }
        .animation(style.animation, value: isPresented)
        .popupDismissAction(
            dismissMethods.contains(.xmark) ? PopupDismissAction { isPresented = false } : nil
        )
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
