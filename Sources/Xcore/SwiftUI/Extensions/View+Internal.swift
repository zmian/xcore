//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Sets whether to disable autocorrection for this view.
    ///
    /// - Parameter type: The autocorrection behavior of a text-based view.
    func autocorrection(_ type: UITextAutocorrectionType) -> some View {
        switch type {
            case .default:
                return disableAutocorrection(nil)
            case .yes:
                return disableAutocorrection(false)
            case .no:
                return disableAutocorrection(true)
            @unknown default:
                return disableAutocorrection(nil)
        }
    }
}

extension TextAlignment {
    var horizontal: HorizontalAlignment {
        switch self {
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            case .center:
                return .center
        }
    }
}
