//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import KeychainAccess

/// A structure representing a key for the ``Pond``.
public struct PondKey: Hashable, Sendable, Identifiable, UserInfoContainer {
    /// A unique identifier for the key.
    public let id: String

    /// The storage where the value of the key will be saved.
    ///
    /// - Warning: You must set the ``Pond`` based on the key preference.
    ///
    ///   You can use `CompositePond` and return appropriate pond for each key.
    ///
    /// **For Example:**
    ///
    /// ```swift
    /// DependencyValues.pond(.composite(accessGroup: "group.com.example"))
    /// ```
    /// If you need more control you can customize the composite pond:
    ///
    /// ```swift
    /// DependencyValues.pond(.composite { key in
    ///     switch key.storage {
    ///         case .userDefaults:
    ///             // return appropriate pond
    ///         case let .keychain(policy):
    ///             // return appropriate pond
    ///     }
    /// })
    /// ```
    public let storage: Storage

    /// The duration for persisting the value of the key.
    public let duration: PersistenceDuration

    /// Additional info which may be used to describe the key further.
    public var userInfo: UserInfo

    public init(
        id: String,
        storage: Storage,
        duration: PersistenceDuration = .session,
        userInfo: UserInfo = [:]
    ) {
        self.id = id
        self.storage = storage
        self.duration = duration
        self.userInfo = userInfo
    }
}

// MARK: - Storage

extension PondKey {
    /// An enumeration representing the store for the value of the key.
    public enum Storage: Hashable, @unchecked Sendable {
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
    public enum PersistenceDuration: Hashable, Sendable, CustomStringConvertible {
        /// Value is persisted until the current user signs out (e.g., filter settings).
        case session

        /// Value is persisted until the app is deleted (e.g., user visits count).
        case permanent

        public var description: String {
            switch self {
                case .session:
                    return "Session"
                case .permanent:
                    return "Permanent"
            }
        }
    }
}

// MARK: - Equatable

extension PondKey {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension PondKey {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
