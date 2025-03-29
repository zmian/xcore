//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import Combine

/// A class to forward app delegate phase events to the given send method.
///
/// **Usage**
///
/// ```swift
/// // 1. Create AppDelegate to send events to `AppPhaseClient`
///
/// final class AppDelegate: PhaseForwarderAppDelegate {
///     @Dependency(\.appPhase) var appPhase
///
///     override init() {
///         super.init()
///         send = { [weak self] in
///             self?.appPhase.send($0)
///         }
///     }
/// }
///
/// // 2. Create App to send events to `AppPhaseClient`
///
/// @main
/// struct ExampleApp: App {
///     @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
///     @Environment(\.scenePhase) private var scenePhase
///
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .onChange(of: scenePhase) { _, phase in
///                     // Forward all of the events to `AppPhaseClient`.
///                     AppPhase(phase).map(appDelegate.appPhase.send)
///                 }
///         }
///     }
/// }
///
/// // 3. Receive events from `AppPhaseClient`
///
/// final class SegmentAnalyticsProvider: AnalyticsProvider {
///     @Dependency(\.appPhase) private var appPhase
///     private var appPhaseTask: Task<Void, Never>?
///     private var segment: Segment.Analytics {
///         Segment.Analytics.shared()
///     }
///
///     ...
///
///     private func addObserver() {
///         appPhaseTask = Task {
///             for await appPhase in appPhase.receive.values {
///                 switch appPhase {
///                     case let .remoteNotificationsRegistered(.success(token)):
///                         segment.registeredForRemoteNotifications(withDeviceToken: token)
///                     case let .remoteNotificationsRegistered(.failure(error)):
///                         segment.failedToRegisterForRemoteNotificationsWithError(error)
///                     case let .remoteNotificationReceived(userInfo):
///                         segment.receivedRemoteNotification(userInfo)
///                     case let .continueUserActivity(activity, _):
///                         segment.continue(activity)
///                     case let .openUrl(url, options):
///                         segment.open(url.maskingSensitiveQueryItems(), options: options)
///                     default:
///                         break
///                 }
///             }
///         }
///     }
/// }
/// ```
open class PhaseForwarderAppDelegate: UIResponder, UIApplicationDelegate {
    private var cancellable: AnyCancellable?
    public var send: (AppPhase) -> Void = { _ in }

    open func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        send(.launched(launchOptions: launchOptions))
        addObservers()
        return true
    }

    // MARK: - Responding to App Life-Cycle Events

    open func applicationWillTerminate(_ application: UIApplication) {
        send(.willTerminate)
    }

    // MARK: - Handling Remote Notification Registration

    open func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        send(.remoteNotificationsRegistered(.success(deviceToken)))
    }

    open func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        send(.remoteNotificationsRegistered(.failure(error as NSError)))
    }

    open func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        send(.remoteNotificationReceived(userInfo: userInfo))
        completionHandler(.noData)
    }

    // MARK: - Opening a URL-Specified Resource

    open func application(
        _ application: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        send(.openUrl(url, options: options))
        return true
    }

    // MARK: - Continuing User Activity and Handling Quick Actions

    open func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        send(.continueUserActivity(userActivity, handler: restorationHandler))
        return true
    }

    open func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        send(.protectedDataDidBecomeAvailable)
    }
}

// MARK: - Phase Using Notifications

extension PhaseForwarderAppDelegate {
    private func addObservers() {
        cancellable = Publishers.MergeMany(
            NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
                .map { _ in AppPhase.willEnterForeground },
            NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
                .map { _ in AppPhase.active },
            NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
                .map { _ in AppPhase.inactive },
            NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
                .map { _ in AppPhase.background },
            NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
                .map { _ in AppPhase.memoryWarning },
            NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)
                .map { _ in AppPhase.significantTimeChange }
        ).sink { [weak self] event in
            self?.send(event)
        }
    }
}
