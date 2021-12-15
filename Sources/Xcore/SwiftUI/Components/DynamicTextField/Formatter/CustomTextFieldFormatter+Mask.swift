//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public protocol Mask {
    var maskFormat: String { get set }
    func string(from value: String) -> String
    func value(from string: String) -> String
}

extension Mask {
    public func string(from value: String) -> String {
        let sanitizedValue = value.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
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
    public init () {}
}

public struct SSNMask: Mask {
    public var maskFormat: String = "###-##-####"
    public init () {}
}

// MARK: - Dot Syntax Support

extension Mask where Self == PhoneNumberMask {
    public static var phoneNumber: Self { Self() }
}

extension Mask where Self == SSNMask {
    public static var ssn: Self { Self() }
}

