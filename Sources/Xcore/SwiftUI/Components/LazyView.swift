//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A view that only executes the given content when the body property is
/// invoked.
///
/// ```
/// LazyView {
///     SomeComplexView()
/// }
///
/// // or
///
/// LazyView(SomeComplexView())
/// ```
public struct LazyView<Content>: View where Content: View {
    private let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public init(_ content: @autoclosure @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        content()
    }
}
