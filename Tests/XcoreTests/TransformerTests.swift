//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct TransformerTests {
    @Test
    func passthrough() {
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
