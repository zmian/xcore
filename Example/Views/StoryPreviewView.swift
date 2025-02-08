//
// Xcore
// Copyright © 2023 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct StoryPreviewView: View {
    private let data = [
        Colorful(id: 1, color: .green),
        Colorful(id: 2, color: .indigo),
        Colorful(id: 3, color: .purple)
    ]

    var body: some View {
        StoryView(cycle: .once, data: data) { data in
            VStack {
                Text("Page")
                Text("#")
                    .baselineOffset(70)
                    .font(.system(size: 100)) +
                Text("\(data.id)")
                    .font(.system(size: 200))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } background: { data in
            data.color
        }
        .onCycleComplete { remaining in
            print("Cycles remaining: \(remaining)")
        }
        .storyProgressIndicatorTint(.white)
    }
}

extension StoryPreviewView {
    private struct Colorful {
        let id: Int
        let color: Color
    }
}
