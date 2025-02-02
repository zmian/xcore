//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct TransformerTests {
    @Test
    func basics() {
        let intToString = Transformer<Int, String> { "\($0)" }
        #expect(intToString(42) == "42")

        let stringToDouble = Transformer<String, Double> { Double($0) ?? 0.0 }
        #expect(stringToDouble("3.14") == 3.14)

        let combined = intToString.map(stringToDouble)
        #expect(combined(42) == 42.0)

        let uppercased = Transformer<String, String> { $0.uppercased() }
        #expect(uppercased("hello") == "HELLO")
    }

    @Test
    func passthrough() {
        let passthrough = Transformer<String, String>.passthrough
        let result = passthrough("No Change")
        #expect(result == "No Change")

        let transform = AnalyticsEventTransform.passthrough
        let event = AppAnalyticsEvent(name: "app_launched")
        let transformedEvent = transform(event)
        #expect(event == transformedEvent)
    }

    @Test
    func custom() {
        let transform = AnalyticsEventTransform { event in
            .init(name: event.name + "_transformed")
        }

        let event = AppAnalyticsEvent(name: "app_launched")
        let transformedEvent = transform(event)
        let expectedEvent = AppAnalyticsEvent(name: "app_launched_transformed")
        #expect(transformedEvent == expectedEvent)
    }
}

private typealias AnalyticsEventTransform = Transformer<AppAnalyticsEvent, AppAnalyticsEvent>
