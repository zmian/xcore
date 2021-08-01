//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
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
///             $0.font = .app(.title1)
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
    private let _configure: (Type) -> Void

    public init(id: Identifier? = nil, _ configure: @escaping ((Type) -> Void)) {
        self.id = id ?? "___defaultId___"
        self._configure = configure
    }

    public func extend(id: Identifier? = nil, _ configure: @escaping ((Type) -> Void)) -> Self {
        .init(id: id ?? self.id) { type in
            self.configure(type)
            configure(type)
        }
    }

    public func configure(_ type: Type) {
        self._configure(type)
    }
}

// MARK: - Equatable

extension Configuration: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension Configuration: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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

public protocol ConfigurationInitializable {}

extension ConfigurationInitializable where Self: UIView {
    public init(configuration: Configuration<Self>) {
        self.init()
        configuration.configure(self)
    }
}

extension UIView: ConfigurationInitializable {}
extension UIBarButtonItem: ConfigurationInitializable {}

extension TargetActionBlockRepresentable where Self: UIBarButtonItem {
    public init(configuration: Configuration<Self>, _ handler: ((_ sender: Self) -> Void)? = nil) {
        self.init()
        configuration.configure(self)
        guard let handler = handler else { return }
        addAction(handler)
    }
}

// MARK: - Built-in

extension Configuration {
    public static var none: Self {
        .init(id: #function) { _ in }
    }
}
