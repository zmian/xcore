//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import KeychainAccess

/// A structure representing a key for the ``Pond``.
public struct PondKey: Hashable, Identifiable {
    /// A unique identifier for the key.
    public let id: String

    /// The storage where the value of the key will be saved.
    public let storage: Storage

    /// The duration for persisting the value of the key.
    public let duration: PersistenceDuration

    public init(id: String, storage: Storage, duration: PersistenceDuration = .appSession) {
        self.id = id
        self.storage = storage
        self.duration = duration
    }
}

// MARK: - Storage

extension PondKey {
    /// An enumeration representing the store for the value of the key.
    public enum Storage: Hashable {
        /// A storage backed by `UserDefaults`.
        case userDefaults

        /// A storage backed by `Keychain`.
        case keychain(policy: KeychainAccess.AuthenticationPolicy)

        /// A storage backed by `Keychain`.
        public static var keychain: Self {
            keychain(policy: .none)
        }
    }
}

// MARK: - Duration

extension PondKey {
    /// An enumeration representing the persistence duration for the value of the
    /// key.
    public enum PersistenceDuration: Hashable, CustomStringConvertible {
        /// Value is associated with the app and persisted until the current user signs
        /// out.
        case appSession

        /// Value is associated with the app and persisted until the app is deleted.
        case appPermanent

        /// Value is associated with the current user and persisted until the current
        /// user signs out (e.g., filter settings).
        case userSession

        /// Value is associated with the current user and persisted until the app is
        /// deleted (e.g., user visits count).
        case userPermanent

        public var description: String {
            switch self {
                case .appSession:
                    return "App Session"
                case .appPermanent:
                    return "App Permanent"
                case .userSession:
                    return "User Session"
                case .userPermanent:
                    return "User Permanent"
            }
        }

        public var isSessionOnly: Bool {
            switch self {
                case .appSession, .userSession:
                    return true
                case .appPermanent, .userPermanent:
                    return false
            }
        }
    }
}
