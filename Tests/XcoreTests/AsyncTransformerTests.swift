//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct AsyncTransformerTests {
    @Test
    func basics() async {
        let stringToInt = AsyncTransformer<String, Int> { input in
            try? await Task.sleep(for: .seconds(1)) // Simulating async work
            return Int(input) ?? 0
        }

        let result = await stringToInt("42")
        #expect(result == 42)
    }

    @Test
    func passthrough() async {
        let passthrough = AsyncTransformer<String, String>.passthrough
        let result = await passthrough("No Change")
        #expect(result == "No Change")

        let transform = AnalyticsEventTransform.passthrough
        let event = AppAnalyticsEvent(name: "app_launched")
        let transformedEvent = await transform(event)
        #expect(event == transformedEvent)
    }

    @Test
    func custom() async {
        let transform = AnalyticsEventTransform { event in
            .init(name: event.name + "_transformed")
        }

        let event = AppAnalyticsEvent(name: "app_launched")
        let transformedEvent = await transform(event)
        let expectedEvent = AppAnalyticsEvent(name: "app_launched_transformed")
        #expect(transformedEvent == expectedEvent)
    }
}

private typealias AnalyticsEventTransform = AsyncTransformer<AppAnalyticsEvent, AppAnalyticsEvent>
