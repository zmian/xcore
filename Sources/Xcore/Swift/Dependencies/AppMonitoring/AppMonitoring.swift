//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct AppMonitoring: Sendable {
    /// Configure app monitoring service.
    public var configure: @Sendable () -> Void

    /// Configure app reporting collection to based on user preferences.
    public var setCollectionEnabled: @Sendable (Bool) -> Void

    /// Associates given user id with subsequent reports.
    public var signin: @Sendable (_ userId: String?) -> Void

    /// Disassociate any existing user id from subsequent reports.
    public var signout: @Sendable () -> Void

    /// Logs a message with option to include any additional information.
    private var _log: @Sendable (
        _ level: LogLevel,
        _ message: String?,
        _ error: Error?,
        _ properties: EncodableDictionary?
    ) -> Void

    private var _trace: @Sendable (_ operationName: String) -> AppTraceReporting

    public init(
        configure: @escaping @Sendable () -> Void,
        setCollectionEnabled: @escaping @Sendable (Bool) -> Void,
        signin: @escaping @Sendable (_ userId: String?) -> Void,
        signout: @escaping @Sendable () -> Void,
        log: @escaping @Sendable (_ level: LogLevel, _ message: String?, _ error: Error?, _ properties: EncodableDictionary?) -> Void,
        trace: @escaping @Sendable (_ operationName: String) -> AppTraceReporting
    ) {
        self.configure = configure
        self.setCollectionEnabled = setCollectionEnabled
        self.signin = signin
        self.signout = signout
        self._log = log
        self._trace = trace
    }
}

extension AppMonitoring {
    public func trace(operationName: String) -> AppTraceReporting {
        _trace(operationName)
    }

    /// Logs a message with option to include any additional information.
    private func log(
        _ level: LogLevel,
        error: Error? = nil,
        errorUrl: URL? = nil,
        id customErrorId: String? = nil,
        message: String? = nil,
        properties: EncodableDictionary? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column
    ) {
        // Construct an error with minimal information to avoid including potentially
        // any PII.
        var customError: NSError?

        if let error {
            #if DEBUG
            reportIssue(
                error,
                message ?? errorUrl?.absoluteString,
                fileID: file,
                line: line,
                column: column
            )
            #endif

            let nsError = error as NSError
            var errorDomain = error.id

            if let customErrorId = customErrorId, error.id == AppError.general.id {
                errorDomain = customErrorId
            }

            customError = NSError(
                domain: errorDomain,
                code: nsError.code,
                userInfo: ([
                    NSLocalizedDescriptionKey: error.title,
                    NSDebugDescriptionErrorKey: error.debugMessage,
                    NSFilePathErrorKey: "\(file):\(line)",
                    NSURLErrorKey: errorUrl,
                    NSUnderlyingErrorKey: nsError
                ] as [String: Any?]).compacted()
            )
        } else if let message {
            #if DEBUG
            debugLog(message, file: file, line: line)
            #endif
        }

        _log(level, message, customError, properties)
    }

    public func logError(
        _ error: Error,
        url: URL?,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column
    ) {
        log(
            error.logLevel ?? .debug,
            error: error,
            errorUrl: url,
            file: file,
            line: line,
            column: column
        )
    }
}

extension AppMonitoring {
    /// Logs a debug message with option to include any additional information.
    public func debug(
        _ error: Error? = nil,
        id customErrorId: String? = nil,
        errorUrl: URL? = nil,
        message: String? = nil,
        properties: EncodableDictionary? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column
    ) {
        log(
            .debug,
            error: error,
            errorUrl: errorUrl,
            id: customErrorId,
            message: message,
            properties: properties,
            file: file,
            line: line,
            column: column
        )
    }

    /// Logs a info message with option to include any additional information.
    public func info(
        _ error: Error? = nil,
        id customErrorId: String? = nil,
        message: String? = nil,
        properties: EncodableDictionary? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column
    ) {
        log(
            .info,
            error: error,
            id: customErrorId,
            message: message,
            properties: properties,
            file: file,
            line: line,
            column: column
        )
    }

    /// Logs a warning message with option to include any additional information.
    public func warn(
        _ error: Error? = nil,
        id customErrorId: String? = nil,
        message: String? = nil,
        properties: EncodableDictionary? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column
    ) {
        log(.warn,
            error: error,
            id: customErrorId,
            message: message,
            properties: properties,
            file: file,
            line: line,
            column: column
        )
    }

    /// Logs an error message with option to include any additional information.
    public func error(
        _ error: Error? = nil,
        id customErrorId: String? = nil,
        message: String? = nil,
        properties: EncodableDictionary? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column
    ) {
        log(
            .error,
            error: error,
            id: customErrorId,
            message: message,
            properties: properties,
            file: file,
            line: line,
            column: column
        )
    }

    /// Logs a critical message with option to include any additional information.
    public func critical(
        _ error: Error? = nil,
        id customErrorId: String? = nil,
        message: String? = nil,
        properties: EncodableDictionary? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column
    ) {
        log(.critical,
            error: error,
            id: customErrorId,
            message: message,
            properties: properties,
            file: file,
            line: line,
            column: column
        )
    }
}

// MARK: - Variants

extension AppMonitoring {
    /// Returns the noop variant of `AppMonitoring`.
    public static var noop: Self {
        .init(
            configure: {},
            setCollectionEnabled: { _ in },
            signin: { _ in },
            signout: {},
            log: { _, _, _, _ in },
            trace: { NoopAppTraceReporting(operationName: $0) }
        )
    }

    /// Returns the unimplemented variant of `AppMonitoring`.
    public static var unimplemented: Self {
        .init(
            configure: {
                reportIssue("\(Self.self).configure is unimplemented")
            },
            setCollectionEnabled: { _ in
                reportIssue("\(Self.self).setCollectionEnabled is unimplemented")
            },
            signin: { _ in
                reportIssue("\(Self.self).signin is unimplemented")
            },
            signout: {
                reportIssue("\(Self.self).signout is unimplemented")
            },
            log: { _, _, _, _ in
                reportIssue("\(Self.self).log is unimplemented")
            },
            trace: {
                UnimplementedAppTraceReporting(operationName: $0)
            }
        )
    }
}

// MARK: - Dependency

extension DependencyValues {
    private enum AppMonitoringKey: DependencyKey {
        static let liveValue: AppMonitoring = .unimplemented
        static let testValue: AppMonitoring = .unimplemented
        static let previewValue: AppMonitoring = .noop
    }

    public var appMonitoring: AppMonitoring {
        get { self[AppMonitoringKey.self] }
        set { self[AppMonitoringKey.self] = newValue }
    }
}
