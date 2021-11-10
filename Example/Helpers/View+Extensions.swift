//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Embed this view in a navigation view.
    func embedInNavigation() -> some View {
        NavigationView { self }
    }
}
