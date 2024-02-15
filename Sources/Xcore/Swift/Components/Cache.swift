//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A mutable collection you use to temporarily store transient key-value pairs
/// that are subject to eviction when resources are low.
actor Cache<Key: Hashable & Sendable, Value> {
    /// The keys of the cache.
    public private(set) var keys = Set<Key>()
    private let cache = NSCache<KeyWrapper<Key>, ValueWrapper>()
    private let delegate = DelegateWrapper<Value>()

    public init() {
        cache.delegate = delegate
    }

    /// The name of the cache.
    ///
    /// The default value is an empty string ("").
    public var name: String {
        get { cache.name }
        set { cache.name = newValue }
    }

    /// Adds an action to perform when an value is about to be evicted or removed
    /// from the cache.
    ///
    /// - Parameter action: The action to perform.
    public func willEvictValue(_ action: ((Value) -> Void)?) {
        delegate.willEvictValue = action
    }

    /// Returns a Boolean value indicating whether the cache contains the value for
    /// the given key.
    ///
    /// - Parameter key: The key to look up in the cache.
    /// - Returns: The value associated with key, or `nil` if no value is associated
    ///   with key.
    public func contains(forKey key: Key) -> Bool {
        value(forKey: key) != nil
    }

    /// Returns the value associated with a given key.
    ///
    /// - Parameter key: An object identifying the value.
    /// - Returns: The value associated with key, or `nil` if no value is associated
    ///   with key.
    public func value(forKey key: Key) -> Value? {
        cache.object(forKey: KeyWrapper(key))?.value as? Value
    }

    /// Sets the value of the specified key in the cache.
    ///
    /// Unlike an `NSMutableDictionary` value, a cache does not copy the key
    /// values that are put into it.
    ///
    /// - Parameters:
    ///   - value: The value to be stored in the cache.
    ///   - key: The key with which to associate the value.
    public func setValue(_ value: Value, forKey key: Key) {
        keys.insert(key)
        cache.setObject(ValueWrapper(value), forKey: KeyWrapper(key))
    }

    /// Sets the value of the specified key in the cache, and associates the
    /// key-value pair with the specified cost.
    ///
    /// The cost value is used to compute a sum encompassing the costs of all the
    /// values in the cache. When memory is limited or when the total cost of the
    /// cache eclipses the maximum allowed total cost, the cache could begin an
    /// eviction process to remove some of its elements. However, this eviction
    /// process is not in a guaranteed order. As a consequence, if you try to
    /// manipulate the cost values to achieve some specific behavior, the
    /// consequences could be detrimental to your program. Typically, the obvious
    /// cost is the size of the value in bytes. If that information is not readily
    /// available, you should not go through the trouble of trying to compute it,
    /// as doing so will drive up the cost of using the cache. Pass in `0` for the
    /// cost value if you otherwise have nothing useful to pass, or simply use the
    /// ``setValue:forKey:`` method, which does not require a cost value to be
    /// passed in.
    ///
    /// Unlike an ``NSMutableDictionary`` value, a cache does not copy the key
    /// values that are put into it.
    ///
    /// - Parameters:
    ///   - value: The value to store in the cache.
    ///   - key: The key with which to associate the value.
    ///   - cost: The cost with which to associate the key-value pair.
    public func setValue(_ value: Value, forKey key: Key, cost: Int) {
        keys.insert(key)
        cache.setObject(ValueWrapper(value), forKey: KeyWrapper(key), cost: cost)
    }

    /// Removes the value of the specified key in the cache.
    ///
    /// - Parameter key: The key identifying the value to be removed.
    public func remove(_ key: Key) {
        keys.remove(key)
        cache.removeObject(forKey: KeyWrapper(key))
    }

    /// Empties the cache.
    public func removeAll() {
        keys.removeAll()
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

    /// Whether the cache will automatically evict discardable-content values whose
    /// content has been discarded.
    public var evictsValuesWithDiscardedContent: Bool {
        get { cache.evictsObjectsWithDiscardedContent }
        set { cache.evictsObjectsWithDiscardedContent = newValue }
    }
}

// MARK: - Wrappers

private final class ValueWrapper {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }
}

private final class KeyWrapper<Key: Hashable & Sendable>: NSObject, Sendable {
    let key: Key

    init(_ key: Key) {
        self.key = key
    }

    override var hash: Int {
        key.hashValue
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? KeyWrapper<Key> else {
            return false
        }

        return key == other.key
    }
}

private final class DelegateWrapper<Value>: NSObject, NSCacheDelegate {
    var willEvictValue: ((Value) -> Void)?

    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        guard
            let willEvictValue = willEvictValue,
            let value = (obj as? ValueWrapper)?.value as? Value
        else {
            return
        }

        willEvictValue(value)
    }
}
