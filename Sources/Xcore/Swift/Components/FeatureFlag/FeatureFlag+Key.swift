//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Namespace

/// Use feature flags as an iterative approach to development.
public enum FeatureFlag {}

// MARK: - Key

extension FeatureFlag {
    public struct Key: RawRepresentable, Equatable, UserInfoContainer {
        public let rawValue: String

        /// Additional info which may be used to describe the key further.
        public var userInfo: UserInfo

        /// Initialize an instance of key.
        ///
        /// - Parameter rawValue: A unique string representing the key.
        public init(rawValue: String) {
            self.rawValue = rawValue
            self.userInfo = [:]
        }

        /// Initialize an instance of key.
        ///
        /// - Parameters:
        ///   - rawValue: A unique string representing the key.
        ///   - userInfo: Additional info associated with the key.
        public init(rawValue: String, userInfo: UserInfo) {
            self.rawValue = rawValue
            self.userInfo = userInfo
        }
    }
}

extension FeatureFlag.Key: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}

extension FeatureFlag.Key: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension FeatureFlag.Key: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        rawValue
    }
}

extension FeatureFlag.Key: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
