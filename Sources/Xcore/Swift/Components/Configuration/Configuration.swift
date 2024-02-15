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
/// extension XConfiguration where Type: UILabel {
///     static var header: XConfiguration {
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
public struct XConfiguration<Type>: Identifiable {
    public typealias ID = Identifier<Type>
    public let id: ID
    public let configure: (Type) -> Void

    public init(id: ID? = nil, _ configure: @escaping (Type) -> Void) {
        self.id = Self.makeId(id: id)
        self.configure = configure
    }

    public func extend(id: ID? = nil, _ configure: @escaping (Type) -> Void) -> Self {
        .init(id: Self.makeId(id: id)) { type in
            self.configure(type)
            configure(type)
        }
    }

    private static func makeId(id: ID? = nil) -> ID {
        id ?? .init(rawValue: UUID().uuidString)
    }
}

// MARK: - Equatable

extension XConfiguration: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension XConfiguration: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Convenience UIKit Initializers

extension UILabel {
    public convenience init(text: String?, configuration: XConfiguration<UILabel>) {
        self.init()
        self.text = text
        configuration.configure(self)
    }

    public convenience init(text: String, attributes: [NSAttributedString.Key: Any]) {
        self.init()
        attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}

// MARK: - XConfigurationInitializable

public protocol XConfigurationInitializable {}

extension XConfigurationInitializable where Self: UIView {
    public init(configuration: XConfiguration<Self>) {
        self.init()
        configuration.configure(self)
    }
}

extension UIView: XConfigurationInitializable {}
extension UIBarButtonItem: XConfigurationInitializable {}

// MARK: - Built-in

extension XConfiguration {
    public static var none: Self {
        .init(id: #function) { _ in }
    }
}
