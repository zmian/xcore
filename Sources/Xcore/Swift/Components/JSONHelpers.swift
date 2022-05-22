//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Namespace

public enum JSONHelpers {}

// MARK: - Decode

extension JSONHelpers {
    /// Automatically detect and load the JSON from local(main bundle) or a remote
    /// url.
    ///
    /// - Parameters:
    ///   - named: A JSON `filename` in `main` bundle or a `url` to JSON file.
    ///   - options: Options for reading the JSON data.
    ///   - callback: A closure invoked when finished decoding JSON.
    public static func decode(
        remoteOrLocalFile named: String,
        options: JSONSerialization.ReadingOptions = [.mutableContainers],
        callback: @escaping ((Any?) -> Void)
    ) {
        if let url = URL(string: named), url.host != nil {
            DispatchQueue.global().async {
                let json = try? decode(url, options: options)
                DispatchQueue.main.async {
                    callback(json)
                }
            }
        } else {
            DispatchQueue.global().async {
                let json = try? decode(filename: named, options: options)
                DispatchQueue.main.async {
                    callback(json)
                }
            }
        }
    }

    /// Returns a Foundation object from given JSON file name.
    ///
    /// - Parameters:
    ///   - filename: A JSON `filename`.
    ///   - bundle: The bundle where JSON file is located.
    ///   - keyPath: The key path to JSON object.
    ///   - options: Options for reading the JSON data.
    /// - Returns: A Foundation object from the JSON data in data, or `nil` if an
    ///   error occurs.
    public static func decode(
        filename: String,
        in bundle: Bundle = .main,
        keyPath: String? = nil,
        options: JSONSerialization.ReadingOptions = [.mutableContainers]
    ) throws -> Any {
        guard let fileUrl = bundle.url(filename: filename) else {
            throw Error.notFound
        }

        return try decode(fileUrl, keyPath: keyPath, options: options)
    }

    /// Returns a Foundation object from given url of JSON file.
    ///
    /// - Parameters:
    ///   - url: A url containing JSON file.
    ///   - keyPath: The key path to JSON object.
    ///   - options: Options for reading the JSON data.
    /// - Returns: A Foundation object from the JSON data in data, or `nil` if an
    ///   error occurs.
    public static func decode(
        _ url: URL,
        keyPath: String? = nil,
        options: JSONSerialization.ReadingOptions = [.mutableContainers]
    ) throws -> Any {
        let data = try Data(contentsOf: url)
        return try decode(data, keyPath: keyPath, options: options)
    }

    /// Returns a Foundation object from given JSON string.
    ///
    /// - Parameters:
    ///   - string: A string containing JSON data.
    ///   - keyPath: The key path to JSON object.
    ///   - options: Options for reading the JSON data.
    /// - Returns: A Foundation object from the JSON data in data, or `nil` if an
    ///   error occurs.
    public static func decode(
        _ string: String,
        keyPath: String? = nil,
        options: JSONSerialization.ReadingOptions = [.mutableContainers]
    ) throws -> Any {
        guard let data = string.data(using: .utf8) else {
            return Error.invalidData
        }

        return try decode(data, keyPath: keyPath, options: options)
    }

    /// Returns a Foundation object from given JSON data.
    ///
    /// - Parameters:
    ///   - data: A data object containing JSON data.
    ///   - keyPath: The key path to JSON object.
    ///   - options: Options for reading the JSON data.
    /// - Returns: A Foundation object from the JSON data in data, or `nil` if an
    ///   error occurs.
    public static func decode(
        _ data: Data,
        keyPath: String? = nil,
        options: JSONSerialization.ReadingOptions = [.mutableContainers]
    ) throws -> Any {
        guard let keyPath = keyPath, !keyPath.isEmpty else {
            return try JSONSerialization.jsonObject(with: data, options: options)
        }

        var options = options
        options.insert(.allowFragments)

        let json = try JSONSerialization.jsonObject(with: data, options: options)

        guard let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) else {
            throw Error.invalidKeyPath
        }

        guard JSONSerialization.isValidJSONObject(nestedJson) else {
            throw Error.invalidJSON
        }

        return nestedJson
    }

    /// Returns a Data object at the specified key path from given JSON data.
    ///
    /// - Parameters:
    ///   - data: A data object containing JSON data.
    ///   - keyPath: The key path to JSON object.
    ///   - options: Options for reading the JSON data.
    /// - Returns: A Foundation object from the JSON data in data, or `nil` if an
    ///   error occurs.
    public static func decodeData(
        _ data: Data,
        keyPath: String?,
        options: JSONSerialization.ReadingOptions = [.mutableContainers]
    ) throws -> Data {
        guard let keyPath = keyPath, !keyPath.isEmpty else {
            // Return `Data` without any transformation.
            return data
        }

        return try JSONSerialization.data(
            withJSONObject: try decode(data, keyPath: keyPath, options: options)
        )
    }
}

// MARK: - Encode

extension JSONHelpers {
    /// Returns a JSON-encoded string representation of the `value`.
    ///
    /// - Parameters:
    ///   - value: The object from which to generate JSON data.
    ///   - options: Options for creating the JSON data.
    /// - Returns: JSON data for value, or `nil` if an error occurs. The resulting
    ///   data is encoded in UTF-8.
    public static func stringify(
        _ value: Any,
        options: JSONSerialization.WritingOptions = [.sortedKeys]
    ) -> String {
        guard
            let data = try? encode(value, options: options),
            let string = String(data: data, encoding: .utf8)
        else {
            return ""
        }

        return string
    }

    /// Returns a JSON-encoded representation of the `value`.
    ///
    /// - Parameters:
    ///   - value: The object from which to generate JSON data.
    ///   - options: Options for creating the JSON data.
    /// - Returns: JSON data for value, or `nil` if an error occurs. The resulting
    ///   data is encoded in UTF-8.
    public static func encode(
        _ value: Any,
        options: JSONSerialization.WritingOptions = [.sortedKeys]
    ) throws -> Data {
        guard JSONSerialization.isValidJSONObject(value) else {
            throw Error.invalidJSON
        }

        return try JSONSerialization.data(withJSONObject: value, options: options)
    }
}

// MARK: - Error

extension JSONHelpers {
    private enum Error: Swift.Error {
        case notFound
        case invalidData
        case invalidKeyPath
        case invalidJSON
    }
}
