//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

open class Analytics<Event: AnalyticsEventProtocol> {
    private var userId: String?
    private var traits: [String: Encodable] = [:]

    /// The registered list of providers.
    open private(set) var providers: [AnalyticsProvider]

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
            providers.append(LogAnalyticsProvider())
        }
        #endif

        return (providers + additionalProviders).uniqued(\.id)
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
    ///
    /// - Note: If no user is identified than calling this method has no effect.
    ///   This avoids providers generating anonymous user id while current user is
    ///   already anonymous.
    ///
    /// For most analytics provider, reset method generates a new anonymous id
    /// everytime. Resetting multiple times while the user is already in signed out
    /// state will cause the some providers to generate multiple anonymous ids.
    /// Meaning, there would be pockets of user's which would never track back to
    /// the user if they ever signed back on to the app.
    open func reset() {
        guard userId != nil else {
            return
        }

        userId = nil
        traits = [:]
        providers.forEach { $0.reset() }
    }
}

// MARK: - Identify

extension Analytics {
    /// A method to identify all registered providers with given user id and traits.
    ///
    /// - Parameter userId: The user id that should be used to identify all of the
    ///   subsequent events.
    ///
    ///  - Note: Calling this method multiple times with same user id and/or traits
    ///    have no effect. Internally, it ensures the user id and traits are
    ///    different before invoking the identify call on the registered analytics
    ///    providers.
    public func identify(userId: String) {
        _identify(userId: userId, traits: traits)
    }

    /// A method to identify all registered providers with given user id and traits.
    ///
    /// - Parameter traits: The dictionary of traits that should be used to identify
    ///   all of the subsequent events.
    ///
    ///  - Note: Calling this method multiple times with same user id and/or traits
    ///    have no effect. Internally, it ensures the user id and traits are
    ///    different before invoking the identify call on the registered analytics
    ///    providers.
    public func identify(traits: [String: Encodable]) {
        _identify(userId: userId, traits: traits)
    }

    /// A method to identify all registered providers with given user id and traits.
    ///
    /// - Parameters:
    ///   - userId: The user id that should be used to identify all of the
    ///     subsequent events.
    ///   - traits: The dictionary of traits that should be used to identify all of
    ///     the subsequent events.
    ///
    ///  - Note: Calling this method multiple times with same user id and/or traits
    ///    have no effect. Internally, it ensures the user id and traits are
    ///    different before invoking the identify call on the registered analytics
    ///    providers.
    public func identify(userId: String, traits: [String: Encodable]) {
        _identify(userId: userId, traits: traits)
    }

    /// A method to identify all registered providers with given user id and traits.
    ///
    /// - Parameters:
    ///   - userId: The user id that should be used to identify all of the
    ///     subsequent events.
    ///   - traits: The dictionary of traits that should be used to identify all of
    ///     the subsequent events.
    ///
    ///  - Note: Calling this method multiple times with same user id and/or traits
    ///    have no effect. Internally, it ensures the user id and traits are
    ///    different before invoking the identify call on the registered analytics
    ///    providers.
    private func _identify(userId: String?, traits: [String: Encodable]) {
        let currentUserId = self.userId
        let currentTraits = self.traits

        guard userId?.nilIfBlank != currentUserId?.nilIfBlank || !traits.isEqual(currentTraits) else {
            return
        }

        self.userId = userId ?? currentUserId
        self.traits = traits.isEmpty ? currentTraits : traits
        providers.forEach { $0.identify(userId: self.userId, traits: self.traits) }
    }
}
