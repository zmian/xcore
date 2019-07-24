//
// Data+Extensions.swift
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

extension Data {
    /// A convenience method to append string to `Data` using specified encoding.
    ///
    /// - Parameters:
    ///   - string:               The string to be added to the `Data`.
    ///   - encoding:             The encoding to use for representing the specified string. The default value is `.utf8`.
    ///   - allowLossyConversion: A boolean value to determine lossy conversion. The default value is `false`.
    public mutating func append(_ string: String, encoding: String.Encoding = .utf8, allowLossyConversion: Bool = false) {
        guard let newData = string.data(using: encoding, allowLossyConversion: allowLossyConversion) else { return }
        append(newData)
    }
}

extension Data {
    public struct HexEncodingOptions: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Includes `spaces` and `<>` symbols.
        public static let raw = HexEncodingOptions(rawValue: 1 << 0)
        public static let uppercase = HexEncodingOptions(rawValue: 1 << 1)
    }

    /// Returns hexadecimal representation of `self`.
    ///
    /// - Parameter options: The options to use for the encoding. The default value
    ///                      is `[]`.
    /// - Returns: The hexadecimal encoded string.
    public func hexEncodedString(options: HexEncodingOptions = []) -> String {
        if options.contains(.raw) {
            return String(format: "%@", self as CVarArg)
        }

        let format = options.contains(.uppercase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
