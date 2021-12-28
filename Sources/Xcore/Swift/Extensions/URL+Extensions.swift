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

// MARK: - Appening Query Items

extension URL {
    /// Appends the given query item to the URL.
    ///
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld")!
    /// print(url.appendQueryItem(named: "lang", value: "Swift")) // "https://example.com/?q=HelloWorld&lang=Swift"
    /// ```
    public func appendQueryItem(named name: String, value: String?) -> URL {
        appendQueryItem(.init(name: name, value: value))
    }

    /// Appends the given query item to the URL.
    ///
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld")!
    /// print(url.appendQueryItem(URLQueryItem(name: "lang", value: "Swift")) // "https://example.com/?q=HelloWorld&lang=Swift"
    /// ```
    public func appendQueryItem(_ item: URLQueryItem) -> URL {
        appendQueryItems([item])
    }

    /// Appends the given list of query items to the URL.
    ///
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld")!
    /// print(url.appendQueryItems([URLQueryItem(name: "lang", value: "Swift")]) // "https://example.com/?q=HelloWorld&lang=Swift"
    /// ```
    public func appendQueryItems(_ items: [URLQueryItem]) -> URL {
        guard var components = URLComponents.init(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }

        var queryItems = components.queryItems ?? []
        queryItems.append(contentsOf: items)
        components.queryItems = Array(queryItems.reversed()).uniqued(\.name).reversed()

        return components.url ?? self
    }
}

// MARK: - Removing Query Items

extension URL {
    /// Removes all the query items.
    ///
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld")!
    /// print(url.removingQueryItems()) // "https://example.com"
    /// ```
    public func removingQueryItems() -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }

        components.query = nil

        return components.url ?? self
    }

    /// Removes all the query items that are in the given list.
    ///
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld&lang=swift")!
    /// print(url.removingQueryItems(["q", "lang"]) // "https://example.com/"
    /// ```
    public func removingQueryItems(_ names: [String]) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }

        components.queryItems?.removeAll { item in
            names.contains(item.name)
        }

        if components.queryItems?.isEmpty == true {
            components.queryItems = nil
        }

        return components.url ?? self
    }

    /// Removes all the query items that match the given name.
    ///
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld&lang=swift")!
    /// print(url.removingQueryItem(named: "q")) // "https://example.com/?lang=swift"
    /// ```
    public func removingQueryItem(named name: String) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }

        if var queryItems = components.queryItems {
            queryItems.removeAll { item in
                item.name == name
            }

            if queryItems.isEmpty {
                components.queryItems = nil
            } else {
                components.queryItems = queryItems
            }
        }

        return components.url ?? self
    }

    /// Replaces value of all query items that match the given name.
    ///
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld&lang=swift")!
    /// print(url.replacingQueryItem(named: "q", with: "World")) // "https://example.com/?q=World&lang=swift"
    /// ```
    public func replacingQueryItem(named name: String, with value: String) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }

        if var queryItems = components.queryItems, !queryItems.isEmpty {
            for (index, item) in queryItems.enumerated() where item.name == name {
                queryItems[index].value = value
            }

            components.queryItems = queryItems
        }

        return components.url ?? self
    }

    /// Replaces value of given list of query items with the new provided value.
    ///
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld&lang=swift")!
    /// print(url.replacingQueryItems(["q", "swift"], with: "xxxx")) // "https://example.com/?q=xxxx&lang=xxxx"
    /// ```
    public func replacingQueryItems(_ names: [String], with value: String) -> URL {
        guard
            !names.isEmpty,
            var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        else {
            return self
        }

        if var queryItems = components.queryItems, !queryItems.isEmpty {
            for (index, item) in queryItems.enumerated() {
                for name in names where item.name == name {
                    queryItems[index].value = value
                }
            }

            components.queryItems = queryItems
        }

        return components.url ?? self
    }
}

// MARK: - Removing Components

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
