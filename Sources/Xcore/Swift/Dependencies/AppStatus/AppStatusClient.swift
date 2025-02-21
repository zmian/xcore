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
    public let evaluate: @Sendable () -> Void

    /// Transition the app to given session state.
    private let _changeSessionTo: @Sendable (AppStatus.SessionState) -> Void

    /// A method to purge cache (e.g., remote images), save the hash and re-evaluate
    /// the app state.
    ///
    /// - Warning: Do not purge any data that would force the user to sign in again.
    public let systemForceRefresh: @Sendable () -> Void

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
        self.evaluate = evaluate
        self._changeSessionTo = changeSessionTo
        self.systemForceRefresh = systemForceRefresh
    }

    /// Transition the app to given session state.
    public func changeSession(to state: AppStatus.SessionState) {
        _changeSessionTo(state)
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
                reportIssue("\(Self.self).receive is unimplemented")
                return .constant(.preparingLaunch)
            }(),
            sessionState: {
                reportIssue("\(Self.self).sessionState is unimplemented")
                return .constant(.signedOut)
            }(),
            evaluate: {
                reportIssue("\(Self.self).evaluate is unimplemented")
            },
            changeSessionTo: { _ in
                reportIssue("\(Self.self).changeSessionTo is unimplemented")
            },
            systemForceRefresh: {
                reportIssue("\(Self.self).systemForceRefresh is unimplemented")
            }
        )
    }
}

// MARK: - Dependency

extension DependencyValues {
    private enum AppStatusClientKey: DependencyKey {
        static let liveValue: AppStatusClient = .unimplemented
        static let testValue: AppStatusClient = .unimplemented
        static let previewValue: AppStatusClient = .noop
    }

    /// Provides functionality for evaluating and receiving events for app’s state.
    public var appStatus: AppStatusClient {
        get { self[AppStatusClientKey.self] }
        set { self[AppStatusClientKey.self] = newValue }
    }
}
