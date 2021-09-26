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
    /// A type-erased title view of an XStack.
    public struct Title: View {
        public let body: _ConditionalContent<AnyView, EmptyView>

        /// A boolean that indicates whether the title view is an empty view.
        public let isEmpty: Bool

        init<Content: View>(content: @autoclosure () -> Content) {
            if Content.self != Never.self {
                body = ViewBuilder.buildEither(first: content().eraseToAnyView())
                isEmpty = false
            } else {
                body = ViewBuilder.buildEither(second: EmptyView())
                isEmpty = true
            }
        }
    }

    /// A type-erased value view of an XStack.
    public struct Value: View {
        public let body: _ConditionalContent<AnyView, EmptyView>

        /// A boolean that indicates whether the value view is an empty view.
        public let isEmpty: Bool

        init<Content: View>(content: @autoclosure () -> Content) {
            if Content.self != Never.self {
                body = ViewBuilder.buildEither(first: content().eraseToAnyView())
                isEmpty = false
            } else {
                body = ViewBuilder.buildEither(second: EmptyView())
                isEmpty = true
            }
        }
    }

    public let title: Title
    public let value: Value

    public var isSingleView: Bool {
        title.isEmpty || value.isEmpty
    }
}

// MARK: - Any Style

struct AnyXStackStyle: XStackStyle {
    private var _makeBody: (Self.Configuration) -> AnyView

    init<S: XStackStyle>(style: S) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        _makeBody(configuration)
    }
}

// MARK: - Default Style

private struct DefaultXStackStyle: XStackStyle {
    var alignment: VerticalAlignment = .center
    var spacing: CGFloat? = .s5

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack(alignment: alignment, spacing: configuration.isSingleView ? 0 : spacing) {
            configuration.title
            Spacer(minLength: 0)
            configuration.value
        }
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
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = .s5
    ) -> some View {
        xstackStyle(DefaultXStackStyle(
            alignment: alignment,
            spacing: spacing
        ))
    }
}
