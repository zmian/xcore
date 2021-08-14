//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - KeyValueMap.Store

extension KeyValueMap {
    public final class Store {
        private var storage: Set<KeyValueMap>

        public init(_ storage: Set<KeyValueMap> = []) {
            self.storage = storage
        }

        public func append(_ item: KeyValueMap) {
            storage.insert(item)
        }

        public func append(_ items: [KeyValueMap]) {
            items.forEach {
                append($0)
            }
        }

        public func remove(_ item: KeyValueMap) {
            storage.remove(item)
        }

        public func remove(_ key: String) {
            storage = storage.filter { !$0.contains(key) }
        }

        public func contains(_ key: String) -> Bool {
            storage.contains { $0.contains(key) }
        }

        public subscript(key: String) -> KeyValueMap? {
            guard let index = storage.firstIndex(where: { $0.contains(key) }) else {
                return nil
            }

            return storage[index]
        }
    }
}

// MARK: - KeyValueMap

public struct KeyValueMap<Type, Value>: UserInfoContainer, MutableAppliable {
    public let key: String
    private let map: Set<String>
    public let value: Value
    /// Additional info which may be used to describe the url further.
    public var userInfo: UserInfo

    public init(_ key: String, _ value: Value, map: Set<String> = [], userInfo: UserInfo = [:]) {
        self.key = key
        self.value = value
        self.map = map
        self.userInfo = userInfo
    }

    public func contains(_ key: String) -> Bool {
        if key == self.key {
            return true
        }

        return map.contains { $0 == key }
    }
}

// MARK: - Equatable

extension KeyValueMap: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.key == rhs.key
    }
}

// MARK: - Hashable

extension KeyValueMap: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}

extension ImageAssetIdentifier {
    public typealias Map<Type> = KeyValueMap<Type, ImageAssetIdentifier>
}
