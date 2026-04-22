//
// Xcore
// Copyright © 2026 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct OpenURLView: View {
    @Dependency(\.openURL) private var openURL
    @Environment(\.openURL) private var envOpenURL

    var body: some View {
        List {
            Section {
                Button("Open Mail App") {
                    openURL(.mailApp)
                }

                Button("Open Settings App") {
                    openURL(.settingsApp)
                }

                Button("Open Apple.com") {
                    openURL(URL(string: "https://apple.com"))
                }
            }

            Section {
                Button("Open Apple.com") {
                    envOpenURL(URL(string: "https://apple.com")!, prefersInApp: true)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    OpenURLView()
        .embedInNavigation()
}
