//
// XCConfiguration.swift
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

import UIKit

/// A configuration pattern generic implementation.
///
/// Simple and powerful way to extend any type to support configuration driven
/// views.
///
/// **Style Declaration**
///
/// ```swift
/// extension XCConfiguration where Type: UILabel {
///     static func app(text: String? = nil, font: UIFont? = nil, textColor: UIColor? = nil, numberOfLines: Int? = nil, alignment: NSTextAlignment? = nil) -> XCConfiguration {
///         return XCConfiguration { label in
///             label.text = text
///             label.font = font ?? .systemFont(.subheadline)
///             label.textColor = textColor ?? .black
///             label.numberOfLines = numberOfLines ?? 0
///             label.textAlignment = alignment ?? .left
///         }
///     }
///
///     static var header: XCConfiguration {
///         return .app(font: .systemFont(.title1), textColor: .blue)
///     }
/// }
/// ```
///
/// **Usage**
///
/// ```swift
/// let headerLabel = UILabel(style: .header)
/// ```
public struct XCConfiguration<Type> {
    public let id: Identifier<Type>
    private let _configure: ((Type) -> Void)

    public init(id: Identifier<Type>? = nil, _ configure: @escaping ((Type) -> Void)) {
        self.id = id ?? "___defaultId___"
        self._configure = configure
    }

    public func extend(id: Identifier<Type>? = nil, _ configure: @escaping ((Type) -> Void)) -> XCConfiguration<Type> {
        return XCConfiguration(id: id) { type in
            self.configure(type)
            configure(type)
        }
    }

    public func configure(_ type: Type) {
        self._configure(type)
    }
}

extension XCConfiguration: Equatable {
    public static func ==(lhs: XCConfiguration, rhs: XCConfiguration) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Convenience UIKit Initializers

extension UILabel {
    public convenience init(style: XCConfiguration<UILabel>, text: String?) {
        self.init()
        self.text = text
        style.configure(self)
    }

    public convenience init(text: String, attributes: [NSAttributedString.Key: Any]) {
        self.init()
        attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}

// MARK: - Stylable

public protocol Stylable { }

extension Stylable where Self: UIView {
    public init(style: XCConfiguration<Self>) {
        self.init()
        style.configure(self)
    }
}

extension UIView: Stylable { }
extension UIBarButtonItem: Stylable { }

extension TargetActionBlockRepresentable where Self: UIBarButtonItem {
    public init(style: XCConfiguration<Self>, _ handler: ((_ sender: Self) -> Void)? = nil) {
        self.init()
        style.configure(self)
        guard let handler = handler else { return }
        addAction(handler)
    }
}

// MARK: - With

public protocol With {}

extension With {
    public func apply(style: XCConfiguration<Self>) {
        style.configure(self)
    }

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
}

extension Array where Element: With {
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

extension NSObject: With { }
