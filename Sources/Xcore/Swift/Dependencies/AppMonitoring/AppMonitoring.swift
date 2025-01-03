//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Returns the current value for `AppMonitoring` dependency.
public var am: AppMonitoring {
    #if DEBUG
    // We don't want to configure anything here for testing.
    if ProcessInfo.Arguments.isTesting {
        return .noop
    }
    #endif

    return Dependency(\.appMonitoring).wrappedValue
}

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
        file: StaticString = #fileID,
        line: UInt = #line
    ) {
        // Construct an error with minimal information to avoid including potentially
        // any PII.
        var customError: NSError?

        if let error {
            #if DEBUG
            debugLog(error, info: message ?? errorUrl?.absoluteString, file: file, line: line)
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

    public func logError(_ error: Error, url: URL?, file: StaticString = #fileID, line: UInt = #line) {
        log(
            error.logLevel ?? .debug,
            error: error,
            errorUrl: url,
            file: file,
            line: line
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
        file: StaticString = #fileID,
        line: UInt = #line
    ) {
        log(.debug, error: error, errorUrl: errorUrl, id: customErrorId, message: message, properties: properties, file: file, line: line)
    }

    /// Logs a info message with option to include any additional information.
    public func info(
        _ error: Error? = nil,
        id customErrorId: String? = nil,
        message: String? = nil,
        properties: EncodableDictionary? = nil,
        file: StaticString = #fileID,
        line: UInt = #line
    ) {
        log(.info, error: error, id: customErrorId, message: message, properties: properties, file: file, line: line)
    }

    /// Logs a warning message with option to include any additional information.
    public func warn(
        _ error: Error? = nil,
        id customErrorId: String? = nil,
        message: String? = nil,
        properties: EncodableDictionary? = nil,
        file: StaticString = #fileID,
        line: UInt = #line
    ) {
        log(.warn, error: error, id: customErrorId, message: message, properties: properties, file: file, line: line)
    }

    /// Logs an error message with option to include any additional information.
    public func error(
        _ error: Error? = nil,
        id customErrorId: String? = nil,
        message: String? = nil,
        properties: EncodableDictionary? = nil,
        file: StaticString = #fileID,
        line: UInt = #line
    ) {
        log(.error, error: error, id: customErrorId, message: message, properties: properties, file: file, line: line)
    }

    /// Logs a critical message with option to include any additional information.
    public func critical(
        _ error: Error? = nil,
        id customErrorId: String? = nil,
        message: String? = nil,
        properties: EncodableDictionary? = nil,
        file: StaticString = #fileID,
        line: UInt = #line
    ) {
        log(.critical, error: error, id: customErrorId, message: message, properties: properties, file: file, line: line)
    }
}

// MARK: - Variants

extension AppMonitoring {
    /// Returns noop variant of `AppMonitoring`.
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
}

// MARK: - Dependency

extension DependencyValues {
    private enum AppMonitoringKey: DependencyKey {
        nonisolated(unsafe) static var liveValue: AppMonitoring = .noop
    }

    public var appMonitoring: AppMonitoring {
        get { self[AppMonitoringKey.self] }
        set { self[AppMonitoringKey.self] = newValue }
    }

    @discardableResult
    public static func appMonitoring(_ value: AppMonitoring) -> Self.Type {
        AppMonitoringKey.liveValue = value
        return Self.self
    }
}
