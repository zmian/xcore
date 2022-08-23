//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct KeyPathRepresentation: Hashable, Sendable {
    public let rawValue: String
    public let separator: String

    public init(_ rawValue: String, separator: String = ".") {
        self.rawValue = rawValue
        self.separator = separator
    }
}

extension KeyPathRepresentation: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

extension KeyPathRepresentation: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension KeyPathRepresentation: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        rawValue
    }
}
