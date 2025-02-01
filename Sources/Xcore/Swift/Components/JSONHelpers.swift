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
    /// Automatically detects and loads JSON from either a local file (main bundle) or a remote URL.
    ///
    /// - Parameters:
    ///   - source: A JSON filename in the `main` bundle or a `URL` string.
    ///   - options: Options for reading the JSON data.
    /// - Returns: A decoded JSON object.
    public static func decode(
        from source: String,
        options: JSONSerialization.ReadingOptions = [.mutableContainers]
    ) throws -> Any {
        if let url = URL(string: source), url.host != nil {
            return try decode(url: url, options: options)
        } else {
            return try decode(filename: source, options: options)
        }
    }

    /// Returns a Foundation object from a given JSON filename in the specified bundle.
    ///
    /// - Parameters:
    ///   - filename: The JSON filename.
    ///   - bundle: The bundle where the JSON file is located.
    ///   - keyPath: The key path to extract a nested JSON object.
    ///   - options: Options for reading the JSON data.
    /// - Returns: A Foundation object from the JSON file.
    public static func decode(
        filename: String,
        in bundle: Bundle = .main,
        keyPath: String? = nil,
        options: JSONSerialization.ReadingOptions = [.mutableContainers]
    ) throws -> Any {
        guard let fileUrl = bundle.url(filename: filename) else {
            throw JSONError.notFound
        }

        return try decode(url: fileUrl, keyPath: keyPath, options: options)
    }

    /// Returns a Foundation object from a given JSON file URL.
    ///
    /// - Parameters:
    ///   - url: The URL containing JSON data.
    ///   - keyPath: The key path to extract a nested JSON object.
    ///   - options: Options for reading the JSON data.
    /// - Returns: A Foundation object from the JSON file.
    public static func decode(
        url: URL,
        keyPath: String? = nil,
        options: JSONSerialization.ReadingOptions = [.mutableContainers]
    ) throws -> Any {
        let data = try Data(contentsOf: url)
        return try decode(data: data, keyPath: keyPath, options: options)
    }

    /// Returns a Foundation object from a given JSON string.
    ///
    /// - Parameters:
    ///   - string: A string containing JSON data.
    ///   - keyPath: The key path to extract a nested JSON object.
    ///   - options: Options for reading the JSON data.
    /// - Returns: A Foundation object from the JSON string.
    public static func decode(
        string: String,
        keyPath: String? = nil,
        options: JSONSerialization.ReadingOptions = [.mutableContainers]
    ) throws -> Any {
        guard let data = string.data(using: .utf8) else {
            throw JSONError.invalidData
        }

        return try decode(data: data, keyPath: keyPath, options: options)
    }

    /// Returns a Foundation object from given JSON data.
    ///
    /// - Parameters:
    ///   - data: The `Data` object containing JSON.
    ///   - keyPath: The key path to extract a nested JSON object.
    ///   - options: Options for reading the JSON data.
    /// - Returns: A Foundation object from the JSON data.
    public static func decode(
        data: Data,
        keyPath: String? = nil,
        options: JSONSerialization.ReadingOptions = [.mutableContainers]
    ) throws -> Any {
        var options = options
        options.insert(.allowFragments)

        let json = try JSONSerialization.jsonObject(with: data, options: options)

        guard let keyPath, !keyPath.isEmpty else {
            return json
        }

        guard let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) else {
            throw JSONError.invalidKeyPath
        }

        guard JSONSerialization.isValidJSONObject(nestedJson) else {
            throw JSONError.invalidJSON
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
        guard let keyPath, !keyPath.isEmpty else {
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
    /// Returns a JSON-encoded string representation of the given value.
    ///
    /// - Parameters:
    ///   - value: The object to encode into JSON.
    ///   - options: Options for creating the JSON data.
    /// - Returns: A JSON string or `nil` if encoding fails.
    public static func encodeToString(
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

    /// Returns a JSON-encoded representation of the given value.
    ///
    /// - Parameters:
    ///   - value: The object to encode into JSON.
    ///   - options: Options for creating the JSON data.
    /// - Returns: JSON data for value, or `nil` if an error occurs. The resulting
    ///   data is encoded in UTF-8.
    public static func encode(
        _ value: Any,
        options: JSONSerialization.WritingOptions = [.sortedKeys]
    ) throws -> Data {
        guard JSONSerialization.isValidJSONObject(value) else {
            throw JSONError.invalidJSON
        }

        return try JSONSerialization.data(withJSONObject: value, options: options)
    }
}

// MARK: - Error Handling

extension JSONHelpers {
    /// Represents possible JSON-related errors.
    private enum JSONError: Error {
        case notFound
        case invalidData
        case invalidKeyPath
        case invalidJSON
    }
}
