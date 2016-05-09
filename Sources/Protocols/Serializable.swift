//
// Serializable.swift
//
// Copyright © 2016 Zeeshan Mian
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

public protocol Serializable {
    init?(serialize: NSData)
    var serialize: NSData? { get }
}

public extension Serializable where Self: NSCoding {
    public init?(serialize: NSData) {
        guard let object = NSKeyedUnarchiver.unarchiveObjectWithData(serialize) as? Self else { return nil }
        self = object
    }

    public var serialize: NSData? {
        return NSKeyedArchiver.archivedDataWithRootObject(self)
    }
}

public protocol DictionaryInitializable: CustomStringConvertible, Serializable {
    init?(dictionary: NSDictionary)
    func dictionary() -> [String: AnyObject]
}

public extension DictionaryInitializable {
    public init?(serialize: NSData) {
        guard
            let dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(serialize) as? NSDictionary,
            let object     = Self(dictionary: dictionary)
        else { return nil }
        self = object
    }

    public var serialize: NSData? {
        return NSKeyedArchiver.archivedDataWithRootObject(dictionary())
    }

    public var description: String {
        return JSONHelpers.stringify(dictionary(), prettyPrinted: true)
    }
}
