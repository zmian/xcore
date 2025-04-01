//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A sample model used in the example app target to showcase various
/// components.
struct Ocean: Identifiable, Hashable {
    let id = UUID()
    let name: String

    static let data = [
        Ocean(name: "Pacific"),
        Ocean(name: "Atlantic"),
        Ocean(name: "Indian"),
        Ocean(name: "Southern"),
        Ocean(name: "Arctic")
    ]

    static let error = AppError(
        id: "ocean_fetch_failure",
        title: "Unable to Retrieve Oceans",
        message: "We could not retrieve the ocean data at this time. Please try again later."
    )
}
