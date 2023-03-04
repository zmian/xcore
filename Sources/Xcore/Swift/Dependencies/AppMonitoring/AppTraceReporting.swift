//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A protocol for app tracing.
///
/// **Usage**
///
/// ```swift
/// struct Database {
///     @Dependency(\.appMonitoring) private static var appMonitoring
///
///     init {
///         let trace = appMonitoring.trace(operationName: "db.init")
///         // ...
///         trace.setTag("step", value: "encryption")
///         // ...
///         trace.setError(error)
///         // ...
///         trace.finish()
///     }
/// }
/// ```
///
/// **Child Trace**
///
/// ```swift
/// struct Database {
///     @Dependency(\.appMonitoring) private static var appMonitoring
///
///     init {
///         let trace = appMonitoring.trace(operationName: "db.init")
///         // ...
///         trace.setTag("step", value: "encryption")
///         try encryption()
///         // ...
///         trace.setError(error)
///         // ...
///         trace.finish()
///     }
///
///     private func encryption() throws {
///         // Child trace of "db.init" operation.
///         let trace = try appMonitoring.trace(operationName: "db.init.encryption")
///         defer { trace.finish() }
///
///         do {
///             // ...
///         } catch {
///             trace.setError(error)
///             throw error
///         }
///     }
/// }
/// ```
public protocol AppTraceReporting {
    init(operationName: String)
    func setTag(_ key: String, value: Encodable)
    func setError(_ error: Error, file: StaticString, line: UInt)
    func finish()
}

extension AppTraceReporting {
    public func setError(_ error: Error, file: StaticString = #fileID, line: UInt = #line) {
        setError(error, file: file, line: line)
    }
}

// MARK: - Variants

public struct NoopAppTraceReporting: AppTraceReporting {
    public init(operationName: String) {}
    public func setTag(_ key: String, value: Encodable) {}
    public func setError(_ error: Error, file: StaticString, line: UInt) {}
    public func finish() {}
}
