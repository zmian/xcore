//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Style

public protocol XLabeledContentStyle {
    associatedtype Body: View
    typealias Configuration = XLabeledContentStyleConfiguration

    @ViewBuilder
    func makeBody(configuration: Configuration) -> Body
}

// MARK: - Configuration

/// The properties of an XLabeledContent.
public struct XLabeledContentStyleConfiguration {
    /// A type-erased label of a labeled content instance.
    public struct Label: View {
        public let body: Either<AnyView, EmptyView>

        /// A Boolean property indicating whether the label view is an empty view.
        public let isEmpty: Bool

        init<Content: View>(content: @autoclosure () -> Content) {
            if Content.self != Never.self {
                body = .left(content().eraseToAnyView())
                isEmpty = false
            } else {
                body = .right(EmptyView())
                isEmpty = true
            }
        }
    }

    /// A type-erased content of a labeled content instance.
    public struct Content: View {
        public let body: Either<AnyView, EmptyView>

        /// A Boolean property indicating whether the content view is an empty view.
        public let isEmpty: Bool

        init<Content: View>(content: @autoclosure () -> Content) {
            if Content.self != Never.self {
                body = .left(content().eraseToAnyView())
                isEmpty = false
            } else {
                body = .right(EmptyView())
                isEmpty = true
            }
        }
    }

    /// The label of the labeled content instance.
    public let label: Label

    /// The content of the labeled content instance.
    public let content: Content

    /// A Boolean property indicating whether the labeled content instance either
    /// have label or content.
    public var isSingleChild: Bool {
        label.isEmpty || content.isEmpty
    }
}

// MARK: - Any Style

struct AnyXLabeledContentStyle: XLabeledContentStyle {
    private var _makeBody: (Self.Configuration) -> AnyView

    init<S: XLabeledContentStyle>(style: S) {
        _makeBody = {
            style.makeBody(configuration: $0)
                .eraseToAnyView()
        }
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        _makeBody(configuration)
    }
}

// MARK: - Environment Key

extension EnvironmentValues {
    private struct XLabeledContentStyleKey: EnvironmentKey {
        static var defaultValue = AnyXLabeledContentStyle(style: DefaultXLabeledContentStyle())
    }

    var xlabeledContentStyle: AnyXLabeledContentStyle {
        get { self[XLabeledContentStyleKey.self] }
        set { self[XLabeledContentStyleKey.self] = newValue }
    }
}

// MARK: - View Helper

extension View {
    /// Sets the style for `XLabeledContent` within this view to a style with a
    /// custom appearance and standard interaction behavior.
    public func xlabeledContentStyle<S: XLabeledContentStyle>(_ style: S) -> some View {
        environment(\.xlabeledContentStyle, AnyXLabeledContentStyle(style: style))
    }

    /// Sets the style for `XLabeledContent` within this view to a style with a
    /// custom appearance and standard interaction behavior.
    public func xlabeledContentStyle(
        _ traits: XLabeledContentContentTraits = .none,
        dim: XLabeledContentDimContent = .none,
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = .interItemHSpacing,
        separator separatorStyle: ListRowSeparatorStyle? = nil
    ) -> some View {
        xlabeledContentStyle(DefaultXLabeledContentStyle(
            traits: traits,
            dim: dim,
            alignment: alignment,
            spacing: spacing
        ))
        .unwrap(separatorStyle) {
            $0.listRowSeparatorStyle($1)
        }
    }
}
