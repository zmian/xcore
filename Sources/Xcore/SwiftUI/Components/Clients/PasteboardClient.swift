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
/// struct ViewModel {
///     @Dependency(\.pasteboard) var pasteboard
///
///     func copy() {
///         pasteboard.copy("hello")
///     }
/// }
/// ```
public struct PasteboardClient: Hashable, Identifiable {
    public let id: String

    /// Copy the specified string to pasteboard.
    public let copy: (String) -> Void

    public init(id: String = #function, copy: @escaping (String) -> Void) {
        self.id = id
        self.copy = copy
    }

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Variants

extension PasteboardClient {
    /// Returns live variant of `PasteboardClient`.
    public static var live: Self {
        .init { string in
            UIPasteboard.general.string = string
        }
    }

    /// Returns noop variant of `PasteboardClient`.
    public static var noop: Self {
        .init { _ in }
    }

    #if DEBUG
    /// Returns failing variant of `PasteboardClient`.
    public static var failing: Self {
        .init { _ in
            internal_XCTFail("\(Self.self).copy is unimplemented")
        }
    }
    #endif
}

// MARK: - Dependency

extension DependencyValues {
    private struct PasteboardClientKey: DependencyKey {
        static let defaultValue: PasteboardClient = .live
    }

    /// Provides functionality for copying a string to pasteboard.
    public var pasteboard: PasteboardClient {
        get { self[PasteboardClientKey.self] }
        set { self[PasteboardClientKey.self] = newValue }
    }

    /// Provides functionality for copying a string to pasteboard.
    @discardableResult
    public static func pasteboard(_ value: PasteboardClient) -> Self.Type {
        set(\.pasteboard, value)
        return Self.self
    }
}
