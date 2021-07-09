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
}

extension AnalyticsProvider {
    public var id: String {
        name(of: self)
    }
}

// MARK: - Analytics

open class Analytics<Event: AnalyticsEventProtocol> {
    /// The registered list of providers.
    open private(set) var providers: [AnalyticsProvider] = []

    public init() {}

    /// Register the given provider if it's not already registered.
    ///
    /// - Note: This method ensures there are no duplicate providers.
    open func register(_ provider: AnalyticsProvider) {
        guard !providers.contains(where: { $0.id == provider.id }) else {
            return
        }

        providers.append(provider)
    }

    /// Track the given event.
    ///
    /// - Parameter event: The event to track.
    open func track(_ event: Event) {
        let providers = finalProviders(additionalProviders: event.additionalProviders)

        providers.forEach {
            $0.track(event)
        }
    }

    private func finalProviders(additionalProviders: [AnalyticsProvider]? = nil) -> [AnalyticsProvider] {
        guard let additionalProviders = additionalProviders, !additionalProviders.isEmpty else {
            return providers
        }

        var providers = self.providers

        for provider in additionalProviders where !providers.contains(where: { $0.id == provider.id }) {
            providers.append(provider)
        }

        return providers
    }
}
