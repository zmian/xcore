//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//
// swiftlint:disable for_where

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

    /// Emits an event when the app should attempt to auto-prompt the user to unlock
    /// their locked session.
    ///
    /// This event is triggered when:
    /// - The user **cold launches** the app.
    /// - The app **enters the foreground** after being inactive.
    ///
    /// The purpose of this event is to prompt the user to **auto-unlock** their
    /// session when necessary.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// // 1. Create `SessionLockScreen` view modifier.
    ///
    /// extension View {
    ///     /// The content view is automatically displayed when app transitions to
    ///     /// session lock state.
    ///     public func sessionLockScreen() -> some View {
    ///         modifier(SessionLockScreen())
    ///     }
    /// }
    ///
    /// // MARK: - ViewModifier
    ///
    /// private struct SessionLockScreen: ViewModifier {
    ///     @Dependency(\.appStatus) private var appStatus
    ///     @State private var isLocked: Bool
    ///
    ///     init() {
    ///         let state = Dependency(\.appStatus).wrappedValue.sessionState.value
    ///         _isLocked = .init(initialValue: state.isLocked)
    ///     }
    ///
    ///     func body(content: Content) -> some View {
    ///         content
    ///             .opacity(isLocked ? 0 : 1)
    ///             .overlay {
    ///                 lockScreen
    ///                     .hidden(!isLocked)
    ///             }
    ///             .overlayScreen(isPresented: $isLocked, style: .sessionLock) {
    ///                 lockScreen
    ///             }
    ///             .onReceive(appStatus.sessionState) { sessionState in
    ///                 isLocked = sessionState.isLocked
    ///             }
    ///             .task {
    ///                 for await _ in appStatus.onAutoUnlockSession where isLocked {
    ///                     performUnlock()
    ///                 }
    ///             }
    ///     }
    ///
    ///     private func performUnlock() {
    ///         appStatus.changeSession(to: .unlocked)
    ///     }
    ///
    ///     private var lockScreen: some View {
    ///         SplashView()
    ///     }
    /// }
    ///
    /// // MARK: - Window Style
    ///
    /// extension WindowStyle {
    ///     /// The style for a session lock screen.
    ///     ///
    ///     /// It appear on top of your app's main window, status bar and alerts, but below
    ///     /// privacy screen.
    ///     fileprivate static var sessionLock: Self {
    ///         .init(label: "Session Lock Screen", level: .privacy - 1)
    ///     }
    /// }
    ///
    /// // MARK: - Session State
    ///
    /// extension AppStatus.SessionState {
    ///     /// We want to only hide the lock screen when session is unlocked. If user taps
    ///     /// sign out button, we don't want to dismiss the lock screen and transition to
    ///     /// onboarding view simultaneously.
    ///     fileprivate var isLocked: Bool {
    ///         self != .unlocked
    ///     }
    /// }
    ///
    /// // 2. Attach `SessionLockScreen` view modifier to the root of the appliction.
    /// @main
    /// struct ExampleApp: App {
    ///     var body: some Scene {
    ///         WindowGroup {
    ///             ContentView()
    ///                 .sessionLockScreen()
    ///         }
    ///     }
    /// }
    /// ```
    public var onAutoUnlockSession: AsyncStream<Void> {
        AsyncStream { continuation in
            @Dependency(\.appPhase) var appPhase

            if isColdLaunch.value {
                continuation.yield()
                isColdLaunch.setValue(false)
            }

            Task {
                for await _ in appPhase.receive.when(.willEnterForeground).values {
                    if !isColdLaunch.value {
                        continuation.yield()
                    }
                }
            }
        }
    }
}

private let isColdLaunch = LockIsolated(true)

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
