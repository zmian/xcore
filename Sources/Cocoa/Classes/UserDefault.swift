//
// UserDefault.swift
//
// Copyright © 2016 Xcore
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

final public class UserDefault<T: Codable> {
    private let storage: UserDefaults
    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()
    private var notificationToken: NSObjectProtocol?
    private let key: String
    private let defaultValue: T?
    private var cachedValueInMemory: T?
    private let shouldCacheValueInMemory: Bool

    public init(key: String, default defaultValue: T? = nil, shouldCacheValueInMemory: Bool = true, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.shouldCacheValueInMemory = shouldCacheValueInMemory
        self.storage = storage
        setupApplicationMemoryWarningObserver()
    }

    public var value: T? {
        get {
            if let cachedValueInMemory = cachedValueInMemory {
                return cachedValueInMemory
            }

            guard
                let data = storage.object(forKey: key) as? Data,
                let value = try? decoder.decode(T.self, from: data)
            else {
                return defaultValue
            }

            if shouldCacheValueInMemory {
                cachedValueInMemory = value
            }

            return value
        }
        set {
            let data = newValue == nil ? nil : try? encoder.encode(newValue)
            storage.set(data, forKey: key)
            storage.synchronize()
            if shouldCacheValueInMemory {
                cachedValueInMemory = newValue
            }
        }
    }

    private func setupApplicationMemoryWarningObserver() {
        notificationToken = NotificationCenter.on.applicationDidReceiveMemoryWarning { [weak self] in
            self?.cachedValueInMemory = nil
        }
    }

    deinit {
        NotificationCenter.remove(notificationToken)
    }
}

extension UserDefault: CustomStringConvertible {
    public var description: String {
        guard let value = value as? CustomStringConvertible else {
            return String(describing: self.value)
        }

        return value.description
    }
}

extension UserDefault: CustomDebugStringConvertible {
    public var debugDescription: String {
        return value.debugDescription
    }
}
