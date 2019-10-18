//
// Configuration.swift
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
/// **Configuration Declaration**
///
/// ```swift
/// extension Configuration where Type: UILabel {
///     static var header: Configuration {
///         .init(id: #function) {
///             $0.font = .app(style: .title1)
///             $0.textColor = Theme.current.textColor
///             $0.numberOfLines = 0
///         }
///     }
/// }
/// ```
///
/// **Usage**
///
/// ```swift
/// let headerLabel = UILabel(configuration: .header)
/// ```
public struct Configuration<Type> {
    public typealias Identifier = Xcore.Identifier<Type>
    public let id: Identifier
    private let _configure: ((Type) -> Void)

    public init(id: Identifier? = nil, _ configure: @escaping ((Type) -> Void)) {
        self.id = id ?? "___defaultId___"
        self._configure = configure
    }

    public func extend(id: Identifier? = nil, _ configure: @escaping ((Type) -> Void)) -> Self {
        .init(id: id) { type in
            self.configure(type)
            configure(type)
        }
    }

    public func configure(_ type: Type) {
        self._configure(type)
    }
}

extension Configuration: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Convenience UIKit Initializers

extension UILabel {
    public convenience init(text: String?, configuration: Configuration<UILabel>) {
        self.init()
        self.text = text
        configuration.configure(self)
    }

    public convenience init(text: String, attributes: [NSAttributedString.Key: Any]) {
        self.init()
        attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}

// MARK: - ConfigurationInitializable

public protocol ConfigurationInitializable { }

extension ConfigurationInitializable where Self: UIView {
    public init(configuration: Configuration<Self>) {
        self.init()
        configuration.configure(self)
    }
}

extension UIView: ConfigurationInitializable { }
extension UIBarButtonItem: ConfigurationInitializable { }

extension TargetActionBlockRepresentable where Self: UIBarButtonItem {
    public init(configuration: Configuration<Self>, _ handler: ((_ sender: Self) -> Void)? = nil) {
        self.init()
        configuration.configure(self)
        guard let handler = handler else { return }
        addAction(handler)
    }
}
