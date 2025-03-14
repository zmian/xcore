//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A thread-safe collection for temporarily storing transient key-value pairs.
///
/// This cache wraps an NSCache to provide a lightweight, in-memory storage that
/// automatically evicts values when resources are low. It is designed for
/// non-persistent, ephemeral data that can be safely recreated if needed.
///
/// **Usage**
///
/// ```swift
/// let cache = Cache<String, Data>()
/// cache["imageData"] = someData
/// if let data = cache["imageData"] {
///     print("Data retrieved from cache")
/// }
/// cache["imageData"] = nil // removes cached entry
/// ```
public final class Cache<Key: Sendable & Hashable, Value>: Sendable {
    /// The underlying NSCache instance.
    ///
    /// `nonisolated(unsafe)` is valid here as add, remove, and query operations are
    /// documented as [thread safe]:
    ///
    /// [thread safe]: https://developer.apple.com/documentation/foundation/nscache
    nonisolated(unsafe) private let cache = NSCache<ReferenceBox<Key>, ReferenceBox<Value>>()

    /// A delegate wrapper that handles eviction callbacks.
    private let delegate: DelegateWrapper<Value>

    /// Creates an instance of `Cache`.
    ///
    /// - Parameter willEvictValue: The action to perform when an value is about to
    ///   be evicted or removed from the cache.
    public init(willEvictValue: (@Sendable (Value) -> Void)? = nil) {
        self.delegate = .init(willEvictValue: willEvictValue)
        cache.delegate = delegate
    }

    /// The name of the cache.
    ///
    /// The default value is an empty string ("").
    public var name: String {
        get { cache.name }
        set { cache.name = newValue }
    }

    /// Returns a Boolean value indicating whether the cache contains the value for
    /// the given key.
    /// 
    /// - Parameter key: The key to look up in the cache.
    /// - Returns: `true` if a value is associated with the key; otherwise, `false`.
    public func contains(_ key: Key) -> Bool {
        self[key] != nil
    }

    public subscript(_ key: Key, cost cost: Int? = nil) -> Value? {
        get { cache.object(forKey: ReferenceBox(key))?.value }
        set {
            let key = ReferenceBox(key)

            if let newValue {
                let newValue = ReferenceBox(newValue)

                if let cost {
                    cache.setObject(newValue, forKey: key, cost: cost)
                } else {
                    cache.setObject(newValue, forKey: key)
                }
            } else {
                cache.removeObject(forKey: key)
            }
        }
    }

    /// Empties the cache.
    public func removeAll() {
        cache.removeAllObjects()
    }

    /// The maximum total cost that the cache can hold before it starts evicting
    /// values.
    ///
    /// If `0`, there is no total cost limit. The default value is `0`.
    ///
    /// When you add a value to the cache, you may pass in a specified cost for the
    /// value, such as the size in bytes of the value. If adding this value to the
    /// cache causes the cache's total cost to rise above `totalCostLimit`, the
    /// cache may automatically evict values until its total cost falls below
    /// `totalCostLimit`. The order in which the cache evicts values is not
    /// guaranteed.
    ///
    /// This is not a strict limit, and if the cache goes over the limit, a value
    /// in the cache could be evicted instantly, at a later point in time, or
    /// possibly never, all depending on the implementation details of the cache.
    public var totalCostLimit: Int {
        get { cache.totalCostLimit }
        set { cache.totalCostLimit = newValue }
    }

    /// The maximum number of values the cache should hold.
    ///
    /// If `0`, there is no count limit. The default value is `0`.
    ///
    /// This is not a strict limit—if the cache goes over the limit, an value in the
    /// cache could be evicted instantly, later, or possibly never, depending on the
    /// implementation details of the cache.
    public var countLimit: Int {
        get { cache.countLimit }
        set { cache.countLimit = newValue }
    }

    /// A Boolean property indicating whether the cache evicts values with discarded
    /// content.
    public var evictsValuesWithDiscardedContent: Bool {
        get { cache.evictsObjectsWithDiscardedContent }
        set { cache.evictsObjectsWithDiscardedContent = newValue }
    }
}

// MARK: - DelegateWrapper

private final class DelegateWrapper<Value>: NSObject, NSCacheDelegate, Sendable {
    let willEvictValue: (@Sendable (Value) -> Void)?

    init(willEvictValue: (@Sendable (Value) -> Void)?) {
        self.willEvictValue = willEvictValue
    }

    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        guard
            let willEvictValue = willEvictValue,
            let value = (obj as? ReferenceBox<Value>)?.value
        else {
            return
        }

        willEvictValue(value)
    }
}
