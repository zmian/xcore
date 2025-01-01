//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// Provides functionality for evaluating and receiving events for app’s state.
public struct AppStatusClient: Sendable {
    /// Receive the app status events.
    public let receive: ValuePublisher<AppStatus, Never>

    /// Receive session state change events.
    public let sessionState: ValuePublisher<AppStatus.SessionState, Never>

    /// Asks the app status client to evaluate the status.
    private let _evaluate: @Sendable () -> Void

    /// Transition the app to given session state.
    private let _changeSessionTo: @Sendable (AppStatus.SessionState) -> Void

    /// A method to purge cache (e.g., remote images), save the hash and re-evaluate
    /// the app state.
    ///
    /// - Warning: Do not purge any data that would force the user to sign in again.
    private let _systemForceRefresh: @Sendable () -> Void

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
        evaluate: @escaping @Sendable () -> Void,
        changeSessionTo: @escaping @Sendable (AppStatus.SessionState) -> Void,
        systemForceRefresh: @escaping @Sendable () -> Void
    ) {
        self.receive = receive
        self.sessionState = sessionState
        self._evaluate = evaluate
        self._changeSessionTo = changeSessionTo
        self._systemForceRefresh = systemForceRefresh
    }

    /// Asks the app status client to evaluate the status.
    public func evaluate() {
        _evaluate()
    }

    /// Transition the app to given session state.
    public func changeSession(to state: AppStatus.SessionState) {
        _changeSessionTo(state)
    }

    /// A method to purge cache (e.g., remote images), save the hash and re-evaluate
    /// the app state.
    ///
    /// - Warning: Do not purge any data that would force the user to sign in again.
    public func systemForceRefresh() {
        _systemForceRefresh()
    }
}

// MARK: - Helpers

extension AppStatusClient {
    /// A Boolean property indicating whether the application state is active,
    /// session is unlocked and protected data is available.
    ///
    /// This property is useful if you want to make an authenticated call on
    /// repeating cadence (timer or enter foreground) and only want to proceed if
    /// the call will succeed.
    ///
    /// - Note: Do not use this property to check for non-repeating API calls. You
    ///   should always send them as the system will automatically handle normal
    ///   calls and queue them if necessary.
    @MainActor
    public var isUserDataAvailable: Bool {
        let isApplicationActive = UIApplication.sharedOrNil?.applicationState != .background
        let isProtectedDataAvailable = UIApplication.shared.isProtectedDataAvailable
        return isApplicationActive && isProtectedDataAvailable && sessionState.value == .unlocked
    }
}

// MARK: - Variants

extension AppStatusClient {
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
            receive: {
                XCTFail("\(Self.self).receive is unimplemented")
                return .constant(.preparingLaunch)
            }(),
            sessionState: {
                XCTFail("\(Self.self).sessionState is unimplemented")
                return .constant(.signedOut)
            }(),
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

// MARK: - Dependency

extension DependencyValues {
    private enum AppStatusClientKey: DependencyKey {
        nonisolated(unsafe) static var liveValue: AppStatusClient = .noop
    }

    /// Provides functionality for evaluating and receiving events for app’s state.
    public var appStatus: AppStatusClient {
        get { self[AppStatusClientKey.self] }
        set { self[AppStatusClientKey.self] = newValue }
    }

    /// Provides functionality for evaluating and receiving events for app’s state.
    @discardableResult
    public static func appStatus(_ value: AppStatusClient) -> Self.Type {
        AppStatusClientKey.liveValue = value
        return Self.self
    }
}
