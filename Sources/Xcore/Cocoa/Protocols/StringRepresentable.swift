//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - StringSourceType

public enum StringSourceType: Equatable, CustomStringConvertible {
    case string(String)
    case attributedString(NSAttributedString)

    public var description: String {
        switch self {
            case let .string(value):
                return value
            case let .attributedString(value):
                return value.string
        }
    }
}

// MARK: - StringSourceType: Codable

extension StringSourceType: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = .string(value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case let .string(value):
                try container.encode(value)
            case let .attributedString(value):
                try container.encode(value.string)
        }
    }
}

// MARK: - StringRepresentable

public protocol StringRepresentable {
    var stringSource: StringSourceType { get }
}

// MARK: - StringRepresentable: Equatable

extension StringRepresentable {
    public func isEqual(_ other: StringRepresentable) -> Bool {
        stringSource == other.stringSource
    }
}

extension Optional where Wrapped == StringRepresentable {
    public func isEqual(_ other: StringRepresentable?) -> Bool {
        switch self {
            case .none:
                return other == nil
            case let .some(this):
                guard let other = other else {
                    return false
                }

                return this.isEqual(other)
        }
    }

    public func isEqual(_ other: StringRepresentable) -> Bool {
        switch self {
            case .none:
                return false
            case let .some(this):
                return this.isEqual(other)
        }
    }
}

// MARK: - Conformance

extension String: StringRepresentable {
    public var stringSource: StringSourceType {
        .string(self)
    }
}

extension NSString: StringRepresentable {
    public var stringSource: StringSourceType {
        .string(self as String)
    }
}

extension NSAttributedString: StringRepresentable {
    public var stringSource: StringSourceType {
        .attributedString(self)
    }
}

// MARK: - TextAttributedTextRepresentable

public protocol TextAttributedTextRepresentable: AnyObject {
    var text: String? { get set }
    var attributedText: NSAttributedString? { get set }
    func setText(_ string: StringRepresentable?)
    var hasText: Bool { get }
    var accessibilityLabel: String? { get set }
}

extension TextAttributedTextRepresentable {
    public var hasText: Bool {
        text != nil || attributedText != nil
    }

    public func setText(_ string: StringRepresentable?) {
        guard let string = string else {
            text = nil
            attributedText = nil
            accessibilityLabel = nil
            return
        }

        if let moneyString = string as? Money {
            accessibilityLabel = moneyString.accessibilityLabel
        } else {
            accessibilityLabel = String(describing: string.stringSource)
        }

        switch string.stringSource {
            case let .string(string):
                text = string
            case let .attributedString(attributedString):
                attributedText = attributedString
        }
    }
}

extension TextAttributedTextRepresentable where Self: UIView {
    public func setText(
        _ string: StringRepresentable?,
        animated: Bool,
        duration: TimeInterval = .slow,
        completion: (() -> Void)? = nil
    ) {
        guard animated else {
            setText(string)
            return
        }

        UIView.transition(
            with: self,
            duration: duration,
            options: [.beginFromCurrentState, .transitionCrossDissolve],
            animations: { [weak self] in
                self?.setText(string)
            },
            completion: { _ in
                completion?()
            }
        )
    }
}

// MARK: - TextAttributedTextRepresentable Conformance

extension UILabel: TextAttributedTextRepresentable {}
extension UIButton: TextAttributedTextRepresentable {}
extension UITextField: TextAttributedTextRepresentable {}
extension UITextView {
    public func setText(_ string: StringRepresentable?) {
        guard let string = string else {
            text = nil
            attributedText = nil
            accessibilityLabel = nil
            return
        }

        switch string.stringSource {
            case let .string(string):
                text = string
            case let .attributedString(attributedString):
                attributedText = attributedString
        }
    }
}
