//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Appliable

/// A protocol that enables types to be configured using closure based API.
public protocol Appliable {}

extension Appliable {
    /// Apply styles using the given closure.
    ///
    /// ```swift
    /// let label = UILabel()
    ///
    /// // later somewhere in the code
    /// label.apply {
    ///     $0.textColor = .blue
    /// }
    ///
    /// // or
    /// let button = UIButton().apply {
    ///     $0.setTitle("Hello, world!", for: .normal)
    /// }
    /// ```
    ///
    /// - Parameter configure: The configuration block to apply.
    @discardableResult
    public func apply(_ configure: (Self) throws -> Void) rethrows -> Self {
        try configure(self)
        return self
    }

    @discardableResult
    public func apply(_ configuration: XConfiguration<Self>) -> Self {
        configuration.configure(self)
        return self
    }

    @discardableResult
    public func apply(_ configurations: [XConfiguration<Self>]) -> Self {
        configurations.forEach {
            $0.configure(self)
        }
        return self
    }
}

// MARK: - Appliable: Array

extension Array where Element: Appliable {
    /// Apply styles using the given closure.
    ///
    /// ```swift
    /// let label = UILabel()
    /// let button = UIButton()
    ///
    /// // later somewhere in the code
    /// [label, button].apply {
    ///     $0.isUserInteractionEnabled = false
    /// }
    ///
    /// // or
    /// let components = [UILabel(), UIButton()].apply {
    ///     $0.isUserInteractionEnabled = false
    /// }
    /// ```
    ///
    /// - Parameter configure: The configuration block to apply.
    @discardableResult
    public func apply(_ configure: (Element) throws -> Void) rethrows -> Array {
        try forEach {
            try $0.apply(configure)
        }

        return self
    }
}

// MARK: - MutableAppliable

/// A protocol that enables types to be configured using closure based API.
public protocol MutableAppliable {}

extension MutableAppliable {
    /// Apply styles using the given closure.
    ///
    /// - Parameter configure: The configuration block to apply.
    @discardableResult
    public func applying(_ configure: (inout Self) throws -> Void) rethrows -> Self {
        var object = self
        try configure(&object)
        return object
    }

    /// Apply styles using the given closure.
    ///
    /// - Parameter configure: The configuration block to apply.
    public mutating func apply(_ configure: (inout Self) throws -> Void) rethrows {
        var object = self
        try configure(&object)
        self = object
    }
}

// MARK: - MutableAppliable: Array

extension Array where Element: MutableAppliable {
    /// Apply styles using the given closure.
    ///
    /// ```swift
    /// let label = UILabel()
    /// let button = UIButton()
    ///
    /// // later somewhere in the code
    /// [label, button].apply {
    ///     $0.isUserInteractionEnabled = false
    /// }
    ///
    /// // or
    /// let components = [UILabel(), UIButton()].apply {
    ///     $0.isUserInteractionEnabled = false
    /// }
    /// ```
    ///
    /// - Parameter configure: The configuration block to apply.
    @discardableResult
    public func applying(_ configure: (inout Element) throws -> Void) rethrows -> Array {
        try forEach {
            try $0.applying(configure)
        }

        return self
    }

    /// Apply styles using the given closure.
    ///
    /// ```swift
    /// let label = UILabel()
    /// let button = UIButton()
    ///
    /// // later somewhere in the code
    /// [label, button].apply {
    ///     $0.isUserInteractionEnabled = false
    /// }
    ///
    /// // or
    /// let components = [UILabel(), UIButton()].apply {
    ///     $0.isUserInteractionEnabled = false
    /// }
    /// ```
    ///
    /// - Parameter configure: The configuration block to apply.
    public mutating func apply(_ configure: (inout Element) throws -> Void) rethrows {
        for var item in self {
            try item.apply(configure)
        }
    }
}

// MARK: - NSObject

extension NSObject: Appliable {}
