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
                StandardPopupAlert(
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

    private let duration: Double = 0.15

    @State private var workItem: DispatchWorkItem?

    /// A Boolean value that indicates whether to kick off series of events to
    /// present this popup.
    ///
    /// **Show**
    /// ```
    /// // When isPresented = true
    /// // To preseve display animations
    /// // isPresented -> isWindowPresented -> isContentPresented
    /// ```
    /// **Hide**
    /// ```
    /// // When isPresented = false
    /// // To preseve dismissal animations
    /// // isPresented -> isContentPresented -> isWindowPresented
    /// ```
    @Binding private var isPresented: Bool

    /// A Boolean value that indicates whether the view associated with this
    /// environment is currently being presented.
    @State private var isWindowPresented: Bool = false

    /// A Boolean value that indicates whether the popup content is currently being
    /// presented.
    ///
    /// - Note: This state is a workaround to prevent a SwiftUI bug that breaks view
    ///   animations when wrapped in ``UIHostingController``.
    ///
    ///   As a workaround when `isWindowPresented` is presented we toggle this
    ///   property to `true` with ``DispatchQueue.main.async``. On dismiss, instead
    ///   of setting `isWindowPresented` to `false` directly we set this property to
    ///   `false` and then after `0.2` delay we set the `isWindowPresented` to
    ///   `false` to ensure we get proper dismissal animations.
    @State private var isContentPresented: Bool = false

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
            .window(isPresented: $isWindowPresented, style: style.windowStyle) {
                popupContent
            }
            .onChange(of: isPresented) { isPresented in
                if isPresented {
                    // 1. Present window
                    isWindowPresented = true
                    // 2. Present window content
                    isContentPresented = true
                    // 3. Set up automatic dismissal of window if needed
                    setupAutomaticDismissalIfNeeded()
                } else {
                    // This is only executed if `isPresented` is set to false by the calling code
                    // (e.g., A button tap to dismiss popup.)
                    isContentPresented = false
                }
            }
            .onChange(of: isContentPresented) { isContentPresented in
                if isContentPresented == false {
                    // Added a delay as a workaround to prevent a swiftUI bug that breaks animations
                    // when it's wrapped in UIHostingController.
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.01) {
                        isWindowPresented = false
                        isPresented = false
                        onDismiss?()
                    }
                }
            }
    }

    private var popupContent: some View {
        ZStack {
            if isContentPresented {
                if style.allowDimming {
                    // Host Content Dim Overlay
                    Color(white: 0, opacity: 0.20)
                        .frame(max: .infinity)
                        .ignoresSafeArea()
                        .transition(.opacity.animation(.easeInOut(duration: duration)))
                        .onTapGestureIf(dismissMethods.contains(.tapOutside)) {
                            isContentPresented = false
                        }
                        .zIndex(1)
                }

                content()
                    .animation(style.animation)
                    .transition(style.transition)
                    .frame(max: .infinity, alignment: style.alignment)
                    .ignoresSafeArea(edges: style.ignoresSafeAreaEdges)
                    .onTapGestureIf(dismissMethods.contains(.tapInside)) {
                        isContentPresented = false
                    }
                    .zIndex(2)
            }
        }
    }

    private func setupAutomaticDismissalIfNeeded() {
        guard let duration = style.dismissAfter else {
            return
        }

        workItem?.cancel()

        workItem = DispatchWorkItem {
            isContentPresented = false
        }

        if isWindowPresented, let work = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: work)
        }
    }
}
