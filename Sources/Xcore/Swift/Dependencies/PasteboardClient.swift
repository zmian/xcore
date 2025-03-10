//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

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
            #if canImport(UIKit)
            UIPasteboard.general.string = string
            #elseif canImport(AppKit)
            NSPasteboard.general.string = string
            #endif
        }
    }
}

// MARK: - Dependency

extension DependencyValues {
    private enum PasteboardClientKey: DependencyKey {
        static let liveValue: PasteboardClient = .live
    }

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
    public var pasteboard: PasteboardClient {
        get { self[PasteboardClientKey.self] }
        set { self[PasteboardClientKey.self] = newValue }
    }
}
