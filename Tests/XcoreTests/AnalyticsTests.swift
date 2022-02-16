//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class AnalyticsTests: TestCase {
    func testIdentify() {
        let analytics = AnalyticsClient()
        XCTAssertEqual(analytics.userId, nil)

        // Identify
        analytics.identify(userId: "123")
        XCTAssertEqual(analytics.userId, "123")
        XCTAssertEqual(analytics.traits, nil)
        XCTAssertEqual(analytics.didCallIdentify, true)
        analytics.didCallIdentify = false

        analytics.identify(userId: "123", traits: ["hello": "world"])
        XCTAssertEqual(analytics.userId, "123")
        XCTAssertEqual(analytics.traits, ["hello": "world"])
        XCTAssertEqual(analytics.didCallIdentify, true)
        analytics.didCallIdentify = false

        // Ensure identify isn't called if user id and traits are the same.
        analytics.identify(traits: ["hello": "world"])
        XCTAssertEqual(analytics.userId, "123")
        XCTAssertEqual(analytics.traits, ["hello": "world"])
        XCTAssertEqual(analytics.didCallIdentify, false)

        analytics.identify(userId: "1234", traits: ["hello": "world"])
        XCTAssertEqual(analytics.userId, "1234")
        XCTAssertEqual(analytics.traits, ["hello": "world"])
        XCTAssertEqual(analytics.didCallIdentify, true)
        analytics.didCallIdentify = false
    }

    /// Reset, ensure reset is only called if user was identified.
    func testReset() {
        let analytics = AnalyticsClient()

        // when only traits are set, reset shouldn't be called.
        analytics.identify(traits: ["hello": "greetings"])
        XCTAssertEqual(analytics.didCallIdentify, true)
        analytics.didCallIdentify = false
        XCTAssertEqual(analytics.didCallReset, false)
        analytics.reset()
        XCTAssertEqual(analytics.didCallReset, false)

        // when only user id is set, reset should be called.
        analytics.identify(userId: "123")
        analytics.reset()
        XCTAssertEqual(analytics.didCallReset, true)
        analytics.didCallReset = false

        analytics.identify(traits: ["hello": "greetings"])
        analytics.reset()
        XCTAssertEqual(analytics.didCallReset, false)
        analytics.identify(userId: "1234")
        XCTAssertEqual(analytics.userId, "1234")
        analytics.reset()
        XCTAssertEqual(analytics.userId, nil)
        XCTAssertEqual(analytics.didCallReset, true)
    }

    func testTrack() {
        let analytics = AnalyticsClient()

        XCTAssertEqual(analytics.event, nil)
        analytics.track(AppAnalyticsEvent(name: "sign up"))
        XCTAssertEqual(analytics.event, AppAnalyticsEvent(name: "sign up"))
    }

    func testSetEnabled() {
        let analytics = AnalyticsClient()

        XCTAssertEqual(analytics.didCallSetEnabled, false)
        analytics.setEnabled(true)
        XCTAssertEqual(analytics.didCallSetEnabled, true)
    }

    /// nil or empty traits should be the treated the same
    func testEmptyAndNilTraits() {
        let analytics = AnalyticsClient()

        analytics.reset()
        XCTAssertEqual(analytics.userId, nil)
        XCTAssertEqual(analytics.traits, nil)
        XCTAssertEqual(analytics.didCallIdentify, false)
        analytics.identify(userId: "123")
        XCTAssertEqual(analytics.userId, "123")
        XCTAssertEqual(analytics.traits, nil)
        XCTAssertEqual(analytics.didCallIdentify, true)
        analytics.didCallIdentify = false
        analytics.identify(traits: [:])
        XCTAssertEqual(analytics.userId, "123")
        XCTAssertEqual(analytics.traits, nil)
        XCTAssertEqual(analytics.didCallIdentify, false)
    }

    /// nil or empty user id should be the treated the same
    func tesBlankAndNilUserId() {
        let analytics = AnalyticsClient()

        analytics.reset()
        XCTAssertEqual(analytics.userId, nil)
        XCTAssertEqual(analytics.traits, nil)
        XCTAssertEqual(analytics.didCallIdentify, false)
        analytics.identify(traits: ["hello": "greetings"])
        XCTAssertEqual(analytics.userId, nil)
        XCTAssertEqual(analytics.traits, ["hello": "greetings"])
        XCTAssertEqual(analytics.didCallIdentify, true)
        analytics.didCallIdentify = false
        // Empty == nil
        analytics.identify(userId: "")
        XCTAssertEqual(analytics.userId, nil)
        XCTAssertEqual(analytics.traits, ["hello": "greetings"])
        XCTAssertEqual(analytics.didCallIdentify, false)

        // blank == nil
        analytics.identify(userId: "   ")
        XCTAssertEqual(analytics.userId, nil)
        XCTAssertEqual(analytics.traits, ["hello": "greetings"])
        XCTAssertEqual(analytics.didCallIdentify, false)
    }
}

private final class AnalyticsClient: Analytics<AppAnalyticsEvent> {
    var event: AppAnalyticsEvent?
    var userId: String?
    var traits: [String: String]?
    var didCallReset = false
    var didCallSetEnabled = false
    var didCallIdentify = false

    init() {
        super.init(providers: [])

        let provider = BlockAnalyticsProvider {
            self.event = $0 as? AppAnalyticsEvent
        } identify: {
            self.didCallIdentify = true
            self.userId = $0
            self.traits = $1?.compactMapValues { $0 as? String }
        } setEnabled: {
            self.didCallSetEnabled = $0
        } reset: {
            self.userId = nil
            self.traits = nil
            self.didCallIdentify = false
            self.didCallReset = true
        }

        register(provider)
    }
}

// MARK: - BlockAnalyticsProvider

private struct BlockAnalyticsProvider: AnalyticsProvider {
    private let _track: (_ event: AnalyticsEventProtocol) -> Void
    private let _identify: (_ userId: String?, _ traits: [String: Encodable]?) -> Void
    private let _setEnabled: (_ enable: Bool) -> Void
    private let _reset: () -> Void

    init(
        track: @escaping (_ event: AnalyticsEventProtocol) -> Void,
        identify: @escaping (_ userId: String?, _ traits: [String: Encodable]?) -> Void,
        setEnabled: @escaping (_ enable: Bool) -> Void,
        reset: @escaping () -> Void
    ) {
        self._track = track
        self._identify = identify
        self._setEnabled = setEnabled
        self._reset = reset
    }

    func track(_ event: AnalyticsEventProtocol) {
        _track(event)
    }

    func identify(userId: String?, traits: [String: Encodable]?) {
        _identify(userId, traits)
    }

    func setEnabled(_ enable: Bool) {
        _setEnabled(enable)
    }

    func reset() {
        _reset()
    }
}
