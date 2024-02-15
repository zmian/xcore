//
// Xcore
// Copyright © 2024 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct ImagesView: View {
    @State private var images: [UIImage]?

    var body: some View {
        ScrollView {
            ImageView(R.localImage)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            ImageView(R.remoteImage)
                .frame(height: 300)

            if let images {
                HStack {
                    ForEach(images, id: \.self) {
                        Image(uiImage: $0)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .task {
            images = await UIImage
                .fetch([R.remoteImage, R.remoteImage2])
                .map { url, image in
                    if url == R.remoteImage2 {
                        image
                            .scaled(to: .init(width: 50, height: UIView.noIntrinsicMetric))
                            .cornerRadius(4)
                    } else {
                        image
                    }
                }
        }
    }
}

extension ImagesView {
    enum R {
        static let localImage: ImageAssetIdentifier = "blueJay"
        static let remoteImage = URL(string: "https://images.unsplash.com/photo-1604782206219-3b9576575203?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1394&q=80")!
        static let remoteImage2 = URL(string: "https://images.unsplash.com/photo-1707968502443-a3f2ec7077f7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3115&q=80")!
    }
}

// MARK: - Preview

#Preview {
    ImagesView()
        .embedInNavigation()
}
