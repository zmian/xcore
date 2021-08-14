//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

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
    private func finalProviders(including additionalProviders: [AnalyticsProvider]) -> [AnalyticsProvider] {
        var providers = self.providers

        #if DEBUG
        if AppInfo.isDebuggerAttached {
            providers.append(PrintAnalyticsProvider())
        }
        #endif

        return (providers + additionalProviders).uniqued(\.id)
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
