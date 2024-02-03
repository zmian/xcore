//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct ShareView: View {
    var body: some View {
        List {
            ShareLink("Share License Agreement", item: "License Agreement...")
                .buttonStyle(.capsule)

            ShareLink(item: "License Agreement...") {
                Label("Share License Agreement", systemImage: .doc)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ShareView()
        .embedInNavigation()
}
