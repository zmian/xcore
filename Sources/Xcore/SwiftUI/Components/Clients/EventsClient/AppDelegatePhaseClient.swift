//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// An indication of a app’s operational state.
public enum AppDelegatePhase: Hashable, CustomStringConvertible {
    /// Event invoked when the launch process is almost done and the app is almost
    /// ready to run.
    ///
    /// See documentation for [more info].
    ///
    /// [more info]: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622921-application
    case finishedLaunching

    // MARK: - Responding to App Life-Cycle Events

    /// Event invoked when the app has become active.
    ///
    /// See documentation for [more info].
    ///
    /// [more info]: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622956-applicationdidbecomeactive
    case didBecomeActive

    /// Event invoked when the app is about to become inactive.
    ///
    /// See documentation for [more info].
    ///
    /// [more info]: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622950-applicationwillresignactive
    case willResignActive

    /// Event invoked when the app is now in the background.
    ///
    /// See documentation for [more info].
    ///
    /// [more info]: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622997-applicationdidenterbackground
    case didEnterBackground

    /// Event invoked when the app is about to enter the foreground.
    ///
    /// See documentation for [more info].
    ///
    /// [more info]: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623076-applicationwillenterforeground
    case willEnterForeground

    /// Event invoked when the app is about to terminate.
    ///
    /// See documentation for [more info].
    ///
    /// [more info]: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623111-applicationwillterminate
    case willTerminate

    // MARK: - Handling Remote Notification Registration

    /// Event invoked when the app successfully registered with Apple Push
    /// Notification service (APNs) or when APNs cannot successfully complete the
    /// registration process.
    ///
    /// See documentation for more info [here] [and here].
    ///
    /// - Parameters:
    ///   - result: Result of the response from system on success returns
    ///     token; otherwise, the error. This result contains the following values:
    ///     - Data: A globally unique token that identifies this device to APNs.
    ///       Send this token to the server that you use to generate remote
    ///       notifications. Your server must pass this token unmodified back to
    ///       APNs when sending those remote notifications.
    ///
    ///       APNs device tokens are of variable length. Do not hard-code their
    ///       size.
    ///     - Error: An error object that encapsulates information why registration
    ///       did not succeed. The app can choose to display this information to the
    ///       user.
    ///
    /// [here]: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622958-application
    /// [and here]: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622962-application
    case remoteNotificationsRegistered(Result<Data, NSError>)

    /// Event invoked when a remote notification arrived that indicates there is
    /// data to be fetched.
    ///
    /// This event is invoked everytime device receives a payload regardless of app
    /// being in background or foreground.
    ///
    /// See documentation for [more info].
    ///
    /// [more info]: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623013-application
    case remoteNotificationReceived(userInfo: [AnyHashable: Any])

    // MARK: - Opening a URL-Specified Resource

    /// Event invoked asking the app to open a resource specified by a URL, and
    /// provides a dictionary of launch options.
    ///
    /// See documentation for [more info].
    ///
    /// - Parameters:
    ///   - url: The URL resource to open. This resource can be a network resource
    ///     or a file. For information about the Apple-registered URL schemes, see
    ///     ``Apple URL Scheme Reference``.
    ///   - options: A dictionary of URL handling options.
    ///
    /// [more info]: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623112-application
    case openUrl(URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:])

    // MARK: - Continuing User Activity and Handling Quick Actions

    /// Event invoked when the data for continuing an activity is available.
    ///
    /// See documentation for [more info].
    ///
    /// - Parameters:
    ///   - userActivity: The activity object containing the data associated with
    ///     the task the user was performing. Use the data to continue the user's
    ///     activity in your iOS app.
    ///   - restorationHandler: A block to execute if your app creates objects to
    ///     perform the task the user was performing. Calling this block is optional
    ///     and you can copy this block and call it at a later time. When calling a
    ///     saved copy of the block, you must call it from the app’s main thread.
    ///     This block has no return value and takes the following parameter:
    ///     - restorableObjects: An array of objects that conform to
    ///       ``UIUserActivityRestoring`` that represent the objects you created or
    ///       fetched in order to perform the operation. The system calls the
    ///       ``restoreUserActivityState(_:)`` method of each object in the array to
    ///       give it a chance to perform the operation.
    ///
    /// [more info]:https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623072-application
    case continueUserActivity(NSUserActivity, handler: ([UIUserActivityRestoring]?) -> Void)
}

// MARK: - CustomStringConvertible

extension AppDelegatePhase {
    public var description: String {
        switch self {
            case .finishedLaunching:
                return "finishedLaunching"
            case .didBecomeActive:
                return "didBecomeActive"
            case .willResignActive:
                return "willResignActive"
            case .didEnterBackground:
                return "didEnterBackground"
            case .willEnterForeground:
                return "willEnterForeground"
            case .willTerminate:
                return "willTerminate"
            case let .remoteNotificationsRegistered(.success(token)):
                return "remoteNotificationsRegistered(.success(\(token.hexEncodedString())))"
            case let .remoteNotificationsRegistered(.failure(error)):
                return "remoteNotificationsRegistered(.failure(\(error)))"
            case .remoteNotificationReceived:
                return "remoteNotificationReceived"
            case let .openUrl(url, options):
                return "openUrl(\(url), options: \(options))"
            case let .continueUserActivity(userActivity, _):
                return "continueUserActivity(\(userActivity), handler: ())"
        }
    }
}

// MARK: - Equatable

extension AppDelegatePhase {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case
                (.finishedLaunching, .finishedLaunching),
                (.didBecomeActive, .didBecomeActive),
                (.willResignActive, .willResignActive),
                (.didEnterBackground, .didEnterBackground),
                (.willEnterForeground, .willEnterForeground),
                (.willTerminate, .willTerminate):
                return true
            case let (.remoteNotificationsRegistered(lhs), .remoteNotificationsRegistered(rhs)):
                return lhs == rhs
            case let (.remoteNotificationReceived(lhs), .remoteNotificationReceived(rhs)):
                return lhs == rhs
            case let (.openUrl(lhs, lhsOptions), .openUrl(rhs, rhsOptions)):
                return lhs == rhs && lhsOptions == rhsOptions
            case let (.continueUserActivity(lhsActivity, lhsBlock), .continueUserActivity(rhsActivity, rhsBlock)):
                return lhsActivity == rhsActivity && String(reflecting: lhsBlock) == String(reflecting: rhsBlock)
            default:
                return false
        }
    }
}

// MARK: - Hashable

extension AppDelegatePhase {
    public func hash(into hasher: inout Hasher) {
        switch self {
            case .finishedLaunching,
                 .didBecomeActive,
                 .willResignActive,
                 .didEnterBackground,
                 .willEnterForeground,
                 .willTerminate:
                hasher.combine(description)
            case let .remoteNotificationsRegistered(value):
                hasher.combine(value)
            case let .remoteNotificationReceived(value):
                hasher.combine(String(reflecting: value))
            case let .openUrl(url, options):
                hasher.combine(url)
                hasher.combine(String(reflecting: options))
            case let .continueUserActivity(activity, block):
                hasher.combine(activity)
                hasher.combine(String(reflecting: block))
        }
    }
}

// MARK: - Dependency

/// Provides functionality for sending and receiving events for app’s
/// operational state.
///
/// **Usage**
///
/// 1. Send events to `AppDelegatePhaseClient`
///
/// ```swift
/// final class AppDelegate: UIResponder, UIApplicationDelegate {
///     @Dependency(\.appDelegatePhase) var appPhase
///
///     func application(
///         _ application: UIApplication,
///         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
///     ) -> Bool {
///         appPhase.send(.finishedLaunching)
///         return true
///     }
///
///     // MARK: - Responding to App Life-Cycle Events
///
///     func applicationDidBecomeActive(_ application: UIApplication) {
///         appPhase.send(.didBecomeActive)
///     }
///
///     func applicationWillResignActive(_ application: UIApplication) {
///         appPhase.send(.willResignActive)
///     }
///
///     func applicationDidEnterBackground(_ application: UIApplication) {
///         appPhase.send(.didEnterBackground)
///     }
///
///     func applicationWillEnterForeground(_ application: UIApplication) {
///         appPhase.send(.willEnterForeground)
///     }
///
///     func applicationWillTerminate(_ application: UIApplication) {
///         appPhase.send(.willTerminate)
///     }
///
///     // MARK: - Handling Remote Notification Registration
///
///     func application(
///         _ application: UIApplication,
///         didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
///     ) {
///         appPhase.send(.remoteNotificationsRegistered(.success(deviceToken)))
///     }
///
///     func application(
///         _ application: UIApplication,
///         didFailToRegisterForRemoteNotificationsWithError error: Error
///     ) {
///         appPhase.send(.remoteNotificationsRegistered(.failure(error as NSError)))
///     }
///
///     func application(
///         _ application: UIApplication,
///         didReceiveRemoteNotification userInfo: [AnyHashable: Any],
///         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
///     ) {
///         appPhase.send(.remoteNotificationReceived(userInfo: userInfo))
///         completionHandler(.noData)
///     }
///
///     // MARK: - Opening a URL-Specified Resource
///
///     func application(
///         _ application: UIApplication,
///         open url: URL,
///         options: [UIApplication.OpenURLOptionsKey: Any] = [:]
///     ) -> Bool {
///         appPhase.send(.openUrl(url, options: options))
///         return true
///     }
///
///     // MARK: - Continuing User Activity and Handling Quick Actions
///
///     func application(
///         _ application: UIApplication,
///         continue userActivity: NSUserActivity,
///         restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
///     ) -> Bool {
///         appPhase.send(.continueUserActivity(userActivity, handler: restorationHandler))
///         return true
///     }
/// }
/// ```
/// 2. Receive events from `AppDelegatePhaseClient`
///
/// ```swift
/// struct SegmentAnalyticsProvider: AnalyticsProvider {
///     @Dependency(\.appDelegatePhase) private var appPhase
///     private var cancellable: AnyCancellable?
///
///     ...
///
///     private mutating func addListener() {
///         cancellable = appPhase.receive.sink { phase in
///             let segment = Segment.Analytics.shared()
///
///             switch phase {
///                 case let .remoteNotificationsRegistered(.success(token)):
///                     segment.registeredForRemoteNotifications(withDeviceToken: token)
///                 case let .remoteNotificationsRegistered(.failure(error)):
///                     segment.failedToRegisterForRemoteNotificationsWithError(error)
///                 case let .remoteNotificationReceived(userInfo):
///                     segment.receivedRemoteNotification(userInfo)
///                 case let .continueUserActivity(activity, _):
///                     segment.continue(activity)
///                 case let .openUrl(url, options):
///                     segment.open(url, options: options)
///                 default:
///                     break
///             }
///         }
///     }
/// }
/// ```
public typealias AppDelegatePhaseClient = EventsClient<AppDelegatePhase>

extension DependencyValues {
    private struct AppDelegatePhaseClientKey: DependencyKey {
        static let defaultValue: AppDelegatePhaseClient = .live
    }

    /// Provides functionality for sending and receiving events for app’s
    /// operational state.
    public var appDelegatePhase: AppDelegatePhaseClient {
        get { self[AppDelegatePhaseClientKey.self] }
        set { self[AppDelegatePhaseClientKey.self] = newValue }
    }

    /// Provides functionality for sending and receiving events for app’s
    /// operational state.
    @discardableResult
    public static func appDelegatePhase(_ value: AppDelegatePhaseClient) -> Self.Type {
        set(\.appDelegatePhase, value)
        return Self.self
    }
}
