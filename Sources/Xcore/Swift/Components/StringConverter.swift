//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct StringConverter: Sendable, Hashable {
    private let string: String

    public init?(_ value: String?) {
        guard let value = value else {
            return nil
        }

        self.string = value
    }

    public init<T: LosslessStringConvertible>(_ value: T) {
        self.string = value.description
    }

    public init?<T>(_ value: T) {
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

        if let value = value as? Date {
            self.string = value.timeIntervalSinceReferenceDate.description
            return
        }

        if let value = value as? URL {
            self.string = value.absoluteString
            return
        }

        if let value = (value as? NSURL)?.absoluteString {
            self.string = value
            return
        }

        if let value = value as? Data, let dataString = String(data: value, encoding: .utf8) {
            self.string = dataString
            return
        }

        return nil
    }

    private var url: URL? {
        URL(string: string)
    }

    private var json: Any? {
        guard !string.isBlank else {
            return nil
        }

        return try? JSONHelpers.decode(string)
    }

    private var nsNumber: NSNumber? {
        let formatter = NumberFormatter().apply {
            $0.numberStyle = .decimal
        }
        return formatter.number(from: string)
    }
}

extension StringConverter {
    public func get<T>(_ type: T.Type = T.self) -> T? {
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
            case is Data.Type, is Optional<Data>.Type:
                return string.data(using: .utf8) as? T
            case is URL.Type, is Optional<URL>.Type:
                return URL(string: string) as? T
            case is NSURL.Type, is Optional<NSURL>.Type:
                return NSURL(string: string) as? T
            case is Date.Type, is Optional<Date>.Type:
                if let double = Double(string) {
                    return Date(timeIntervalSinceReferenceDate: double) as? T
                }

                return nil
            default:
                return json as? T
        }
    }

    public func get<T>() -> T? where T: RawRepresentable, T.RawValue == String {
        T(rawValue: string)
    }
}

// MARK: - JSONDecoder

extension StringConverter {
    /// Returns a value of the type you specify, decoded from an object.
    ///
    /// - Parameters:
    ///   - type: The type of the value to decode from the string.
    ///   - decoder: The decoder used to decode the data. If set to `nil`, it uses
    ///     ``JSONDecoder`` with `convertFromSnakeCase` key decoding strategy.
    /// - Returns: A value of the specified type, if the decoder can parse the data.
    public func get<T>(_ type: T.Type = T.self, decoder: JSONDecoder? = nil) -> T? where T: Decodable {
        guard let data = string.data(using: .utf8) else {
            return nil
        }

        return Self.get(type, from: data, decoder: decoder)
    }

    /// Returns a value of the type you specify, decoded from an object.
    ///
    /// - Parameters:
    ///   - type: The type of the value to decode from the string.
    ///   - decoder: The decoder used to decode the data. If set to `nil`, it uses
    ///     ``JSONDecoder`` with `convertFromSnakeCase` key decoding strategy.
    /// - Returns: A value of the specified type, if the decoder can parse the data.
    static func get<T>(_ type: T.Type = T.self, from data: Data, decoder: JSONDecoder? = nil) -> T? where T: Decodable {
        let decoder = decoder ?? JSONDecoder().apply {
            $0.keyDecodingStrategy = .convertFromSnakeCase
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            #if DEBUG
            if AppInfo.isDebuggerAttached {
                print("Failed to decode \(type):")
                print("---")
                dump(error)
                print("---")
            }
            #endif
            return nil
        }
    }
}
