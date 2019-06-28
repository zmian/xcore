//
// FeatureFlag+Value.swift
//
// Copyright © 2019 Xcore
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

import Foundation

extension FeatureFlag {
    public struct Value {
        public let string: String?
        public let number: NSNumber?
        public let bool: Bool

        public init(
            string: String?,
            number: NSNumber?,
            bool: Bool
        ) {
            self.string = string
            self.number = number
            self.bool = bool
        }
    }
}

extension FeatureFlag.Value {
    public var url: URL? {
        guard
            let string = string,
            let url = URL(string: string)
        else {
            return nil
        }

        return url
    }

    public var json: Any? {
        guard let jsonString = string, !jsonString.isBlank else {
            return nil
        }

        return JSONHelpers.parse(jsonString: jsonString)
    }

    public var array: [Any] {
        return json as? [Any] ?? []
    }

    public var dictionary: [String: Any] {
        return json as? [String: Any] ?? [:]
    }
}

extension FeatureFlag.Value {
    public func get<T>() -> T? {
        switch T.self {
            case is String.Type, is Optional<String>.Type:
                return string as? T
            case is Bool.Type, is Optional<Bool>.Type:
                return bool as? T
            case is Double.Type, is Optional<Double>.Type:
                return number?.doubleValue as? T
            case is Float.Type, is Optional<Float>.Type:
                return number?.floatValue as? T
            case is Int.Type, is Optional<Int>.Type:
                return number?.intValue as? T
            case is URL.Type, is Optional<URL>.Type:
                return url as? T
            case is NSNumber.Type, is Optional<NSNumber>.Type:
                return number as? T
            default:
                return json as? T
        }
    }

    public func get<T>() -> T? where T: RawRepresentable, T.RawValue == String {
        guard let value = string else {
            return nil
        }

        return T(rawValue: value)
    }
}
