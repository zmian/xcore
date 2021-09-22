//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Dependency View

extension View {
    /// Sets the dependency value of the specified key path to the given value.
    ///
    /// Use this modifier in **previews** to set one of the writable properties of
    /// the ``DependencyValues`` structure, including custom values that you create.
    /// For example, you can set the value associated with the
    /// ``DependencyValues/pasteboard`` key:
    ///
    /// ```swift
    /// struct Profile_Previews: PreviewProvider {
    ///     static var previews: some View {
    ///         ProfileView()
    ///             .dependency(\.pasteboard, .live)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - keyPath: A key path that indicates the property of the
    ///     ``DependencyValues`` structure to update.
    ///   - value: The new value to set for the item specified by `keyPath`.
    ///
    /// - Returns: A view that has the given value set in its dependency.
    public func dependency<V>(_ keyPath: WritableKeyPath<DependencyValues, V>, _ value: V) -> some View {
        DependencyWriter(content: self) { values in
            values.set(keyPath, value)
        }
    }
}

/// A view that writes dependency.
///
/// ```swift
/// DependencyWriter { values in
///     values.set(\.pasteboard, .live)
/// }
/// ```
private struct DependencyWriter<Content>: View where Content: View {
    private let content: () -> Content

    init(
        content: @autoclosure @escaping () -> Content,
        write: (DependencyValues.Type) -> Void
    ) {
        self.content = content
        write(DependencyValues.self)
    }

    var body: some View {
        content()
    }
}
