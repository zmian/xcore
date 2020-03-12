//
// IndexPathCache.swift
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A helper struct to cache index path values for `UITableView` and `UICollectionView`.
public struct IndexPathCache<Value> {
    private var dictionary: [String: Value] = [:]
    private let defaultValue: Value

    public init(default defaultValue: Value) {
        self.defaultValue = defaultValue
    }

    private func key(for indexPath: IndexPath) -> String {
        "\(indexPath.section)-\(indexPath.row)"
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
        dictionary[key(for: indexPath)] != nil
    }

    public subscript(indexPath: IndexPath) -> Value {
        get { get(indexPath) }
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
        dictionary.count
    }

    public var isEmpty: Bool {
        dictionary.isEmpty
    }
}
