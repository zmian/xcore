//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Creates an app status client using closure.
public struct BlockAppStatusClient: AppStatusClient {
    private let _evaluate: () -> Void
    private let _changeSessionTo: (AppStatus.SessionState) -> Void
    private let _systemForceRefresh: () -> Void
    public let receive: ValuePublisher<AppStatus, Never>
    public let sessionState: ValuePublisher<AppStatus.SessionState, Never>

    /// Creates an app status client.
    ///
    /// - Parameters:
    ///   - receive: Emit events when the app status changes.
    ///   - sessionState: Emit events when the app session state changes.
    ///   - evaluate: App status client to evaluate the app status.
    ///   - changeSessionTo: Transition the app to given session state.
    ///   - systemForceRefresh: Purge app cache, save refresh hash and
    ///     re-evaluate the app state. Warning: Do not purge any data that would
    ///     force the user to sign in again.
    public init(
        receive: ValuePublisher<AppStatus, Never>,
        sessionState: ValuePublisher<AppStatus.SessionState, Never>,
        evaluate: @escaping () -> Void,
        changeSessionTo: @escaping (AppStatus.SessionState) -> Void,
        systemForceRefresh: @escaping () -> Void
    ) {
        self.receive = receive
        self.sessionState = sessionState
        self._evaluate = evaluate
        self._changeSessionTo = changeSessionTo
        self._systemForceRefresh = systemForceRefresh
    }

    public func evaluate() {
        _evaluate()
    }

    public func changeSession(to state: AppStatus.SessionState) {
        _changeSessionTo(state)
    }

    public func systemForceRefresh() {
        _systemForceRefresh()
    }
}

// MARK: - Variants

extension AppStatusClient where Self == BlockAppStatusClient {
    /// Returns noop variant of `AppStatusClient`.
    public static var noop: Self {
        .init(
            receive: .constant(.preparingLaunch),
            sessionState: .constant(.signedOut),
            evaluate: {},
            changeSessionTo: { _ in },
            systemForceRefresh: {}
        )
    }

    /// Returns unimplemented variant of `AppStatusClient`.
    public static var unimplemented: Self {
        .init(
            receive: .constant(.preparingLaunch),
            sessionState: .constant(.signedOut),
            evaluate: {
                XCTFail("\(Self.self).evaluate is unimplemented")
            },
            changeSessionTo: { _ in
                XCTFail("\(Self.self).changeSessionTo is unimplemented")
            },
            systemForceRefresh: {
                XCTFail("\(Self.self).systemForceRefresh is unimplemented")
            }
        )
    }
}
