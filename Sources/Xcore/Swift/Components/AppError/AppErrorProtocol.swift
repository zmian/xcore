//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A specialized protocol that provides unique id of the error.
public protocol ErrorIdentifier: Error {
    /// A unique id for the error.
    var id: String { get }
}

/// A specialized error that provides localized messages describing the error
/// and why it occurred.
public protocol AppErrorProtocol: ErrorIdentifier, CustomStringConvertible, CustomAnalyticsValueConvertible {
    /// A unique id for the error.
    var id: String { get }

    /// A title of the error.
    var title: String { get }

    /// A localized message describing the error and why it occurred.
    var message: String { get }

    /// A debug message describing the additional context for debugging purpose.
    var debugMessage: String? { get }

    /// The log level that should be sent to app monitoring service.
    var logLevel: LogLevel? { get }
}

// MARK: - Default Implementation

extension AppErrorProtocol {
    public var analyticsValue: String {
        id
    }

    public var description: String {
        var result = """
        id: \(id)
        title: \(title)
        message: \(message)
        """

        if let debugMessage {
            result += "\ndebugMessage: \(debugMessage)"
        }

        return result
    }

    public var title: String {
        AppError.general.title
    }

    public var message: String {
        AppError.general.message
    }

    public var debugMessage: String? {
        nil
    }

    public var logLevel: LogLevel? {
        nil
    }
}

// MARK: - Error Conformance to AppErrorProtocol

extension Error {
    public var id: String {
        if let error = self as? ErrorIdentifier {
            return error.id
        }

        return "general"
    }

    public var title: String {
        appError.title
    }

    public var message: String {
        appError.message
    }

    public var debugMessage: String? {
        appError.debugMessage
    }

    public var logLevel: LogLevel? {
        appError.logLevel
    }

    private var appError: AppErrorProtocol {
        self as? AppErrorProtocol ?? AppError.general
    }
}

// MARK: - Analytics

extension Error {
    public var analyticsValue: String {
        id
    }

    public var analyticsProperties: [String: String] {
        ["error_id": id]
    }
}
