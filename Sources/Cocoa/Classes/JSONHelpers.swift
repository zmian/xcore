//
// JSONHelpers.swift
//
// Copyright © 2014 Xcore
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

public struct JSONHelpers {
    /// Automatically detect and load the JSON from local(mainBundle) or a remote url.
    public static func remoteOrLocalJSONFile(_ named: String, callback: @escaping ((Any?) -> Void)) {
        if let url = URL(string: named), url.host != nil {
            DispatchQueue.global().async {
                let json = self.parse(url)
                DispatchQueue.main.async {
                    callback(json)
                }
            }
        } else {
            DispatchQueue.global().async {
                let json = self.parse(fileName: named)
                DispatchQueue.main.async {
                    callback(json)
                }
            }
        }
    }

    /// Parse local JSON file from `Bundle.main`.
    public static func parse(fileName: String, bundle: Bundle = .main) -> Any? {
        guard
            let filePath = bundle.path(forResource: fileName.deletingPathExtension, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: filePath))
        else {
            return nil
        }

        return parse(data)
    }

    /// Parse remote JSON file.
    public static func parse(_ url: URL) -> Any? {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }

        return parse(data)
    }

    /// Parse Data to JSON.
    public static func parse(_ data: Data) -> Any? {
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }

    /// Parse String to JSON.
    public static func parse(jsonString: String) -> Any? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }

        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }

    /// Convert value to a JSON string.
    public static func stringify(_ value: Any, prettyPrinted: Bool = false) -> String {
        guard
            let data = serialize(value, prettyPrinted: prettyPrinted),
            let string = String(data: data, encoding: .utf8)
        else {
            return ""
        }

        return string
    }

    /// Serialize value to `Data`.
    public static func serialize(_ value: Any, prettyPrinted: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(value) else {
            Console.error("Invalid JSON Object.")
            return nil
        }

        var options: JSONSerialization.WritingOptions = .sortedKeys

        if prettyPrinted {
            options.insert(.prettyPrinted)
        }

        return try? JSONSerialization.data(withJSONObject: value, options: options)
    }
}
