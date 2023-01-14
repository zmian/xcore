//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A container for attaching a label to a value-bearing view.
@available(iOS, introduced: 14, deprecated: 16, message: "Use LabeledContent")
public struct XLabeledContent<Label, Content>: View where Label: View, Content: View {
    @Environment(\.xlabeledContentStyle) private var style
    private let label: () -> Label
    private let content: () -> Content

    public init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.label = label
        self.content = content
    }

    public var body: some View {
        style.makeBody(configuration: .init(
            label: .init(content: label()),
            content: .init(content: content())
        ))
        .accessibilityElement(children: .combine)
    }
}
