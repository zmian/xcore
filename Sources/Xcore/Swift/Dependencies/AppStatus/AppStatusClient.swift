//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// Provides functionality for evaluating and receiving events for app’s state.
public protocol AppStatusClient {
    /// Receive the app status events.
    var receive: ValuePublisher<AppStatus, Never> { get }

    /// Receive session state change events.
    var sessionState: ValuePublisher<AppStatus.SessionState, Never> { get }

    /// Asks the app status client to evaluate the status.
    func evaluate()

    /// Transition the app to given session state.
    func changeSession(to state: AppStatus.SessionState)

    /// A method to purge cache (e.g., remote images), save the hash and re-evaluate
    /// the app state.
    ///
    /// - Warning: Do not purge any data that would force the user to sign in again.
    func systemForceRefresh()
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
    public var isUserDataAvailable: Bool {
        let isApplicationActive = UIApplication.sharedOrNil?.applicationState != .background
        let isProtectedDataAvailable = UIApplication.shared.isProtectedDataAvailable
        return isApplicationActive && isProtectedDataAvailable && sessionState.value == .unlocked
    }
}

// MARK: - Dependency

extension DependencyValues {
    private struct AppStatusClientKey: DependencyKey {
        static var liveValue: AppStatusClient = .noop
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
