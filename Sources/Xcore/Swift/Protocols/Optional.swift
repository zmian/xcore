//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - OptionalTypeMarker

public protocol OptionalTypeMarker {
    /// A boolean value that determines whether the wrapped value is `nil`.
    var isNil: Bool { get }
}

extension Optional: OptionalTypeMarker {
    public var isNil: Bool {
        switch self {
            case .none:
                return true
            case .some:
                return false
        }
    }

    /// A boolean value that determines whether the wrapped value is not `nil`.
    ///
    /// Useful in KeyPaths to allow for negation.
    public var isNotNil: Bool {
        !isNil
    }
}

// MARK: - OptionalType

// Credit: https://stackoverflow.com/a/45462046

public protocol OptionalType {
    associatedtype Wrapped
    var wrapped: Wrapped? { get }
}

extension Optional: OptionalType {
    public var wrapped: Wrapped? {
        self
    }
}
