//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A type-erased shape.
///
/// An AnyShape allows changing the type of shap used in a given view hierarchy.
/// Whenever the type of shape used with an AnyShape changes, the old hierarchy
/// is destroyed and a new hierarchy is created for the new type.
@available(iOS, introduced: 14, deprecated: 16, message: "Use AnyShape directly.")
public struct AnyShape: Shape {
    private let _path: (CGRect) -> Path

    /// Create an instance that type-erases shap.
    public init(_ shape: some Shape) {
        self._path = shape.path(in:)
    }

    public func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

/// A type-erased insettable shape.
///
/// An AnyShape allows changing the type of shap used in a given view hierarchy.
/// Whenever the type of shape used with an AnyShape changes, the old hierarchy
/// is destroyed and a new hierarchy is created for the new type.
public struct AnyInsettableShape: InsettableShape {
    private let _path: (CGRect) -> Path
    private let _inset: (CGFloat) -> AnyInsettableShape

    /// Create an instance that type-erases shap.
    public init(_ shape: some InsettableShape) {
        self._path = shape.path(in:)
        self._inset = {
            AnyInsettableShape(shape.inset(by: $0))
        }
    }

    public func path(in rect: CGRect) -> Path {
        _path(rect)
    }

    public func inset(by amount: CGFloat) -> some InsettableShape {
        _inset(amount)
    }
}
