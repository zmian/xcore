//
// IndexPathCache.swift
//
// Copyright © 2017 Xcore
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

/// A helper struct to cache index path values for `UITableView` and `UICollectionView`.
public struct IndexPathCache<Value> {
    private var dictionary = [String: Value]()
    private let defaultValue: Value

    public init(default defaultValue: Value) {
        self.defaultValue = defaultValue
    }

    private func key(for indexPath: IndexPath) -> String {
        return "\(indexPath.section)-\(indexPath.row)"
    }

    /// Set estimated cell value to cache.
    ///
    /// - Parameters:
    ///   - value: The value to cache for the given index path.
    ///   - indexPath: The index path to cache.
    private mutating func set(_ value: Value, for indexPath: IndexPath) {
        dictionary[key(for: indexPath)] = value
    }

    /// Get estimated cell value from cache.
    ///
    /// - Parameter indexPath: The index path to get the cached value for.
    /// - Returns: The cached value if exists; otherwise, `defaultValue`.
    private func get(_ indexPath: IndexPath) -> Value {
        guard let estimatedValue = dictionary[key(for: indexPath)] else {
            return defaultValue
        }

        return estimatedValue
    }

    public func exists(for indexPath: IndexPath) -> Bool {
        return dictionary[key(for: indexPath)] != nil
    }

    public subscript(indexPath: IndexPath) -> Value {
        get { return get(indexPath) }
        set { set(newValue, for: indexPath) }
    }

    /// Empties the cache.
    public mutating func removeAll() {
        dictionary.removeAll(keepingCapacity: false)
    }

    /// Removes the value of the specified indexPath in the cache.
    ///
    /// - Parameter indexPath: The indexPath identifying the value to be removed.
    public mutating func remove(at indexPath: IndexPath) {
        dictionary[key(for: indexPath)] = nil
    }

    public var count: Int {
        return dictionary.count
    }

    public var isEmpty: Bool {
        return dictionary.isEmpty
    }
}
