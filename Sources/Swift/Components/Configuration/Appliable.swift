//
// Appliable.swift
//
// Copyright © 2017 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

// MARK: - Appliable

public protocol Appliable {}

extension Appliable {
    /// A convenience function to apply styles using block based api.
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
    public func apply(_ configuration: Configuration<Self>) -> Self {
        configuration.configure(self)
        return self
    }

    @discardableResult
    public func apply(_ configurations: [Configuration<Self>]) -> Self {
        configurations.forEach {
            $0.configure(self)
        }
        return self
    }
}

// MARK: - Appliable: Array

extension Array where Element: Appliable {
    /// A convenience function to apply styles using block based api.
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

public protocol MutableAppliable {}

extension MutableAppliable {
    /// A convenience function to apply styles using block based api.
    ///
    /// - Parameter configure: The configuration block to apply.
    @discardableResult
    public func applying(_ configure: (inout Self) throws -> Void) rethrows -> Self {
        var object = self
        try configure(&object)
        return object
    }

    /// A convenience function to apply styles using block based api.
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
    /// A convenience function to apply styles using block based api.
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

    /// A convenience function to apply styles using block based api.
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

extension NSObject: Appliable { }
