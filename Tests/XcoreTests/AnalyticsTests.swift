//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct AnalyticsTests {
    @Test
    func identify() {
        let analytics = AnalyticsClient()
        #expect(analytics.userId == nil)

        // Identify
        analytics.identify(userId: "123")
        #expect(analytics.userId == "123")
        #expect(analytics.traits == [:])
        #expect(analytics.didCallIdentify == true)
        analytics.didCallIdentify = false

        analytics.identify(userId: "123", traits: ["hello": "world"])
        #expect(analytics.userId == "123")
        #expect(analytics.traits == ["hello": "world"])
        #expect(analytics.didCallIdentify == true)
        analytics.didCallIdentify = false

        // Ensure identify isn't called if user id and traits are the same.
        analytics.identify(traits: ["hello": "world"])
        #expect(analytics.userId == "123")
        #expect(analytics.traits == ["hello": "world"])
        #expect(analytics.didCallIdentify == false)

        analytics.identify(userId: "1234", traits: ["hello": "world"])
        #expect(analytics.userId == "1234")
        #expect(analytics.traits == ["hello": "world"])
        #expect(analytics.didCallIdentify == true)
        analytics.didCallIdentify = false

        analytics.identify(userId: "12345")
        #expect(analytics.userId == "12345")
        #expect(analytics.traits == ["hello": "world"])
        #expect(analytics.didCallIdentify == true)
        analytics.didCallIdentify = false
    }

    /// Reset, ensure reset is only called if user was identified.
    @Test
    func reset() {
        let analytics = AnalyticsClient()

        // when only traits are set, reset shouldn't be called.
        analytics.identify(traits: ["hello": "greetings"])
        #expect(analytics.didCallIdentify == true)
        analytics.didCallIdentify = false
        #expect(analytics.didCallReset == false)
        analytics.reset()
        #expect(analytics.didCallReset == false)

        // when only user id is set, reset should be called.
        analytics.identify(userId: "123")
        analytics.reset()
        #expect(analytics.didCallReset == true)
        analytics.didCallReset = false

        analytics.identify(traits: ["hello": "greetings"])
        analytics.reset()
        #expect(analytics.didCallReset == false)
        analytics.identify(userId: "1234")
        #expect(analytics.userId == "1234")
        analytics.reset()
        #expect(analytics.userId == nil)
        #expect(analytics.didCallReset == true)
    }

    @Test
    func track() {
        let analytics = AnalyticsClient()

        #expect(analytics.lastEvent == nil)
        analytics.track(AppAnalyticsEvent(name: "sign up"))
        #expect(analytics.lastEvent == AppAnalyticsEvent(name: "sign up"))
    }

    @Test
    func setEnabled() {
        let analytics = AnalyticsClient()

        #expect(analytics.didCallSetEnabled == false)
        analytics.setEnabled(true)
        #expect(analytics.didCallSetEnabled == true)
    }

    /// nil or empty traits should be the treated the same
    @Test
    func emptyAndNilTraits() {
        let analytics = AnalyticsClient()

        analytics.reset()
        #expect(analytics.userId == nil)
        #expect(analytics.traits == [:])
        #expect(analytics.didCallIdentify == false)
        analytics.identify(userId: "123")
        #expect(analytics.userId == "123")
        #expect(analytics.traits == [:])
        #expect(analytics.didCallIdentify == true)
        analytics.didCallIdentify = false
        analytics.identify(traits: [:])
        #expect(analytics.userId == "123")
        #expect(analytics.traits == [:])
        #expect(analytics.didCallIdentify == false)
    }

    /// nil or empty user id should be the treated the same
    @Test
    func blankAndNilUserId() {
        let analytics = AnalyticsClient()

        analytics.reset()
        #expect(analytics.userId == nil)
        #expect(analytics.traits == [:])
        #expect(analytics.didCallIdentify == false)
        analytics.identify(traits: ["hello": "greetings"])
        #expect(analytics.userId == nil)
        #expect(analytics.traits == ["hello": "greetings"])
        #expect(analytics.didCallIdentify == true)
        analytics.didCallIdentify = false
        // Empty == nil
        analytics.identify(userId: "")
        #expect(analytics.userId == nil)
        #expect(analytics.traits == ["hello": "greetings"])
        #expect(analytics.didCallIdentify == false)

        // blank == nil
        analytics.identify(userId: "   ")
        #expect(analytics.userId == nil)
        #expect(analytics.traits == ["hello": "greetings"])
        #expect(analytics.didCallIdentify == false)
    }
}

@dynamicMemberLookup
private final class AnalyticsClient: Analytics<AppAnalyticsEvent>, @unchecked Sendable {
    var mock: MockAnalyticsProvider

    init() {
        mock = MockAnalyticsProvider()
        super.init(providers: [])
        // NB: `register` is used intentionally to ensure the code path is tested.
        register(mock)
    }

    subscript<T>(dynamicMember keyPath: KeyPath<MockAnalyticsProvider, T>) -> T {
        mock[keyPath: keyPath]
    }

    subscript<T>(dynamicMember keyPath: WritableKeyPath<MockAnalyticsProvider, T>) -> T {
        get { mock[keyPath: keyPath] }
        set { mock[keyPath: keyPath] = newValue }
    }
}
