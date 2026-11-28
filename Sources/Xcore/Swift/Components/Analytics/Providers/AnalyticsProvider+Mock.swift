//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A mock analytics provider that is suitable for tests.
public final class MockAnalyticsProvider: AnalyticsProvider, @unchecked Sendable {
    private struct State {
        var isEnabled = true
        var userId: String?
        var traits: EncodableDictionary = [:]
        var events: [AppAnalyticsEvent] = []
        var didCallTrack = false
        var didCallIdentify = false
        var didCallSetEnabled = false
        var didCallReset = false
    }

    private let state = LockIsolated(State())

    public init() {}

    public private(set) var isEnabled: Bool {
        state.value.isEnabled
    }

    public private(set) var userId: String? {
        state.value.userId
    }

    public private(set) var traits: EncodableDictionary {
        state.value.traits
    }

    public private(set) var events: [AppAnalyticsEvent] {
        state.value.events
    }

    // Endpoint invocation triggers
    public var didCallTrack: Bool {
        get { state.value.didCallTrack }
        set { state.withValue { $0.didCallTrack = newValue } }
    }

    public var didCallIdentify: Bool {
        get { state.value.didCallIdentify }
        set { state.withValue { $0.didCallIdentify = newValue } }
    }

    public var didCallSetEnabled: Bool {
        get { state.value.didCallSetEnabled }
        set { state.withValue { $0.didCallSetEnabled = newValue } }
    }

    public var didCallReset: Bool {
        get { state.value.didCallReset }
        set { state.withValue { $0.didCallReset = newValue } }
    }

    /// Returns the last triggered event.
    public var lastEvent: AppAnalyticsEvent? {
        events.last
    }

    public func track(_ event: AnalyticsEventProtocol) {
        state.withValue { state in
            guard state.isEnabled else {
                return
            }

            state.didCallTrack = true

            guard let event = event as? AppAnalyticsEvent else {
                reportIssue("Only events of type \"AppAnalyticsEvent\" are supported.")
                return
            }

            state.events.append(event)
        }
    }

    public func identify(userId: String?, traits: EncodableDictionary) {
        state.withValue {
            $0.userId = userId
            $0.traits = traits
            $0.didCallIdentify = true
        }
    }

    public func setEnabled(_ enable: Bool) {
        state.withValue {
            $0.isEnabled = enable
            $0.didCallSetEnabled = true
        }
    }

    public func reset() {
        state.withValue {
            $0.isEnabled = true
            $0.userId = nil
            $0.traits = [:]
            $0.events = []
            $0.didCallTrack = false
            $0.didCallIdentify = false
            $0.didCallSetEnabled = false
            $0.didCallReset = true
        }
    }
}