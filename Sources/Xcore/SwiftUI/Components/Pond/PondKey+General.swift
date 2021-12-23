//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Keys: User Defaults

extension PondKey {
    /// A boolean property indicating whether the app is first launched since clean
    /// install.
    fileprivate static var isFirstLaunch: Self {
        .init(id: #function, storage: .userDefaults, duration: .permanent)
    }

    /// Returns last saved system force refresh hash.
    fileprivate static var lastSystemForceRefreshHash: Self {
        .init(id: #function, storage: .userDefaults, duration: .permanent)
    }
}

// MARK: - Pond: User Defaults

extension Pond {
    /// A boolean property indicating whether the app is first launched since clean
    /// install.
    public var isFirstLaunch: Bool {
        get {
            // If the key exists, this means it's not the first launch.
            !contains(.isFirstLaunch)
        }
        nonmutating set { `set`(.isFirstLaunch, value: newValue) }
    }

    /// Returns last saved system force refresh hash.
    public var lastSystemForceRefreshHash: String? {
        get { `get`(.lastSystemForceRefreshHash) }
        nonmutating set { `set`(.lastSystemForceRefreshHash, value: newValue) }
    }
}