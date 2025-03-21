//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UserNotifications)
import Foundation
import UserNotifications

/// Provides functionality for managing push notification-related activities.
public struct PushNotificationsClient: Sendable {
    /// Query the system and returns current authorization status.
    public var authorizationStatus: @Sendable () async -> AuthorizationStatus

    /// Events produced from notifications client.
    public var events: @Sendable () -> AsyncStream<Event>

    /// Registers to receive remote notifications through Apple Push Notification
    /// service.
    ///
    /// This method first requests authorization so remote notifications can display
    /// alerts, play sounds, or perform other user-facing actions and then on
    /// success calls ``UIApplication.shared.registerForRemoteNotifications()`` to
    /// receive remote notifications through Apple Push Notification service.
    ///
    /// Call this method to initiate the registration process with Apple Push
    /// Notification service. If registration succeeds, the app calls your app
    /// delegate object’s
    /// ``application(_:didRegisterForRemoteNotificationsWithDeviceToken:)`` method
    /// and passes it a device token. You should pass this token along to the server
    /// you use to generate remote notifications for the device. If registration
    /// fails, the app calls its app delegate’s
    /// ``application(_:didFailToRegisterForRemoteNotificationsWithError:)`` method
    /// instead.
    public var register: @Sendable () async -> Void

    /// Unregisters for all remote notifications received through Apple Push
    /// Notification service.
    ///
    /// You should call this method in rare circumstances only, such as when a new
    /// version of the app removes support for all types of remote notifications.
    /// Users can temporarily prevent apps from receiving remote notifications
    /// through the Notifications section of the Settings app. Apps unregistered
    /// through this method can always re-register.
    public var unregister: @Sendable () -> Void

    /// Attempts to open App Settings so the user can allow notifications.
    public var openAppSettings: @Sendable () -> Void

    /// Creates a client for managing push notification-related activities.
    ///
    /// - Parameters:
    ///   - authorizationStatus: The closure to return app’s current authorization
    ///     status.
    ///   - events: An asynchronous sequence that produces push notifications client
    ///     events.
    ///   - register: The closure to register to receive remote notifications
    ///     through Apple Push Notification service.
    ///   - unregister: The closure to unregister for all remote notifications
    ///     received through Apple Push Notification service.
    ///   - openAppSettings: The closure to open app’s notification settings in the
    ///     Settings app.
    public init(
        authorizationStatus: @escaping @Sendable () async -> AuthorizationStatus,
        events: @escaping @Sendable () -> AsyncStream<Event>,
        register: @escaping @Sendable () async -> Void,
        unregister: @escaping @Sendable () -> Void,
        openAppSettings: @escaping @Sendable () -> Void
    ) {
        self.authorizationStatus = authorizationStatus
        self.events = events
        self.register = register
        self.unregister = unregister
        self.openAppSettings = openAppSettings
    }
}

// MARK: - Authorization Status

extension PushNotificationsClient {
    /// An enumeration representing app’s authorization status for scheduling
    /// notifications.
    public enum AuthorizationStatus: Sendable, Hashable, CustomStringConvertible, CustomAnalyticsValueConvertible {
        /// The user hasn’t yet made a choice about whether the app is allowed to
        /// schedule notifications or receive notifications.
        case notDetermined

        /// The app isn’t authorized to schedule or receive notifications.
        case denied

        /// The app is authorized to schedule or receive notifications.
        case authorized

        public var description: String {
            switch self {
                case .notDetermined: "Not Determined"
                case .denied: "Denied"
                case .authorized: "Authorized"
            }
        }

        public var analyticsValue: String {
            switch self {
                case .notDetermined: "not_determined"
                case .denied: "denied"
                case .authorized: "authorized"
            }
        }
    }
}

// MARK: - Event

extension PushNotificationsClient {
    /// An enumeration representing events generated by push notifications client.
    public enum Event: Sendable, Hashable, CustomStringConvertible {
        /// The Authorization status changed.
        ///
        /// - Parameter status: The current status of notification authorization.
        case changedAuthorization(status: AuthorizationStatus)

        /// The result is received from the system’s push notifications request dialog.
        ///
        /// - Parameter result: Result of the response from dialog.
        case requestedAuthorization(Result<Bool, NSError>)

        /// App is launched from a push notification.
        ///
        /// Asks the delegate to process the user’s response to a delivered
        /// notification.
        ///
        /// Use this event to process the user’s response to a notification. If the
        /// user selected one of your app’s custom actions, the response parameter
        /// contains the identifier for that action. (The response can also indicate
        /// that the user dismissed the notification interface, or launched your app,
        /// without selecting a custom action.) At the end of your implementation, call
        /// the ``completionHandler`` block to let the system know that you are done
        /// processing the user’s response. If you do not implement this method, your
        /// app never responds to custom actions.
        ///
        /// - Parameter handler: The handler of the push notification.
        case openedAppFromNotification(handler: NotificationReceivedHandler)

        /// User unregistered from push notifications service.
        case unregistered

        public var description: String {
            switch self {
                case let .changedAuthorization(status):
                    "Changed Authorization: \(status)"
                case let .requestedAuthorization(.success(granted)):
                    "Requested Authorization: .success(granted: \(granted))"
                case let .requestedAuthorization(.failure(error)):
                    "Requested Authorization: .failure(\(error))"
                case let .openedAppFromNotification(id):
                    "Opened App From Notification: \(id)"
                case .unregistered:
                    "Unregistered"
            }
        }
    }
}

// MARK: - Notification Received

extension PushNotificationsClient {
    /// ``userNotificationCenter(_:didReceive:withCompletionHandler:)``
    public struct NotificationReceivedHandler: @unchecked Sendable, Hashable {
        /// The shared user notification center object that received the notification.
        public let center: UNUserNotificationCenter

        /// The user’s response to the notification. This object contains the original
        /// notification and the identifier string for the selected action. If the
        /// action allowed the user to provide a textual response, this parameter
        /// contains a ``UNTextInputNotificationResponse`` object.
        public let response: UNNotificationResponse

        /// The block to execute when you have finished processing the user’s response.
        /// You must execute this block at some point after processing the user’s
        /// response to let the system know that you are done. The block has no return
        /// value or parameters.
        public let completion: () -> Void

        /// A convenience property, returning dictionary of custom information
        /// associated with the notification.
        ///
        /// For remote notifications, this property contains the entire notification
        /// payload. For local notifications, you configure the property directly before
        /// scheduling the notification.
        public var userInfo: [AnyHashable: Any] {
            response.notification.request.content.userInfo
        }

        public init(
            center: UNUserNotificationCenter,
            response: UNNotificationResponse,
            completion: @escaping () -> Void
        ) {
            self.center = center
            self.response = response
            self.completion = completion
        }

        public static func ==(lhs: Self, rhs: Self) -> Bool {
            lhs.center == rhs.center && lhs.response == rhs.response
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(center)
            hasher.combine(response)
        }
    }
}

// MARK: - Convenience

extension PushNotificationsClient {
    public func register(_ shouldRegister: Bool) async {
        await shouldRegister ? register() : unregister()
    }
}

// MARK: - Dependency

extension DependencyValues {
    private enum PushNotificationsClientKey: DependencyKey {
        static let liveValue: PushNotificationsClient = .live
        static let testValue: PushNotificationsClient = .unimplemented
        static let previewValue: PushNotificationsClient = .noop
    }

    /// Provides functionality for managing push notification-related activities.
    public var pushNotifications: PushNotificationsClient {
        get { self[PushNotificationsClientKey.self] }
        set { self[PushNotificationsClientKey.self] = newValue }
    }
}
#endif
