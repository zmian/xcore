//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - OptionalTypeMarker

public protocol OptionalTypeMarker {}
extension Optional: OptionalTypeMarker {}

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
