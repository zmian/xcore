//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct ShareView: View {
    var body: some View {
        List {
            Section {
                ShareLink(item: "License Agreement...") {
                    Label("Share License Agreement", systemImage: .doc)
                }

                ShareLink(item: Image(.blueJay), preview: SharePreview(
                    "Blue Jay",
                    image: Image(.blueJay)
                )) {
                    Label("Share Blue Jay", image: Image(.blueJay).resizable())
                        .labelStyle(.settingsIcon(tint: .accentColor))
                }
            }

            Section {
                ShareLink("Share License Agreement", item: "License Agreement...")
                    .buttonStyle(.capsuleFill)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink("Share License Agreement", item: "License Agreement...")
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ShareView()
        .embedInNavigation()
}
