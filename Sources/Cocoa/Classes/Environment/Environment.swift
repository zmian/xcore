//
// Environment.swift
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Environment {
    public enum Kind: CustomStringConvertible {
        case development
        case staging
        case production

        public var description: String {
            switch self {
                case .development:
                    return "Development"
                case .staging:
                    return "Staging"
                case .production:
                    return "Production"
            }
        }
    }
}

open class Environment {
    open var kind: Kind = .production

    public init() { }
}
