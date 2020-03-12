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
            case .string(let value):
                return value
            case .attributedString(let value):
                return value.string
        }
    }
}

// MARK: - StringRepresentable

public protocol StringRepresentable {
    var stringSource: StringSourceType { get }
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

public protocol TextAttributedTextRepresentable: class {
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

        accessibilityLabel = String(describing: string.stringSource)

        switch string.stringSource {
            case .string(let string):
                text = string
            case .attributedString(let attributedString):
                attributedText = attributedString
        }
    }
}

extension TextAttributedTextRepresentable where Self: UIView {
    public func setText(_ string: StringRepresentable?, animated: Bool, duration: TimeInterval = .slow, completion: (() -> Void)? = nil) {
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

// MARK: - TextAttributedTextRepresentable.Conformance

extension UILabel: TextAttributedTextRepresentable { }
extension UIButton: TextAttributedTextRepresentable { }
extension UITextField: TextAttributedTextRepresentable { }
extension UITextView {
    public func setText(_ string: StringRepresentable?) {
        guard let string = string else {
            text = nil
            attributedText = nil
            accessibilityLabel = nil
            return
        }

        switch string.stringSource {
            case .string(let string):
                text = string
            case .attributedString(let attributedString):
                attributedText = attributedString
        }
    }
}
