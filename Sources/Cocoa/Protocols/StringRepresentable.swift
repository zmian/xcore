//
// StringRepresentable.swift
//
// Copyright © 2015 Zeeshan Mian
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

public enum StringSourceType {
    case string(String)
    case attributedString(NSAttributedString)

    public var rawValue: String {
        switch self {
            case .string(let value):
                return value
            case .attributedString(let value):
                return value.string
        }
    }
}

// MARK: StringRepresentable

public protocol StringRepresentable {
    var stringSource: StringSourceType { get }
}

extension String: StringRepresentable {
    public var stringSource: StringSourceType {
        return .string(self)
    }
}

extension NSAttributedString: StringRepresentable {
    public var stringSource: StringSourceType {
        return .attributedString(self)
    }
}

// MARK: TextAttributedTextRepresentable

public protocol TextAttributedTextRepresentable: class {
    var text: String? { get set }
    var attributedText: NSAttributedString? { get set }
    func setText(_ string: StringRepresentable?)
    var hasText: Bool { get }
}

extension TextAttributedTextRepresentable {
    public var hasText: Bool {
        return text != nil || attributedText != nil
    }

    public func setText(_ string: StringRepresentable?) {
        guard let string = string else {
            text = nil
            attributedText = nil
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

extension TextAttributedTextRepresentable where Self: UIView {
    public func setText(_ string: StringRepresentable?, animated: Bool, duration: TimeInterval = .slow, completion: (() -> Void)? = nil) {
        guard animated else {
            setText(string)
            return
        }

        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.setText(string)
        }, completion: { _ in
            completion?()
        })
    }
}

extension UILabel: TextAttributedTextRepresentable { }
extension UIButton: TextAttributedTextRepresentable { }
extension UITextField: TextAttributedTextRepresentable { }
extension UITextView {
    public func setText(_ string: StringRepresentable?) {
        guard let string = string else {
            text = nil
            attributedText = nil
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
