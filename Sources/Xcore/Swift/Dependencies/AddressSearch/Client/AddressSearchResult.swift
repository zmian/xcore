//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
internal import MapKit

/// A structure representing a fully-formed string that completes a partial
/// string.
public struct AddressSearchResult: Sendable, Hashable {
    public let title: String
    public let subtitle: String

    /// Creates an instance of search result from given title and subtitle string.
    ///
    /// - Parameters:
    ///   - title: The title string associated with the point-of-interest.
    ///   - subtitle: The subtitle (if any) associated with the point-of-interest.
    public init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }

    /// Creates an instance of search result from given search completion object.
    ///
    /// - Parameter completion: The search completion object.
    init(_ completion: MKLocalSearchCompletion) {
        self.init(title: completion.title, subtitle: completion.subtitle)
    }

    /// Returns search request to search for map locations based on a natural
    /// language string.
    func request() -> MKLocalSearch.Request {
        MKLocalSearch.Request().apply {
            $0.naturalLanguageQuery = [title, subtitle].joined(separator: ", ")
            $0.resultTypes = .address
        }
    }
}