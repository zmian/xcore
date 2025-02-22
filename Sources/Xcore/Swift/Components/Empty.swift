//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import SwiftUI

/// A structure representing an empty value.
///
/// The `Empty` struct serves as a placeholder type that indicates the absence
/// of meaningful data. It conforms to several protocols to allow use as a
/// default or dummy value in type-safe contexts. In addition, when used as a
/// SwiftUI view, it renders as an `EmptyView`, making it ideal for cases where
/// no visual content is desired.
///
/// **Usage**
///
/// ```swift
/// // Creating an instance
/// let emptyInstance = Empty()
///
/// // Using Empty as a view
/// var body: some View {
///     Empty()
/// }
/// ```
@frozen
public struct Empty {
    /// Creates a new instance of `Empty`.
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
