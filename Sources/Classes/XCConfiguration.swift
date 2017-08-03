//
// XCConfiguration.swift
//
// Copyright © 2017 Zeeshan Mian
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
/// Simple and powerful way to extend any type to support
/// configuration driven views.
///
/// **Style Declaration**
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
/// **Usage**
/// ```swift
/// let headerLabel = UILabel(style: .header)
/// ```
public struct XCConfiguration<Type> {
    public var identifier: String
    public var configure: ((Type) -> Void)?

    public init(identifier: String? = nil, _ configure: ((Type) -> Void)?) {
        self.identifier = identifier ?? "_defaultIdentifier_"
        self.configure = configure
    }

    public func extend(identifier: String? = nil, _ configure: ((Type) -> Void)?) -> XCConfiguration<Type> {
        return XCConfiguration(identifier: identifier) { type in
            self.configure?(type)
            configure?(type)
        }
    }
}

extension XCConfiguration: Equatable {
    public static func ==(lhs: XCConfiguration, rhs: XCConfiguration) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension UILabel {
    public convenience init(text: String? = nil, style: XCConfiguration<UILabel>) {
        self.init()
        self.text = text
        style.configure?(self)
    }

    public convenience init(text: String, attributes: [String: AnyObject]) {
        self.init()
        attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
