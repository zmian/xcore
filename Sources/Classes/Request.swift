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

import Foundation

public struct Response {
    public let request: NSURLRequest
    public let response: NSURLResponse?
    public let data: NSData?
    public let error: NSError?

    public var responseHTTP: NSHTTPURLResponse? {
        return response as? NSHTTPURLResponse
    }

    public var responseJSON: AnyObject? {
        if let data = data {
            return try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        } else {
            return nil
        }
    }

    public var responseString: String? {
        if let data = data {
            return String(data: data, encoding: NSUTF8StringEncoding)
        } else {
            return nil
        }
    }

    public init(request: NSURLRequest, response: NSURLResponse? = nil, data: NSData? = nil, error: NSError? = nil) {
        self.request  = request
        self.response = response
        self.data     = data
        self.error    = error
    }
}

public final class Request {
    public enum Method: String { case GET, POST, PUT, DELETE }
    public enum Body { case json(NSDictionary), data(NSData) }

    public static let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

    public static func GET(request: NSURLRequest, callback: (response: Response) -> Void) {
        session.dataTaskWithRequest(request, callback: callback).resume()
    }

    public static func GET(url: NSURL, parameters: [String: AnyObject]? = nil, accessToken: String? = nil, callback: (response: Response) -> Void) {
        request(.GET, url: url, body: parameters, accessToken: accessToken, callback: callback)
    }

    public static func POST(url: NSURL, parameters: [String: AnyObject]? = nil, accessToken: String? = nil, callback: (response: Response) -> Void) {
        request(.POST, url: url, body: parameters, accessToken: accessToken, callback: callback)
    }

    public static func POST(url: NSURL, image: UIImage, accessToken: String? = nil, callback: (response: Response) -> Void) {
        let headers = ["Content-Type": "image/jpeg"]
        request(.POST, url: url, body: UIImageJPEGRepresentation(image, 1), accessToken: accessToken, headers: headers, callback: callback)
    }

    public static func PUT(url: NSURL, parameters: [String: AnyObject]? = nil, accessToken: String? = nil, callback: (response: Response) -> Void) {
        request(.PUT, url: url, body: parameters, accessToken: accessToken, callback: callback)
    }

    public static func DELETE(url: NSURL, parameters: [String: AnyObject]? = nil, accessToken: String? = nil, callback: (response: Response) -> Void) {
        request(.DELETE, url: url, body: parameters, accessToken: accessToken, callback: callback)
    }

    private static func request(method: Method, url: NSURL, body: NSDictionary? = nil, accessToken: String? = nil, headers: [String: String]? = nil, callback: (response: Response) -> Void) {
        var headers = headers ?? [:]
        if let accessToken = accessToken where headers["Authorization"] == nil {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        let request = NSURLRequest.jsonRequest(method, url: url, body: body, headers: headers)
        session.dataTaskWithRequest(request, callback: callback).resume()
    }

    public static func request(method: Method, url: NSURL, body: NSData? = nil, accessToken: String? = nil, headers: [String: String]? = nil, callback: (response: Response) -> Void) {
        var headers = headers ?? [:]
        if let accessToken = accessToken where headers["Authorization"] == nil {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        let request = NSMutableURLRequest(method: method, url: url, body: body, headers: headers)
        session.dataTaskWithRequest(request, callback: callback).resume()
    }
}

private extension NSURLSession {
    @warn_unused_result
    func dataTaskWithRequest(request: NSURLRequest, callback: (response: Response) -> Void) -> NSURLSessionDataTask {
        return dataTaskWithRequest(request) { data, response, error in
            callback(response: Response(request: request, response: response, data: data, error: error))
        }
    }
}

private extension NSMutableURLRequest {
    convenience init(method: Request.Method, url: NSURL, body: NSData? = nil, headers: [String: String]? = nil) {
        self.init(URL: url)
        HTTPMethod = method.rawValue
        HTTPBody   = body
        headers?.forEach { addValue($0.1, forHTTPHeaderField: $0.0) }
    }
}

private extension NSURLRequest {
    @warn_unused_result
    class func jsonRequest(method: Request.Method, url: NSURL, body: NSDictionary? = nil, headers: [String: String]? = nil) -> NSURLRequest {
        var headers = headers ?? [:]
        if headers["Accept"] == nil {
            headers["Accept"] = "application/json"
        }
        let request = NSMutableURLRequest(method: method, url: url, headers: headers)

        if let body = body {
            request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(body, options: [])
            request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
}

public extension NSURL {
    public convenience init?(string: String, queryParameters: [String: String]) {
        let components = NSURLComponents(string: string)
        components?.queryItems = queryParameters.map(NSURLQueryItem.init)
        if let string = components?.URL?.absoluteString {
            self.init(string: string)
        } else {
            return nil
        }
    }
}
