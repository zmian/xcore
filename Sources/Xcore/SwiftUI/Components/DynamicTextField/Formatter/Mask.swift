//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public protocol Mask {
    var maskFormat: String { get set }
    func transformString(_ value: String) -> String
    func string(from value: String) -> String
    func value(from string: String) -> String
}

extension Mask {
    public func transformString(_ value: String) -> String { value }

    public func string(from value: String) -> String {
        let sanitizedValue = transformString(value.components(separatedBy: .decimalDigits.inverted).joined())
        let mask = maskFormat
        var result = ""
        var index = sanitizedValue.startIndex

        for ch in mask where index < sanitizedValue.endIndex {
            if ch == "#" {
                result.append(sanitizedValue[index])
                index = sanitizedValue.index(after: index)
            } else {
                result.append(ch)
            }
        }

        return result
    }

    public func value(from string: String) -> String {
        string.replacing("-", with: "")
    }
}

public struct PhoneNumberMask: Mask {
    public var maskFormat: String = "###-###-####"

    /// Remove country indicative
    /// TODO: We can make this function smarter by making it parse any contry code and remove it.
    public func transformString(_ value: String) -> String {
        value.count > 10 && value.hasPrefix("1") ? value.droppingPrefix("1") : value
    }

    public init () {}
}

public struct SSNMask: Mask {
    public var maskFormat: String = "###-##-####"
    public init () {}
}

// MARK: - Dot Syntax Support

extension Mask where Self == PhoneNumberMask {
    public static var phoneNumber: Self { .init() }
}

extension Mask where Self == SSNMask {
    public static var ssn: Self { .init() }
}
