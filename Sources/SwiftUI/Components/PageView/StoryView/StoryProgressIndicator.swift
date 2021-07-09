//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// Continuous progress indicator
struct StoryProgressIndicator: View {
    @Environment(\.storyProgressIndicatorColor) private var color
    private let progress: CGFloat

    init(progress: CGFloat) {
        self.progress = progress
    }

    var body: some View {
        ProgressView(value: progress)
            .progressViewStyle(.horizontalBar(height: 2))
            .accentColor(color ?? .white)
            .animation(.linear)
    }
}

struct StoryProgressIndicator_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StoryProgressIndicator(progress: 0)
            StoryProgressIndicator(progress: 1.0)
            StoryProgressIndicator(progress: 0.8)
                .storyProgressIndicatorColor(.purple)
        }
        .padding(20)
        .backgroundColor(.black)
        .previewLayout(.sizeThatFits)
    }
}
