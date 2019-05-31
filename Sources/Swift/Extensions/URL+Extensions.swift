//
// URL+Extensions.swift
//
// Copyright © 2016 Xcore
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

extension URL {
    public init?(string: String, queryParameters: [String: String]) {
        var components = URLComponents(string: string)
        components?.queryItems = queryParameters.map(URLQueryItem.init)

        guard let string = components?.url?.absoluteString else {
            return nil
        }

        self.init(string: string)
    }
}

extension URL {
    /// Returns a URL constructed by removing the fragment from self.
    ///
    /// If the URL has no fragment (e.g., `http://www.example.com`),
    /// then this function will return the URL unchanged.
    public func deletingFragment() -> URL {
        guard let fragment = fragment else {
            return self
        }

        let urlString = absoluteString.replace("#\(fragment)", with: "")
        return URL(string: urlString) ?? self
    }
}

// MARK: - Scheme

extension URL {
    /// The scheme of the `URL`.
    public var schemeType: Scheme {
        guard let scheme = scheme else {
            return .none
        }

        return Scheme(rawValue: scheme)
    }
}

extension URL {
    public struct Scheme: RawRepresentable, Hashable, CustomStringConvertible {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public var description: String {
            return rawValue
        }
    }
}

extension URL.Scheme: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
}

extension URL.Scheme {
    public static let none: URL.Scheme = ""
    public static let https: URL.Scheme = "https"
    public static let http: URL.Scheme = "http"
    public static let file: URL.Scheme = "file"
    public static let tel: URL.Scheme = "tel"
    public static let sms: URL.Scheme = "sms"
    public static let email: URL.Scheme = "mailto"
}
