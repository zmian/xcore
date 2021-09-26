//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A stylized view, with a title and value, that visually collects a logical
/// grouping of content.
public struct XStack<Title, Value>: View where Title: View, Value: View {
    @Environment(\.xstackStyle) private var style
    private let title: () -> Title
    private let value: () -> Value

    public init(
        @ViewBuilder title: @escaping () -> Title,
        @ViewBuilder value: @escaping () -> Value
    ) {
        self.title = title
        self.value = value
    }

    public var body: some View {
        style.makeBody(configuration: .init(
            title: .init(content: title()),
            value: .init(content: value())
        ))
    }
}
