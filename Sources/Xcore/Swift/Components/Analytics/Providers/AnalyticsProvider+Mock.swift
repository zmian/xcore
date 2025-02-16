//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A mock analytics provider that is suitable for tests.
public final class MockAnalyticsProvider: AnalyticsProvider {
    nonisolated(unsafe) public private(set) var isEnabled = true
    nonisolated(unsafe) public private(set) var userId: String?
    nonisolated(unsafe) public private(set) var traits: EncodableDictionary = [:]
    nonisolated(unsafe) public private(set) var events: [AppAnalyticsEvent] = []

    // Endpoint invocation triggers
    nonisolated(unsafe) public var didCallTrack = false
    nonisolated(unsafe) public var didCallIdentify = false
    nonisolated(unsafe) public var didCallSetEnabled = false
    nonisolated(unsafe) public var didCallReset = false

    public init() {}

    /// Returns the last triggered event.
    public var lastEvent: AppAnalyticsEvent? {
        events.last
    }

    public func track(_ event: AnalyticsEventProtocol) {
        guard isEnabled else {
            return
        }

        didCallTrack = true

        guard let event = event as? AppAnalyticsEvent else {
            reportIssue("Only events of type \"AppAnalyticsEvent\" are supported.")
            return
        }

        events.append(event)
    }

    public func identify(userId: String?, traits: EncodableDictionary) {
        self.userId = userId
        self.traits = traits
        didCallIdentify = true
    }

    public func setEnabled(_ enable: Bool) {
        isEnabled = enable
        didCallSetEnabled = true
    }

    public func reset() {
        isEnabled = true
        userId = nil
        traits = [:]
        events = []

        // Reset all properties as well.
        didCallTrack = false
        didCallIdentify = false
        didCallSetEnabled = false
        didCallReset = true
    }
}
