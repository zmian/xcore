//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class TransformerTests: TestCase {
    func testPassthrough() {
        let transform = AnalyticsEventTransform.passthrough
        let event = AppAnalyticsEvent(name: "app_launched")
        let transformedEvent = transform(event)
        XCTAssertEqual(event, transformedEvent)
    }

    func testCustom() {
        let transform = AnalyticsEventTransform { event in
            .init(name: event.name + "_transformed")
        }

        let event = AppAnalyticsEvent(name: "app_launched")
        let transformedEvent = transform(event)
        let expectedEvent = AppAnalyticsEvent(name: "app_launched_transformed")
        XCTAssertEqual(transformedEvent, expectedEvent)
    }
}

private typealias AnalyticsEventTransform = Transformer<AppAnalyticsEvent, AppAnalyticsEvent>
