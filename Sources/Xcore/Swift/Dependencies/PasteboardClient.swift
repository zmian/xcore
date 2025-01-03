//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// Provides functionality for copying a string to pasteboard.
///
/// **Usage**
///
/// ```swift
/// class ViewModel {
///     @Dependency(\.pasteboard) var pasteboard
///
///     func copy() {
///         pasteboard.copy("hello")
///     }
/// }
/// ```
public struct PasteboardClient: Sendable {
    /// Copy the given string to the pasteboard.
    public let copy: @Sendable (String) -> Void

    /// Creates a client that copy a string to the pasteboard.
    ///
    /// - Parameter copy: The closure to copy the given string to the pasteboard.
    public init(copy: @escaping @Sendable (String) -> Void) {
        self.copy = copy
    }
}

// MARK: - Variants

extension PasteboardClient {
    /// Returns noop variant of `PasteboardClient`.
    public static var noop: Self {
        .init { _ in }
    }

    /// Returns unimplemented variant of `PasteboardClient`.
    public static var unimplemented: Self {
        .init { _ in
            reportIssue(#"Unimplemented: @Dependency(\.pasteboard)"#)
        }
    }

    /// Returns live variant of `PasteboardClient`.
    public static var live: Self {
        .init { string in
            UIPasteboard.general.string = string
        }
    }
}

// MARK: - Dependency

extension DependencyValues {
    private enum PasteboardClientKey: DependencyKey {
        nonisolated(unsafe) static var liveValue: PasteboardClient = .live
    }

    /// Provides functionality for copying a string to pasteboard.
    public var pasteboard: PasteboardClient {
        get { self[PasteboardClientKey.self] }
        set { self[PasteboardClientKey.self] = newValue }
    }

    /// Provides functionality for copying a string to pasteboard.
    @discardableResult
    public static func pasteboard(_ value: PasteboardClient) -> Self.Type {
        PasteboardClientKey.liveValue = value
        return Self.self
    }
}
