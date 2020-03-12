//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Namespace

/// Use feature flags as an iterative approach to development.
public enum FeatureFlag { }

// MARK: - Key

extension FeatureFlag {
    public struct Key: RawRepresentable, Equatable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
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
