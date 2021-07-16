//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A view that reads an environment value of a key path.
///
/// ```swift
/// EnvironmentReader(\.theme) { theme in
///     Color(theme.backgroundColor)
/// }
/// ```
public struct EnvironmentReader<Value, Content>: View where Content: View {
    @Environment private var value: Value
    private let content: (Value) -> Content

    public init(
        _ keyPath: KeyPath<EnvironmentValues, Value>,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self._value = .init(keyPath)
        self.content = content
    }

    public var body: some View {
        content(value)
    }
}
