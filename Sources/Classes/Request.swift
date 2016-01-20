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

public struct Request {
    public static func GET(url: NSURL, callback: (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithURL(url) { data, response, error in
            callback(response: response, data: data, error: error)
        }.resume()
    }

    public static func json(url: NSURL, callback: (response: NSURLResponse?, json: AnyObject?, error: NSError?) -> Void) {
        GET(url) { response, data, error in
            var json: AnyObject?
            if let data = data {
                json = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            }
            callback(response: response, json: json, error: error)
        }
    }

    // TODO: Implement POST, PUT, DELETE and support for parameters
}
