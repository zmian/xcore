//
//  IndexPathCache.swift
//  Xcore
//
//  Created by Zeeshan Mian on 4/8/17.
//  Copyright © 2017 Xcore. All rights reserved.
//

import Foundation

/// A helper struct to cache index path values for `UITableView` and `UICollectionView`.
struct IndexPathCache<Value> {
    private var dictionary = [String: Value]()
    private let defaultValue: Value

    init(defaultValue: Value) {
        self.defaultValue = defaultValue
    }

    private func key(for indexPath: IndexPath) -> String {
        return "\(indexPath.section)-\(indexPath.row)"
    }

    /// Set estimated cell value to cache.
    ///
    /// - parameter value:         The value to cache for the given index path.
    /// - parameter for indexPath: The index path to cache
    private mutating func set(value: Value, for indexPath: IndexPath) {
        dictionary[key(for: indexPath)] = value
    }

    /// Get estimated cell value from cache.
    ///
    /// - parameter indexPath: The index path to get the cached value for.
    ///
    /// - returns: The cached value if exists; otherwise, `defaultValue`.
    private func get(indexPath: IndexPath) -> Value {
        guard let estimatedValue = dictionary[key(for: indexPath)] else {
            return defaultValue
        }

        return estimatedValue
    }

    func exists(for indexPath: IndexPath) -> Bool {
        return dictionary[key(for: indexPath)] != nil
    }

    subscript(indexPath: IndexPath) -> Value {
        get { return get(indexPath: indexPath) }
        set { set(value: newValue, for: indexPath) }
    }

    mutating func removeAll() {
        dictionary.removeAll(keepingCapacity: false)
    }

    mutating func remove(at indexPath: IndexPath) {
        dictionary[key(for: indexPath)] = nil
    }

    var count: Int {
        return dictionary.count
    }

    var isEmpty: Bool {
        return dictionary.isEmpty
    }
}
