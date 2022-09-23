//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UserNotifications)
import SwiftUI
import UserNotifications
import AsyncAlgorithms

// MARK: - Live

extension PushNotificationsClient {
    public static var live: Self {
        let client = LivePushNotificationsClient()

        return .init(
            authorizationStatus: client.authorizationStatus,
            events: client.stream.makeAsyncStream(),
            register: client.register,
            unregister: client.unregister,
            openAppSettings: client.openAppSettings
        )
    }
}

// MARK: - Internal

private final class LivePushNotificationsClient: NSObject {
    typealias Event = PushNotificationsClient.Event
    typealias AuthorizationStatus = PushNotificationsClient.AuthorizationStatus
    @Dependency(\.appPhase) private var appPhase
    private var center: UNUserNotificationCenter { .current() }
    fileprivate let stream = AsyncPassthroughStream<Event>()
    private var notificationTask: Task<(), Never>?
    private var currentAuthorizationStatus: AuthorizationStatus = .notDetermined

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        addObserver()
    }

    deinit {
        notificationTask?.cancel()
        notificationTask = nil
    }

    private func addObserver() {
        notificationTask = Task {
            // On foreground, get authorization status in case user goes into the System
            // Settings and toggled the notifications settings.
            for await _ in await NotificationCenter.async(UIApplication.willEnterForegroundNotification) {
                // Get the latest authorization status so that `events` stream can receives
                // the latest authorization status after the app enters foreground (If user
                // toggles the notification settings in the system Settings.app).
                _ = await authorizationStatus()
            }
        }
    }

    func authorizationStatus() async -> AuthorizationStatus {
        let settings = await center.notificationSettings()

        let status: AuthorizationStatus

        switch settings.authorizationStatus {
            case .notDetermined:
                status = .notDetermined
            case .denied:
                status = .denied
            case .authorized, .provisional, .ephemeral:
                status = .authorized
            @unknown default:
                status = .notDetermined
        }

        // Send the status updates to the events stream if it's different then the last
        // one.
        if status != currentAuthorizationStatus {
            currentAuthorizationStatus = status
            stream.send(.changedAuthorization(status: status))
        }

        return status
    }

    func register() async {
        switch await authorizationStatus() {
            case .notDetermined:
                do {
                    let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])

                    if granted {
                        registerForRemoteNotifications(true)
                    }

                    stream.send(.requestedAuthorization(.success(granted)))
                } catch {
                    stream.send(.requestedAuthorization(.failure(error as NSError)))
                }

                // Get the latest authorization status so that `events` stream can receives
                // the latest authorization status after the register call.
                _ = await authorizationStatus()
            case .authorized:
                registerForRemoteNotifications(true)
            case .denied:
                openAppSettings()
        }
    }

    func unregister() {
        registerForRemoteNotifications(false)
        stream.send(.unregistered)
    }

    func openAppSettings() {
        #warning("FIXME: Fix the open settings up. Uncommenting causes segmentation fault 11")
//        typealias L = Localized.PushNotifications.OpenSystemSettings
//
//        Popup.show(title: L.title, message: L.message) { $isPresented in
//            Button(L.buttonOpenSettings) {
//                Dependency(\.openUrl).wrappedValue(.settingsApp)
//                isPresented = false
//            }
//            .buttonStyle(.primary)
//
//            Button.cancel {
//                isPresented = false
//            }
//            .buttonStyle(.secondary)
//        }
    }

    private func registerForRemoteNotifications(_ register: Bool) {
        Task { @MainActor in
            if register {
                UIApplication.sharedOrNil?.registerForRemoteNotifications()
            } else {
                UIApplication.sharedOrNil?.unregisterForRemoteNotifications()
            }
        }
    }
}

// MARK: - Delegate

extension LivePushNotificationsClient: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let handler = PushNotificationsClient.NotificationReceivedHandler(
            center: center,
            response: response,
            completion: completionHandler
        )

        stream.send(.openedAppFromNotification(handler: handler))
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        appPhase.send(.remoteNotificationReceived(userInfo: userInfo))
        completionHandler([.banner])
    }
}
#endif
