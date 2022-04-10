//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct AppError: AppErrorProtocol, UserInfoContainer, MutableAppliable {
    typealias L = Localized.Error

    public var id: String
    public var title: String
    public var message: String
    public var debugMessage: String?
    public var logLevel: LogLevel?
    /// Additional info which may be used to describe the error further.
    public var userInfo: UserInfo

    /// Initialize an instance of app error.
    ///
    /// - Parameters:
    ///   - id: A unique id for the error.
    ///   - title: The title of the error.
    ///   - message: A localized message describing the error and why it occurred.
    ///   - debugMessage: A debug message describing the additional context for
    ///     debugging purpose.
    ///   - logLevel: The log level that should be sent to app monitoring service.
    ///   - userInfo: Additional info associated with the error.
    public init(
        id: String,
        title: String,
        message: String,
        debugMessage: String? = nil,
        logLevel: LogLevel? = nil,
        userInfo: UserInfo = [:]
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.debugMessage = debugMessage
        self.logLevel = logLevel
        self.userInfo = userInfo
    }
}

// MARK: - Equatable

extension AppError: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension AppError: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(message)
        hasher.combine(debugMessage)
        hasher.combine(logLevel)
    }
}

// MARK: - Pattern Matching Operator

extension AppError {
    public static func ~=(pattern: String, value: Self) -> Bool {
        pattern == value.id
    }
}

// MARK: - Property Name

extension AppError {
    /// Returns a new instance with updated `id` and all other properties are same
    /// as `general` error.
    public static func propertyName(_ id: String = #function) -> Self {
        .init(
            id: id.snakecased(),
            title: general.title,
            message: general.message,
            debugMessage: general.debugMessage,
            logLevel: general.logLevel,
            userInfo: general.userInfo
        )
    }
}
