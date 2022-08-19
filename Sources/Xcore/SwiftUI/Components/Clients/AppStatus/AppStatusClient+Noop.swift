//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct NoopAppStatusClient: AppStatusClient {
    public let receive: ValuePublisher<AppStatus, Never> = .constant(.preparingLaunch)
    public let sessionState: ValuePublisher<AppStatus.SessionState, Never> = .constant(.signedOut)
    public func evaluate() {}
    public func changeSession(to state: AppStatus.SessionState) {}
    public func systemForceRefresh() {}
}

// MARK: - Dot Syntax Support

extension AppStatusClient where Self == NoopAppStatusClient {
    /// Returns noop variant of `AppStatusClient`.
    public static var noop: Self {
        .init()
    }
}
