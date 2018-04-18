//
// Request.swift
//
// Copyright © 2015 Zeeshan Mian
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

import UIKit

public struct Response {
    public let request: URLRequest
    public let response: URLResponse?
    public let data: Data?
    public let error: Error?

    public var responseHTTP: HTTPURLResponse? {
        return response as? HTTPURLResponse
    }

    public var responseJSON: Any? {
        guard let data = data else {
            console.error("`data` is `nil`.")
            return nil
        }

        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let error {
            console.error("Failed to parse JSON:", error)
        }

        return nil
    }

    public var responseString: String? {
        if let data = data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }

    public init(request: URLRequest, response: URLResponse? = nil, data: Data? = nil, error: Error? = nil) {
        self.request  = request
        self.response = response
        self.data     = data
        self.error    = error
    }
}

public final class Request {
    public enum Method: String { case GET, POST, PUT, DELETE }
    public enum Body { case json(NSDictionary), data(Data) }

    public static let session = URLSession(configuration: URLSessionConfiguration.default)

    public static func GET(_ request: URLRequest, callback: @escaping (_ response: Response) -> Void) {
        session.dataTaskWithRequest(request, callback: callback).resume()
    }

    public static func GET(_ url: URL, parameters: [String: Any]? = nil, accessToken: String? = nil, callback: @escaping (_ response: Response) -> Void) {
        request(.GET, url: url, body: parameters, accessToken: accessToken, callback: callback)
    }

    public static func POST(_ url: URL, parameters: [String: Any]? = nil, accessToken: String? = nil, callback: @escaping (_ response: Response) -> Void) {
        request(.POST, url: url, body: parameters, accessToken: accessToken, callback: callback)
    }

    public static func POST(_ url: URL, image: UIImage, accessToken: String? = nil, callback: @escaping (_ response: Response) -> Void) {
        let headers = ["Content-Type": "image/jpeg"]
        request(.POST, url: url, body: UIImageJPEGRepresentation(image, 1), accessToken: accessToken, headers: headers, callback: callback)
    }

    public static func PUT(_ url: URL, parameters: [String: Any]? = nil, accessToken: String? = nil, callback: @escaping (_ response: Response) -> Void) {
        request(.PUT, url: url, body: parameters, accessToken: accessToken, callback: callback)
    }

    public static func DELETE(_ url: URL, parameters: [String: Any]? = nil, accessToken: String? = nil, callback: @escaping (_ response: Response) -> Void) {
        request(.DELETE, url: url, body: parameters, accessToken: accessToken, callback: callback)
    }

    fileprivate static func request(_ method: Method, url: URL, body: [String: Any]? = nil, accessToken: String? = nil, headers: [String: String]? = nil, callback: @escaping (_ response: Response) -> Void) {
        var headers = headers ?? [:]
        if let accessToken = accessToken , headers["Authorization"] == nil {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        let request = URLRequest.jsonRequest(method, url: url, body: body, headers: headers)
        session.dataTaskWithRequest(request, callback: callback).resume()
    }

    public static func request(_ method: Method, url: URL, body: Data? = nil, accessToken: String? = nil, headers: [String: String]? = nil, callback: @escaping (_ response: Response) -> Void) {
        var headers = headers ?? [:]
        if let accessToken = accessToken , headers["Authorization"] == nil {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        let request = URLRequest(method: method, url: url, body: body, headers: headers)
        session.dataTaskWithRequest(request, callback: callback).resume()
    }
}

fileprivate extension URLSession {
    fileprivate func dataTaskWithRequest(_ request: URLRequest, callback: @escaping (_ response: Response) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { data, response, error in
            callback(Response(request: request, response: response, data: data, error: error))
        }
    }
}

fileprivate extension URLRequest {
    fileprivate init(method: Request.Method, url: URL, body: Data? = nil, headers: [String: String]? = nil) {
        self.init(url: url)
        httpMethod = method.rawValue
        httpBody   = body
        headers?.forEach { addValue($0.1, forHTTPHeaderField: $0.0) }
    }

    fileprivate static func jsonRequest(_ method: Request.Method, url: URL, body: [String: Any]? = nil, headers: [String: String]? = nil) -> URLRequest {
        var headers = headers ?? [:]
        if headers["Accept"] == nil {
            headers["Accept"] = "application/json"
        }
        var request = URLRequest(method: method, url: url, headers: headers)

        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
}

extension URL {
    public init?(string: String, queryParameters: [String: String]) {
        var components = URLComponents(string: string)
        components?.queryItems = queryParameters.map(URLQueryItem.init)
        if let string = components?.url?.absoluteString {
            self.init(string: string)
        } else {
            return nil
        }
    }
}

extension URL {
    /// Returns a URL constructed by removing the fragment from self.
    ///
    /// If the URL has no fragment (e.g., `http://www.example.com`), then this function will return the URL unchanged.
    public func deletingFragment() -> URL {
        if let fragment = fragment {
            let urlString = absoluteString.replace("#\(fragment)", with: "")
            return URL(string: urlString) ?? self
        }

        return self
    }

    /// A boolean value to determine whether the url is an email link (i.e., `mailto`).
    public var isEmailLink: Bool {
        guard let scheme = scheme else {
            return false
        }

        return scheme == "mailto"
    }
}
