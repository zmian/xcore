//
// StringConverter.swift
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

public struct StringConverter {
    private let string: String

    public init<T: LosslessStringConvertible>(_ value: T) {
        self.string = value.description
    }

    public init?(_ value: Any) {
        if let value = value as? LosslessStringConvertible {
            self.string = value.description
            return
        }

        // Captures NSString
        if let value = value as? String {
            self.string = value
            return
        }

        if let value = value as? NSNumber {
            self.string = value.stringValue
            return
        }

        return nil
    }

    private var url: URL? {
        guard let url = URL(string: string) else {
            return nil
        }

        return url
    }

    private var json: Any? {
        guard !string.isBlank else {
            return nil
        }

        return JSONHelpers.parse(jsonString: string)
    }

    private var nsNumber: NSNumber? {
        let formatter = NumberFormatter().apply {
            $0.numberStyle = .decimal
        }
        return formatter.number(from: string)
    }
}

extension StringConverter {
    public func get<T>() -> T? {
        switch T.self {
            case is String.Type, is Optional<String>.Type:
                return string as? T
            case is Bool.Type, is Optional<Bool>.Type:
                return Bool(string) as? T
            case is Double.Type, is Optional<Double>.Type:
                return Double(string) as? T
            case is Float.Type, is Optional<Float>.Type:
                return Float(string) as? T
            case is Int.Type, is Optional<Int>.Type:
                return Int(string) as? T
            case is URL.Type, is Optional<URL>.Type:
                return url as? T
            case is NSNumber.Type, is Optional<NSNumber>.Type:
                return nsNumber as? T
            case is NSString.Type, is Optional<NSString>.Type:
                return string as? T
            default:
                return json as? T
        }
    }

    public func get<T>() -> T? where T: RawRepresentable, T.RawValue == String {
        return T(rawValue: string)
    }
}
