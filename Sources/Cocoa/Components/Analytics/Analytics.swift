//
// Analytics.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

// MARK: - AnalyticsEvent

public protocol AnalyticsEvent {
    /// The name of the event that is sent to analytics providers.
    var name: String { get }

    /// The properties of the event that is sent to analytics providers.
    var properties: [String: Any]? { get }

    /// An option to send this event to additional analytics providers.
    ///
    /// For example, if a specific event should be tracked in Intercom
    /// the said event can return `Intercom` as the additional provider.
    var additionalProviders: [AnalyticsProvider]? { get }
}

// MARK: - AnalyticsProvider

public protocol AnalyticsProvider {
    /// A unique id for the analytics provider.
    var id: String { get }

    /// Track the given event.
    ///
    /// - Parameter event: The event to track.
    func track(_ event: AnalyticsEvent)
}

extension AnalyticsProvider {
    public var id: String {
        return name(of: self)
    }
}

// MARK: - Analytics

open class Analytics<Event: AnalyticsEvent> {
    /// The registered list of providers.
    open private(set) var providers: [AnalyticsProvider] = []

    public init() { }

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
