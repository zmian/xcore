//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct PrintAnalyticsProvider: AnalyticsProvider {
    public init() {}

    public func track(_ event: AnalyticsEventProtocol) {
        let (enabled, containsValue) = ProcessInfo.Arguments.isAnalyticsDebugEnabled

        guard enabled else {
            return
        }

        if let value = containsValue {
            if event.name.contains(value) {
                log(event)
            }
        } else {
            log(event)
        }
    }

    private func log(_ event: AnalyticsEventProtocol) {
        var propertiesString = ""

        if let properties = event.properties, !properties.isEmpty {
            propertiesString = JSONHelpers.stringify(properties, prettyPrinted: true)
            propertiesString = "\nproperties: \(propertiesString)"
        }

        print("""

        event: "\(event.name)"\(propertiesString)
        """)
    }
}
