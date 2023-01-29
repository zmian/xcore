//
// Xcore
// Copyright © 2023 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct StoryPreviewView: View {
    private let pages = [
        Colorful(id: 1, color: .green),
        Colorful(id: 2, color: .indigo),
        Colorful(id: 3, color: .purple)
    ]

    var body: some View {
        StoryView(cycle: .once, pages: pages) { page in
            VStack {
                Text("Page")
                Text("#")
                    .baselineOffset(70)
                    .font(.system(size: 100)) +
                    Text("\(page.id)")
                    .font(.system(size: 200))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } background: { page in
            page.color
        }
        .onCycleComplete { count in
            print(count)
        }
    }
}

extension StoryPreviewView {
    private struct Colorful: Identifiable {
        let id: Int
        let color: Color
    }
}
