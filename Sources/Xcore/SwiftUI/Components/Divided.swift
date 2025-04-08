//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A container view that automatically inserts separators between its subviews.
///
/// The ``Divided`` view arranges the provided content by inserting a separator
/// between each pair of adjacent subviews. By default, if no separator is
/// supplied, a standard ``Divider`` is used. This is particularly useful for
/// creating visually separated lists or grouped layouts.
///
/// For example, the following code creates a vertically spaced list of texts
/// with dividers between them:
///
/// ```swift
/// Divided {
///     Text("First")
///     Text("Second")
///     Text("Third")
/// }
/// ```
///
/// In the example above, a standard divider is inserted between each text
/// view.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public struct Divided<Content: View, Separator: View>: View {
    private let content: Content
    private let separator: Separator

    /// Creates a new ``Divided`` view with a custom separator.
    ///
    /// Use this initializer when you wish to specify a custom separator view to be
    /// inserted between subviews.
    ///
    /// - Parameters:
    ///   - content: A view builder that produces the content to be arranged.
    ///   - separator: A view builder that creates the separator to insert between
    ///     adjacent subviews.
    public init(@ViewBuilder content: () -> Content, @ViewBuilder separator: () -> Separator) {
        self.content = content()
        self.separator = separator()
    }

    /// Creates a new ``Divided`` view using a standard divider as the separator.
    ///
    /// When this initializer is used, a default ``Divider`` is automatically
    /// inserted between each pair of adjacent subviews.
    ///
    /// - Parameter content: A view builder that produces the content to be
    ///   arranged.
    public init(@ViewBuilder content: () -> Content) where Separator == Divider {
        self.content = content()
        self.separator = Divider()
    }

    public var body: some View {
        Group(subviews: content) { subviews in
            ForEach(Array(subviews.enumerated()), id: \.offset) { offset, element in
                element
                if offset != subviews.count - 1 {
                    separator
                }
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
#Preview("Custom Divider") {
    VStack {
        Divided {
            Text("First")
            Text("Second")
            Text("Third")
        } separator: {
            Capsule()
                .fill(.blue)
                .frame(width: 50, height: 3)
        }
    }

    Spacer(height: 50)

    VStack {
        Divided {
            Text("First")
            Text("Second")
            Text("Third")
        } separator: {
            Image(system: .starFill)
                .foregroundStyle(.yellow)
        }
    }

    Spacer(height: 50)

    HStack {
        Divided {
            Text("First")
            Text("Second")
            Text("Third")
        } separator: {
            Separator(color: .indigo, style: .dotted)
        }
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
#Preview("Standard Divider") {
    VStack {
        Divided {
            Text("First")
            Text("Second")
            Text("Third")
        }
        .border(.blue)
    }

    HStack {
        Divided {
            Text("First")
            Text("Second")
            Text("Third")
        }
        .border(.blue)
    }
}
