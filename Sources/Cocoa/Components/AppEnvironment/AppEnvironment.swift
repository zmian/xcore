//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct AppEnvironment: UserInfoContainer, MutableAppliable {
    public typealias Identifier = Xcore.Identifier<Self>

    /// A unique id for the environment.
    public let id: Identifier

    /// Additional info which may be used to describe the environment further.
    public var userInfo: UserInfo

    /// Initialize an instance of environment.
    ///
    /// - Parameters:
    ///   - id: The unique id for the environment.
    ///   - userInfo: Additional info associated with the environment.
    public init(
        id: Identifier,
        userInfo: UserInfo = [:]
    ) {
        self.id = id
        self.userInfo = userInfo
    }
}

// MARK: - Hashable

extension AppEnvironment: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Equatable

extension AppEnvironment: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - UserInfo

extension UserInfoKey where Type == AppEnvironment {
    /// The host name of the API.
    fileprivate static var apiHostName: Self { #function }

    /// The host name of the website.
    fileprivate static var webHostName: Self { #function }
}

extension AppEnvironment {
    /// The host name of the API.
    public var apiHostName: String {
        get {
            guard let value: String = self[userInfoKey: .apiHostName] else {
                fatalError("API host name isn't configured.")
            }

            return value
        }
        set { self[userInfoKey: .apiHostName] = newValue }
    }

    /// The host name of the website.
    public var webHostName: String {
        get {
            guard let value: String = self[userInfoKey: .webHostName] else {
                fatalError("Web host name isn't configured.")
            }

            return value
        }
        set { self[userInfoKey: .webHostName] = newValue }
    }
}
