//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// An unimplemented analytics provider that is suitable for tests.
///
/// It verifies that no endpoints are invoked; if any endpoint is triggered, the
/// test will fail.
public struct UnimplementedAnalyticsProvider: AnalyticsProvider {
    public init() {}

    public func track(_ event: AnalyticsEventProtocol) {
        reportIssue(issueMessage(event))
    }

    public func identify(userId: String?, traits: EncodableDictionary) {
        reportIssue(#"Unimplemented: AnalyticsProvider.identify"#)
    }

    public func setEnabled(_ enable: Bool) {
        reportIssue(#"Unimplemented: AnalyticsProvider.setEnabled"#)
    }

    public func reset() {
        reportIssue(#"Unimplemented: AnalyticsProvider.reset"#)
    }

    private func issueMessage(_ event: AnalyticsEventProtocol) -> String {
        var propertiesString = ""

        if !event.properties.isEmpty {
            propertiesString = JSONHelpers.encodeToString(event.properties, options: [.sortedKeys, .prettyPrinted])
            propertiesString = "\nproperties: \(propertiesString)"
        }

        return """
        AnalyticsProvider.track is unimplemented

        event: "\(event.name)"\(propertiesString)
        """
    }
}
