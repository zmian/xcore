//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
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

    /// Query value associated with the request.
    ///
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld")!
    /// print(url.queryItem(named: "q")) // "HelloWorld"
    /// ```
    public func queryItem(named name: String) -> String? {
        guard let queryItems = URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems else {
            return nil
        }

        return queryItems.first { $0.name == name }?.value
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

        let urlString = absoluteString.replacing("#\(fragment)", with: "")
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
            rawValue
        }
    }
}

extension URL.Scheme: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
}

extension URL.Scheme {
    public static let none: Self = ""
    public static let https: Self = "https"
    public static let http: Self = "http"
    public static let file: Self = "file"
    public static let tel: Self = "tel"
    public static let sms: Self = "sms"
    public static let email: Self = "mailto"
}
