//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// An indication of a app’s operational state.
public enum AppPhase: Hashable, CustomStringConvertible {
    /// Event invoked when the launch process is almost done and the app is almost
    /// ready to run.
    ///
    /// See documentation for [more info].
    ///
    /// - Parameter options: A dictionary indicating the reason the app was launched
    ///   (if any). The contents of this dictionary may be empty in situations where
    ///   the user launched the app directly. For information about the possible
    ///   keys in this dictionary and how to handle them, see
    ///   [UIApplication.LaunchOptionsKey].
    ///
    /// [more info]: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622921-application
    /// [UIApplication.LaunchOptionsKey]: https://developer.apple.com/documentation/uikit/uiapplication/launchoptionskey
    case launched(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)

    // MARK: - Responding to App Life-Cycle Events

    /// Event invoked when the scene is in the foreground and interactive.
    ///
    /// An active scene isn’t necessarily front-most. For example, a macOS window
    /// might be active even if it doesn’t currently have focus. Nevertheless, all
    /// scenes should operate normally in this phase.
    ///
    /// An app or custom scene in this phase contains at least one active scene
    /// instance.
    ///
    /// See documentation for [more info].
    ///
    /// [more info]: https://developer.apple.com/documentation/swiftui/scenephase/active
    case active

    /// Event invoked when the scene is in the foreground but should pause its work.
    ///
    /// A scene in this phase doesn’t receive events and should pause timers and
    /// free any unnecessary resources. The scene might be completely hidden in the
    /// user interface or otherwise unavailable to the user. In macOS, scenes only
    /// pass through this phase temporarily on their way to the `background` phase.
    ///
    /// An app or custom scene in this phase contains no scene instances in the
    /// `active` phase.
    ///
    /// See documentation for [more info].
    ///
    /// [more info]: https://developer.apple.com/documentation/swiftui/scenephase/inactive
    case inactive

    /// Event invoked when the scene isn’t currently visible in the UI.
    ///
    /// Do as little as possible in a scene that’s in the background phase. The
    /// background phase can precede termination, so do any cleanup work immediately
    /// upon entering this state. For example, close any open files and network
    /// connections. However, a scene can also return to the `active` phase from the
    /// background.
    ///
    /// Expect an app that enters the background phase to terminate.
    ///
    /// See documentation for [more info].
    ///
    /// [more info]: https://developer.apple.com/documentation/swiftui/scenephase/background
    case background

    /// TODO: ⚠️ Need to wire this event up, ``SwiftUI.ScenePhase`` doesn't have equivalent.
    ///
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

// MARK: - Convenience

extension AppPhase {
    public init?(_ phase: ScenePhase) {
        switch phase {
            case .active:
                self = .active
            case .inactive:
                self = .inactive
            case .background:
                self = .background
            @unknown default:
                return nil
        }
    }
}

// MARK: - CustomStringConvertible

extension AppPhase {
    public var description: String {
        switch self {
            case .launched:
                return "launched"
            case .active:
                return "active"
            case .inactive:
                return "inactive"
            case .background:
                return "background"
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

extension AppPhase {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case
            (.launched, .launched),
            (.active, .active),
            (.inactive, .inactive),
            (.background, .background),
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

extension AppPhase {
    public func hash(into hasher: inout Hasher) {
        switch self {
            case .launched,
                 .active,
                 .inactive,
                 .background,
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
///                 .onChange(of: scenePhase) { phase in
///                     // Forward all of the events to `AppPhaseClient`.
///                     AppPhase(phase).map(appDelegate.appPhase.send)
///                 }
///         }
///     }
/// }
///
/// // 3. Receive events from `AppPhaseClient`
///
/// struct SegmentAnalyticsProvider: AnalyticsProvider {
///     @Dependency(\.appPhase) var appPhase
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
public typealias AppPhaseClient = EventsClient<AppPhase>

extension DependencyValues {
    private struct AppPhaseClientKey: DependencyKey {
        static let defaultValue: AppPhaseClient = .live
    }

    /// Provides functionality for sending and receiving events for app’s
    /// operational state.
    public var appPhase: AppPhaseClient {
        get { self[AppPhaseClientKey.self] }
        set { self[AppPhaseClientKey.self] = newValue }
    }

    /// Provides functionality for sending and receiving events for app’s
    /// operational state.
    @discardableResult
    public static func appPhase(_ value: AppPhaseClient) -> Self.Type {
        set(\.appPhase, value)
        return Self.self
    }
}
