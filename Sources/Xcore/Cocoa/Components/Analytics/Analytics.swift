//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - AnalyticsEvent

public protocol AnalyticsEventProtocol {
    /// The name of the event that is sent to analytics providers.
    var name: String { get }

    /// The properties of the event that is sent to analytics providers.
    var properties: [String: Any]? { get }

    /// An option to send this event to additional analytics providers.
    ///
    /// For example, if a specific event should be tracked in Firebase, then, the
    /// said event can return `Firebase` analytics provider as the additional
    /// provider.
    var additionalProviders: [AnalyticsProvider]? { get }
}

// MARK: - AnalyticsProvider

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

extension AnalyticsProvider {
    public var id: String {
        name(of: self)
    }

    public func identify(userId: String, traits: [String: Any]) {}
    public func setEnabled(_ enable: Bool) {}
    public func reset() {}
}

// MARK: - Analytics

open class Analytics<Event: AnalyticsEventProtocol> {
    /// The registered list of providers.
    open private(set) var providers: [AnalyticsProvider] = []

    public init(providers: [AnalyticsProvider]) {
        self.providers = providers
    }

    /// Register list of given providers if they are not already registered.
    ///
    /// - Note: This method ensures there are no duplicate providers.
    open func register(_ providers: [AnalyticsProvider]) {
        for provider in providers {
            guard !self.providers.contains(where: { $0.id == provider.id }) else {
                continue
            }

            self.providers.append(provider)
        }
    }

    /// Register list of given providers if they are not already registered.
    ///
    /// - Note: This method ensures there are no duplicate providers.
    public func register(_ providers: AnalyticsProvider...) {
        register(providers)
    }

    /// Unregister and removes the given provider.
    open func unregister(_ provider: AnalyticsProvider) {
        let ids = providers.map(\.id)

        guard let index = ids.firstIndex(of: provider.id) else {
            return
        }

        providers.remove(at: index)
    }

    /// Track the given event.
    ///
    /// - Parameter event: The event to track.
    open func track(_ event: Event) {
        let providers = finalProviders(including: event.additionalProviders)

        providers.forEach {
            $0.track(event)
        }
    }

    /// Returns list of final providers to use for tracking.
    private func finalProviders(including additionalProviders: [AnalyticsProvider]? = nil) -> [AnalyticsProvider] {
        var providers = self.providers

        #if DEBUG
        if isDebuggerAttached {
            providers.append(PrintAnalyticsProvider())
        }
        #endif

        if let additionalProviders = additionalProviders, !additionalProviders.isEmpty {
            providers = (providers + additionalProviders).unique(\.id)
        }

        return providers
    }

    /// A method to identify all registered providers with given user id and traits.
    ///
    /// - Parameters:
    ///   - event: The user id that should be used to identify all of the subsequent
    ///     events.
    ///   - traits: The dictionary of traits that should be used to identify all of
    ///     the subsequent events.
    open func identify(userId: String, traits: [String: Any]) {
        providers.forEach { $0.identify(userId: userId, traits: traits) }
    }

    /// A method to disable data collection for all registered providers.
    ///
    /// Depending on the audience for your app, you might need to offer the ability
    /// for users to opt-out of analytics data collection from inside your app.
    open func setEnabled(_ enable: Bool) {
        providers.forEach { $0.setEnabled(enable) }
    }

    /// A method to clear all registered providers for the current user.
    ///
    /// This is useful for apps where users can sign in and out with different
    /// identities over time.
    open func reset() {
        providers.forEach { $0.reset() }
    }
}
