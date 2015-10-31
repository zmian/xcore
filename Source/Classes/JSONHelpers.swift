//
// JSONHelpers.swift
//
// Copyright © 2014 Zeeshan Mian
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
    public static func remoteOrLocalJSONFile(named: String, callback: (AnyObject? -> Void)) {
        if let url = NSURL(string: named) where url.host != nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let json = self.parse(url)
                dispatch_async(dispatch_get_main_queue()) {
                    callback(json)
                }
            }
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let json = self.parse(named)
                dispatch_async(dispatch_get_main_queue()) {
                    callback(json)
                }
            }
        }
    }

    /// Parse local JSON file from `mainBundle`
    public static func parse(fileName: String) -> AnyObject? {
        if let filePath = NSBundle.mainBundle().pathForResource((fileName as NSString).stringByDeletingPathExtension, ofType: "json") {
            if let data = NSData(contentsOfFile: filePath) {
                return parse(data)
            }
        }

        return nil
    }

    /// Parse remote JSON file
    public static func parse(url: NSURL) -> AnyObject? {
        guard let data = NSData(contentsOfURL: url) else { return nil }
        return parse(data)
    }

    /// Parse NSData to JSON
    public static func parse(data: NSData) -> AnyObject? {
        return try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
    }

    /// Convert value to a JSON string
    public static func stringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        let options: NSJSONWritingOptions = prettyPrinted ? .PrettyPrinted : []
        if NSJSONSerialization.isValidJSONObject(value) {
            if let data = try? NSJSONSerialization.dataWithJSONObject(value, options: options),
                 string = String(data: data, encoding: NSUTF8StringEncoding) {
                    return string
            }
        }
        return ""
    }
}
