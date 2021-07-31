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
                let json = decode(url, options: options)
                DispatchQueue.main.async {
                    callback(json)
                }
            }
        } else {
            DispatchQueue.global().async {
                let json = decode(filename: named, options: options)
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
    ///   - options: Options for reading the JSON data.
    /// - Returns: A Foundation object from the JSON data in data, or `nil` if an
    ///   error occurs.
    public static func decode(
        filename: String,
        in bundle: Bundle = .main,
        options: JSONSerialization.ReadingOptions = [.mutableContainers]
    ) -> Any? {
        guard
            let filePath = bundle.path(forResource: filename.deletingPathExtension, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: filePath))
        else {
            return nil
        }

        return decode(data, options: options)
    }

    /// Returns a Foundation object from given url of JSON file.
    ///
    /// - Parameters:
    ///   - url: A url containing JSON file.
    ///   - options: Options for reading the JSON data.
    /// - Returns: A Foundation object from the JSON data in data, or `nil` if an
    ///   error occurs.
    public static func decode(
        _ url: URL,
        options: JSONSerialization.ReadingOptions = [.mutableContainers]
    ) -> Any? {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }

        return decode(data, options: options)
    }

    /// Returns a Foundation object from given JSON string.
    ///
    /// - Parameters:
    ///   - string: A string containing JSON data.
    ///   - options: Options for reading the JSON data.
    /// - Returns: A Foundation object from the JSON data in data, or `nil` if an
    ///   error occurs.
    public static func decode(
        _ string: String,
        options: JSONSerialization.ReadingOptions = [.mutableContainers]
    ) -> Any? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }

        return decode(data, options: options)
    }

    /// Returns a Foundation object from given JSON data.
    ///
    /// - Parameters:
    ///   - data: A data object containing JSON data.
    ///   - options: Options for reading the JSON data.
    /// - Returns: A Foundation object from the JSON data in data, or `nil` if an
    ///   error occurs.
    public static func decode(
        _ data: Data,
        options: JSONSerialization.ReadingOptions = [.mutableContainers]
    ) -> Any? {
        try? JSONSerialization.jsonObject(with: data, options: options)
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
            let data = encode(value, options: options),
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
    ) -> Data? {
        guard JSONSerialization.isValidJSONObject(value) else {
            Console.error("Invalid JSON Object.")
            return nil
        }

        return try? JSONSerialization.data(withJSONObject: value, options: options)
    }
}
