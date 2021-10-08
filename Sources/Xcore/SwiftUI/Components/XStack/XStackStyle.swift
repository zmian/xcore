//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Style

public protocol XStackStyle {
    associatedtype Body: View
    typealias Configuration = XStackStyleConfiguration

    @ViewBuilder
    func makeBody(configuration: Configuration) -> Body
}

// MARK: - Configuration

/// The properties of an XStack.
public struct XStackStyleConfiguration {
    /// A type-erased title view of a stack.
    public struct Title: View {
        public let body: Either<AnyView, EmptyView>

        /// A boolean that indicates whether the title view is an empty view.
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

    /// A type-erased value view of a stack.
    public struct Value: View {
        public let body: Either<AnyView, EmptyView>

        /// A boolean that indicates whether the value view is an empty view.
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

    /// A view that represents the title of the stack.
    public let title: Title

    /// A view that represents the value of the stack.
    public let value: Value

    /// A boolean that indicates whether the stack either have title or value.
    public var isSingleChild: Bool {
        title.isEmpty || value.isEmpty
    }
}

// MARK: - Any Style

struct AnyXStackStyle: XStackStyle {
    private var _makeBody: (Self.Configuration) -> AnyView

    init<S: XStackStyle>(style: S) {
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
    private struct XStackStyleKey: EnvironmentKey {
        static var defaultValue = AnyXStackStyle(style: DefaultXStackStyle())
    }

    var xstackStyle: AnyXStackStyle {
        get { self[XStackStyleKey.self] }
        set { self[XStackStyleKey.self] = newValue }
    }
}

// MARK: - View Helper

extension View {
    /// Sets the style for `XStack` within this view to a style with a custom
    /// appearance and standard interaction behavior.
    public func xstackStyle<S: XStackStyle>(_ style: S) -> some View {
        environment(\.xstackStyle, AnyXStackStyle(style: style))
    }

    /// Sets the style for `XStack` within this view to a style with a custom
    /// appearance and standard interaction behavior.
    public func xstackStyle(
        dim: XStackDimContent = .none,
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = .s5
    ) -> some View {
        xstackStyle(DefaultXStackStyle(
            dim: dim,
            alignment: alignment,
            spacing: spacing
        ))
    }
}
