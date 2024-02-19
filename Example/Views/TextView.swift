//
// Xcore
// Copyright © 2024 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct TextView: View {
    var body: some View {
        List {
            Section("General") {
                Text("Normal text")

                Text("Normal text with a [tappable link](https://www.apple.com).")
                Text("Link without explict markdown: https://www.apple.com")

                Text("Phone number without explict markdown: 1-800-275-2273")
                Text("Phone number with explict markdown: [1-800-275-2273](tel:1-800-275-2273)")

                Text(appMarkdown: "Highlight important information with a ^[different text color](color: '#ff0000').")

                // Testing bold with different sizes
                Text("An email with a 6-digit code has been sent to **sam@example.com**.")
                Text("An email with a 6-digit code has been sent to **sam@example.com**.")
                    .font(.app(.footnote))
            }

            Section("Multiple Links") {
                // Multiple Links in a single text.
                Text("This paragraph contains two phone numbers for testing VoiceOver and ensuring the links rotor is functioning properly. The first number is [1-800-275-2273](tel:1-800-275-2273), and here is the second number is [1-800-275-2273](tel:1-800-275-2273).")
                Text("This paragraph contains two links for testing VoiceOver and ensuring the links rotor is functioning properly. The first link is www.example.com, and the second link is a [tappable link](https://www.apple.com) has custom display text.")
            }
        }
        .openUrlInApp()
    }
}

// MARK: - Preview

#Preview {
    TextView()
        .embedInNavigation()
}
