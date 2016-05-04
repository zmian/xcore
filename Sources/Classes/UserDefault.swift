//
// UserDefault.swift
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

public class UserDefault<T> {
    private let serializableObjectType = T.self as? Serializable.Type
    private let codingObjectType = T.self as? NSCoding.Type
    private let key: String
    private let defaultValue: T?
    private var cachedValueInMemory: T?
    private let shouldCacheValueInMemory: Bool

    public init(key: String, defaultValue: T? = nil, shouldCacheValueInMemory: Bool = true) {
        self.key                      = key
        self.defaultValue             = defaultValue
        self.shouldCacheValueInMemory = shouldCacheValueInMemory

        onApplicationMemoryWarning {[weak self] in
            self?.cachedValueInMemory = nil
        }
    }

    public func value(storage: NSUserDefaults = NSUserDefaults.standardUserDefaults()) -> T? {
        if let cachedValueInMemory = cachedValueInMemory {
            return cachedValueInMemory
        }

        let value: T?

        if let data = storage.objectForKey(key) as? NSData {
            if let serializableObjectType = serializableObjectType {
                value = serializableObjectType.init(serialize: data) as? T ?? defaultValue
            } else {
                value = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? T ?? defaultValue
            }
        } else {
            value = storage.objectForKey(key) as? T ?? defaultValue
        }

        if shouldCacheValueInMemory { cachedValueInMemory = value }

        return value
    }

    public func save(newValue: T?, storage: NSUserDefaults = NSUserDefaults.standardUserDefaults()) {
        if shouldCacheValueInMemory { cachedValueInMemory = newValue }

        var newValue = newValue as? AnyObject
        if let serializableValue = newValue as? Serializable {
            newValue = serializableValue.serialize
        } else if let serializableValue = newValue as? NSCoding {
            newValue = NSKeyedArchiver.archivedDataWithRootObject(serializableValue)
        }

        storage.setObject(newValue, forKey: key)
        storage.synchronize()
    }

    private func onApplicationMemoryWarning(callback: () -> Void) {
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidReceiveMemoryWarningNotification, object: nil, queue: nil) { _ in
            callback()
        }
    }
}
