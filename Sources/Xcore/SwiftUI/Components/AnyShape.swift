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
public struct AnyShape: Shape {
    private var _path: (CGRect) -> Path

    /// Create an instance that type-erases shap.
    public init<S>(_ shape: S) where S: Shape {
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
    private var _path: (CGRect) -> Path
    private var _inset: (CGFloat) -> AnyInsettableShape

    /// Create an instance that type-erases shap.
    public init<S>(_ shape: S) where S: InsettableShape {
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
