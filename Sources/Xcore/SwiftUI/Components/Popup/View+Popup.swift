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
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the popup that you create in the modifier's `content` closure.
    ///   - style: The style of the popup.
    ///   - dismissMethods: An option set specifying the dismissal methods for the
    ///     popup.
    ///   - content: A closure returning the content of the popup.
    ///   - onDismiss: The closure to execute when dismissing the popup.
    public func popup<Content>(
        isPresented: Binding<Bool>,
        style: Popup.Style = .alert,
        dismissMethods: Popup.DismissMethods = [.tapOutside],
        @ViewBuilder content: @escaping () -> Content,
        onDismiss: (() -> Void)? = nil
    ) -> some View where Content: View {
        modifier(PopupViewModifier(
            isPresented: isPresented,
            style: style,
            dismissMethods: dismissMethods,
            content: content,
            onDismiss: onDismiss
        ))
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
    ///   - onDismiss: The closure to execute when dismissing the popup.
    public func popup<Item, Content>(
        item: Binding<Item?>,
        style: Popup.Style = .alert,
        dismissMethods: Popup.DismissMethods = [.tapOutside],
        @ViewBuilder content: @escaping (Item) -> Content,
        onDismiss: (() -> Void)? = nil
    ) -> some View where Content: View {
        modifier(PopupViewModifier(
            isPresented: .init {
                item.wrappedValue != nil
            } set: { newValue in
                if !newValue {
                    item.wrappedValue = nil
                }
            },
            style: style,
            dismissMethods: dismissMethods,
            content: {
                if let item = item.wrappedValue {
                    content(item)
                }
            },
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
        popup(
            Text(title),
            message: message.map { Text($0) },
            isPresented: isPresented,
            dismissMethods: dismissMethods,
            actions: actions,
            onDismiss: onDismiss
        )
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

    /// A closure containing the content of popup.
    private let content: () -> PopupContent

    /// A property indicating all of the ways popup can be dismissed.
    private let dismissMethods: Popup.DismissMethods

    /// An action to perform when popup is dismissed.
    private let onDismiss: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .overlay(popupBody)
            .onChange(of: isPresented) { isPresented in
                if isPresented {
                    setupAutomaticDismissalIfNeeded()
                } else {
                    onDismiss?()
                }
            }
    }

    private var popupBody: some View {
        popupDimmedBackground
            .overlay(popupContent)
    }

    private var popupContent: some View {
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

    /// Host Content Dim Overlay
    private var popupDimmedBackground: some View {
        EnvironmentReader(\.device) { device in
            if isPresented {
                Color(white: 0, opacity: 0.20)
                    .frame(width: device.screen.size.width, height: device.screen.size.height)
                    .ignoresSafeArea()
                    .transition(.opacity.animation(.easeInOut(duration: 0.15)))
                    .onTapGestureIf(dismissMethods.contains(.tapOutside)) {
                        isPresented = false
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
