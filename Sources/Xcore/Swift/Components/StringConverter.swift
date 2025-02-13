//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import OSLog

/// A utility for converting values to a string and then converting the stored
/// string back into a target type.
///
/// This type encapsulates a string representation of an input value. It
/// supports common types like String, Bool, Int, Double, Date, URL, and Data.
/// Use the generic initializer to create an instance and the `get()` method
/// to convert the stored string to the desired type.
///
/// **Usage**
///
/// ```swift
/// // Create a converter from an Int.
/// if let converter = StringConverter(42) {
///     // Convert the stored string back to an Int.
///     let value: Int? = converter.get()
///     print(value) // Optional(42)
/// }
///
/// // Create a converter from a Date.
/// if let converter = StringConverter(Date()) {
///     // Try to decode the stored date string back to a Date.
///     let value: Date? = converter.get()
///     print(value)
/// }
/// ```
public struct StringConverter: Sendable, Hashable {
    private let string: String

    /// Creates a `StringConverter` from given value.
    public init<T: LosslessStringConvertible>(_ value: T) {
        self.string = value.description
    }

    /// Optionally creates a `StringConverter` from an optional value.
    ///
    /// The initializer converts the input into a string using various
    /// strategies depending on the type:
    /// - For values conforming to `LosslessStringConvertible`, uses `description`.
    /// - For `Data`, attempts to decode as UTF-8.
    /// - For `Date`, uses an ISO 8601 representation.
    /// - For `URL`, uses `absoluteString`.
    ///
    /// - Parameter value: The value to convert.
    public init?<T>(_ value: T?) {
        guard let value else {
            return nil
        }

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

    /// The URL constructed from the string, or `nil` if the string is not a valid
    /// URL.
    private var url: URL? {
        let url = URL(string: string)
        // Checks to ensure arbitrary strings are not considered valid URLs
        // (e.g., URL(string: "hello world")).
        return url?.scheme == nil ? nil : url
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
                return Data(string.utf8) as? T
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

    public func get<T: RawRepresentable<String>>() -> T? {
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
    public func get<T: Decodable>(_ type: T.Type = T.self, decoder: JSONDecoder? = nil) -> T? {
        let decoder = decoder ?? JSONDecoder().apply {
            $0.keyDecodingStrategy = .convertFromSnakeCase
        }

        do {
            return try decoder.decode(T.self, from: Data(string.utf8))
        } catch {
            #if DEBUG
            if AppInfo.isDebuggerAttached {
                Logger.xc.error("Failed to decode \(type, privacy: .public):\n \(dump(error), privacy: .public)")
            }
            #endif
            return nil
        }
    }
}
