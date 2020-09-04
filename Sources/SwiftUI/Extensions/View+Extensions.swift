//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    public func embedInNavigation() -> some View {
        NavigationView { self }
    }
}
