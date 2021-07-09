//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - UserInfoKey

public struct UserInfoKey<Type>: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension UserInfoKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}

extension UserInfoKey: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension UserInfoKey: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        rawValue
    }
}

extension UserInfoKey: Hashable {}

extension UserInfoKey: Codable {}

// MARK: - UserInfoContainer

public protocol UserInfoContainer {
    typealias UserInfoKey = Xcore.UserInfoKey<Self>
    typealias UserInfo = [UserInfoKey: Any]
    var userInfo: UserInfo { get set }
}

extension UserInfoContainer {
    public subscript<T>(userInfoKey key: UserInfoKey) -> T? {
        get { userInfo[key] as? T }
        set { userInfo[key] = newValue }
    }

    public subscript<T>(userInfoKey key: UserInfoKey, default defaultValue: @autoclosure () -> T) -> T {
        self[userInfoKey: key] ?? defaultValue()
    }
}
