//
// Xcore
// Copyright © 2023 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct StoryPreviewView: View {
    private let data = [
        Colorful(id: 1, color: .green.gradient),
        Colorful(id: 2, color: .indigo.gradient),
        Colorful(id: 3, color: .purple.gradient)
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
            .frame(max: .infinity)
        } background: { data in
            Rectangle().fill(AnyShapeStyle(data.color))
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
        let color: any ShapeStyle
    }
}
