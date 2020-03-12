//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

final public class UserDefaultStore<T: Codable> {
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

extension UserDefaultStore: CustomStringConvertible {
    public var description: String {
        guard let value = value as? CustomStringConvertible else {
            return String(describing: self.value)
        }

        return value.description
    }
}

extension UserDefaultStore: CustomDebugStringConvertible {
    public var debugDescription: String {
        value.debugDescription
    }
}
