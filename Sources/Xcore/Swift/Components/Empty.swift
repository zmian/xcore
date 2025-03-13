//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import SwiftUI

/// A structure representing the absence of meaningful content or state.
///
/// `Empty` is a lightweight, immutable type that can be used as a placeholder
/// or default value in contexts where no data is required. It is comparable to
/// an empty tuple `()` but provides a named, explicit type for clarity in APIs
/// and generic constraints. When used in SwiftUI, it renders as `EmptyView`,
/// making it ideal for scenarios where no visual content is required.
///
/// **Usage**
///
/// ```swift
/// // Creating an instance
/// let emptyInstance = Empty()
///
/// // Use in SwiftUI
/// struct ContentView: View {
///     var body: some View {
///         Empty()
///     }
/// }
/// ```
@frozen
public struct Empty {
    /// Creates a new instance of `Empty`.
    @inlinable
    public init() {}
}

extension Empty: Sendable {}
extension Empty: Hashable {}
extension Empty: Codable {}

// MARK: - Identifiable

extension Empty: Identifiable {
    /// A unique identifier for this instance.
    ///
    /// Always returns an empty string since `Empty` represents a singular, default
    /// value.
    public var id: String { "" }
}

// MARK: - Comparable

extension Empty: Comparable {
    /// Compares two `Empty` instances.
    ///
    /// Always returns `false` as there is no meaningful ordering.
    public static func <(lhs: Self, rhs: Self) -> Bool { false }

    /// Compares two `Empty` instances.
    ///
    /// Always returns `false` as there is no meaningful ordering.
    public static func >(lhs: Self, rhs: Self) -> Bool { false }
}

// MARK: - View

extension Empty: View {
    /// The view representation of an `Empty` instance.
    ///
    /// Returns SwiftUI's built-in `EmptyView`, serving as a placeholder in view
    /// hierarchies when no content is desired.
    public var body: some View {
        EmptyView()
    }
}
