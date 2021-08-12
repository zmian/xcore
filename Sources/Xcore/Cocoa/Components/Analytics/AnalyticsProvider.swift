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
/// import Segment
///
/// struct SegmentAnalyticsProvider: AnalyticsProvider {
///     init(writeKey: String) {
///         let configuration = AnalyticsConfiguration(writeKey: writeKey).apply {
///             $0.trackApplicationLifecycleEvents = true
///             $0.trackDeepLinks = true
///             $0.trackPushNotifications = true
///         }
///         Segment.Analytics.setup(with: configuration)
///     }
///
///     func track(_ event: AnalyticsEventProtocol) {
///         segment.track(event.name, properties: event.properties)
///     }
///
///     func identify(userId: String, traits: [String: Any]) {
///         segment.identify(userId, traits: traits)
///     }
///
///     func setEnabled(_ enable: Bool) {
///         enable ? segment.enable() : segment.disable()
///     }
///
///     func reset() {
///         segment.reset()
///     }
///
///     private var segment: Segment.Analytics {
///         Segment.Analytics.shared()
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
    ///   - event: The user id that should be used to identify all of the subsequent
    ///     events.
    ///   - traits: The dictionary of traits that should be used to identify all of
    ///     the subsequent events.
    func identify(userId: String, traits: [String: Any])

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

    public func identify(userId: String, traits: [String: Any]) {}
    public func setEnabled(_ enable: Bool) {}
    public func reset() {}
}
