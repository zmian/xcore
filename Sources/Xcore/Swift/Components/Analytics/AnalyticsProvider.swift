//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type that can track events.
///
/// **Usage**
///
/// An example of Segment analytics provider:
///
/// ```swift
/// @_implementationOnly import Segment
///
/// struct SegmentAnalyticsProvider: AnalyticsProvider {
///     @Dependency(\.appPhase) private var appPhase
///     private var cancellable: AnyCancellable?
///     private var segment: Segment.Analytics {
///         Segment.Analytics.shared()
///     }
///
///     init(writeKey: String) {
///         let configuration = AnalyticsConfiguration(writeKey: writeKey).apply {
///             $0.trackApplicationLifecycleEvents = true
///             $0.trackDeepLinks = true
///             $0.trackPushNotifications = true
///
///             #if DEBUG
///             if AppInfo.isDebuggerAttached {
///                 $0.flushInterval = 1
///                 Segment.Analytics.debug(true)
///             }
///             #endif
///         }
///         Segment.Analytics.setup(with: configuration)
///
///         withDelay(0.3) { [weak self] in
///             // Delay to avoid:
///             // Thread 1: Simultaneous accesses to 0x1107dbc18, but modification requires
///             // exclusive access. This is a client that invokes other clients.
///             self?.addListener()
///         }
///     }
///
///     func track(_ event: AnalyticsEventProtocol) {
///         segment.track(event.name, properties: event.properties)
///     }
///
///     func identify(userId: String?, traits: [String: Encodable]) {
///         segment.identify(userId, traits: traits)
///     }
///
///     func setEnabled(_ enable: Bool) {
///         enable ? segment.enable() : segment.disable()
///     }
///
///     func reset() {
///         segment.flush()
///         segment.reset()
///     }
///     
///     private func addListener() {
///         cancellable = appPhase.receive.sink { phase in
///             let segment = Segment.Analytics.shared()
///
///             switch phase {
///                 case let .launched(launchOptions):
///                     SEGAppboyIntegrationFactory.instance().saveLaunchOptions(launchOptions)
///                 case let .remoteNotificationsRegistered(.success(token)):
///                     segment.registeredForRemoteNotifications(withDeviceToken: token)
///                 case let .remoteNotificationsRegistered(.failure(error)):
///                     segment.failedToRegisterForRemoteNotificationsWithError(error)
///                 case let .remoteNotificationReceived(userInfo):
///                     segment.receivedRemoteNotification(userInfo)
///                 case let .continueUserActivity(activity, _):
///                     segment.continue(activity)
///                 case let .openUrl(url, options):
///                     segment.open(url.maskingSensitiveQueryItems(), options: options)
///                 default:
///                     break
///             }
///         }
///     }
/// }
/// ```
public protocol AnalyticsProvider {
    /// A unique id for the analytics provider.
    var id: String { get }

    /// Track the given event.
    ///
    /// - Parameter event: The event to track.
    func track(_ event: AnalyticsEventProtocol)

    /// A method to identify the provider with given user id and traits.
    ///
    /// - Parameters:
    ///   - userId: The user id that should be used to identify all of the
    ///     subsequent events.
    ///   - traits: The dictionary of traits that should be used to identify all of
    ///     the subsequent events.
    func identify(userId: String?, traits: [String: Encodable])

    /// A method to disable all data collection for the provider.
    ///
    /// Depending on the audience for your app, you might need to offer the ability
    /// for users to opt-out of analytics data collection from inside your app.
    func setEnabled(_ enable: Bool)

    /// A method to clear provider for the current user.
    ///
    /// This is useful for apps where users can sign in and out with different
    /// identities over time.
    func reset()
}

// MARK: - Default Implementation

extension AnalyticsProvider {
    public var id: String {
        name(of: self)
    }

    public func identify(userId: String?, traits: [String: Encodable]) {}
    public func setEnabled(_ enable: Bool) {}
    public func reset() {}
}
