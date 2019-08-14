//
// Request.swift
//
// Copyright © 2015 Xcore
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
            Console.error("`data` is `nil`.")
            return nil
        }

        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let error {
            Console.error("Failed to parse JSON:", error)
        }

        return nil
    }

    public var responseString: String? {
        guard let data = data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    public init(request: URLRequest, response: URLResponse? = nil, data: Data? = nil, error: Error? = nil) {
        self.request = request
        self.response = response
        self.data = data
        self.error = error
    }
}

final public class Request {
    public enum Method: String {
        case get
        case post
        case put
        case delete
    }

    public enum Body {
        case json(NSDictionary)
        case data(Data)
    }

    public static let session = URLSession(configuration: .default)

    public static func get(_ request: URLRequest, callback: @escaping (_ response: Response) -> Void) {
        session.dataTaskWithRequest(request, callback: callback).resume()
    }

    public static func get(_ url: URL, parameters: [String: Any]? = nil, accessToken: String? = nil, callback: @escaping (_ response: Response) -> Void) {
        request(.get, url: url, body: parameters, accessToken: accessToken, callback: callback)
    }

    public static func post(_ url: URL, parameters: [String: Any]? = nil, accessToken: String? = nil, callback: @escaping (_ response: Response) -> Void) {
        request(.post, url: url, body: parameters, accessToken: accessToken, callback: callback)
    }

    public static func post(_ url: URL, image: UIImage, accessToken: String? = nil, callback: @escaping (_ response: Response) -> Void) {
        let headers = ["Content-Type": "image/jpeg"]
        request(.post, url: url, body: image.jpegData(compressionQuality: 1), accessToken: accessToken, headers: headers, callback: callback)
    }

    public static func put(_ url: URL, parameters: [String: Any]? = nil, accessToken: String? = nil, callback: @escaping (_ response: Response) -> Void) {
        request(.put, url: url, body: parameters, accessToken: accessToken, callback: callback)
    }

    public static func delete(_ url: URL, parameters: [String: Any]? = nil, accessToken: String? = nil, callback: @escaping (_ response: Response) -> Void) {
        request(.delete, url: url, body: parameters, accessToken: accessToken, callback: callback)
    }

    private static func request(_ method: Method, url: URL, body: [String: Any]? = nil, accessToken: String? = nil, headers: [String: String]? = nil, callback: @escaping (_ response: Response) -> Void) {
        var headers = headers ?? [:]
        if let accessToken = accessToken, headers["Authorization"] == nil {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        let request = URLRequest.jsonRequest(method, url: url, body: body, headers: headers)
        session.dataTaskWithRequest(request, callback: callback).resume()
    }

    public static func request(_ method: Method, url: URL, body: Data? = nil, accessToken: String? = nil, headers: [String: String]? = nil, callback: @escaping (_ response: Response) -> Void) {
        var headers = headers ?? [:]
        if let accessToken = accessToken, headers["Authorization"] == nil {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        let request = URLRequest(method: method, url: url, body: body, headers: headers)
        session.dataTaskWithRequest(request, callback: callback).resume()
    }
}

extension URLSession {
    fileprivate func dataTaskWithRequest(_ request: URLRequest, callback: @escaping (_ response: Response) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { data, response, error in
            callback(Response(request: request, response: response, data: data, error: error))
        }
    }
}

extension URLRequest {
    fileprivate init(method: Request.Method, url: URL, body: Data? = nil, headers: [String: String]? = nil) {
        self.init(url: url)
        httpMethod = method.rawValue
        httpBody = body
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
