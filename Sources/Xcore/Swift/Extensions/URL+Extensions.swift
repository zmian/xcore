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
    public func removingFragment() -> URL {
        guard let fragment = fragment else {
            return self
        }

        let urlString = absoluteString.replacing("#\(fragment)", with: "")
        return URL(string: urlString) ?? self
    }

    /// Returns string representation of the URL without scheme if present;
    /// otherwise, `absoluteString`.
    public func removingScheme() -> String {
        guard
            scheme != nil,
            let resource = (self as NSURL).resourceSpecifier
        else {
            return absoluteString
        }

        return String(resource.dropFirst(2))
    }
}

// MARK: - Matches

extension URL {
    /// A boolean property indicating whether the url's host matches given domain.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let url = URL(string: "https://www.example.com")!
    /// print(url.matches("example.com")) // true
    /// print(url.matches("example.org")) // false
    ///
    /// let url = URL(string: "https://api.example.com")!
    /// print(url.matches("example.com")) // true
    /// print(url.matches("example.com", includingSubdomains: false)) // false
    /// ```
    ///
    /// - Parameters:
    ///   - domain: The domain name to evaluate against the `host` property.
    ///   - includingSubdomains: A property to indicate if `domain` doesn't match,
    ///     attempt to evaluate subdomains against the `host` property to find a
    ///     match.
    /// - Returns: `true` if matches; otherwise, `false`.
    public func matches(_ domain: String, includingSubdomains: Bool = true) -> Bool {
        if matches(host: domain) {
            return true
        } else if includingSubdomains {
            return matches(host: "*.\(domain)")
        } else {
            return false
        }
    }

    private func matches(host: String) -> Bool {
        NSPredicate(format: "SELF LIKE %@", host)
            .evaluate(with: self.host)
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
