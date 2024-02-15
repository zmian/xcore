//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIImage {
    /// Fetch an image from the given source.
    public static func fetch(_ source: ImageRepresentable) async throws -> UIImage {
        try await UIImage.Fetcher.fetch(source).image
    }

    /// Download multiple remote images.
    public static func fetch(_ urls: [URL]) async -> [(url: URL, image: UIImage)] {
        guard !urls.isEmpty else {
            return []
        }

        typealias Input = (url: URL, image: UIImage?)
        typealias Output = (url: URL, image: UIImage)

        return await withTaskGroup(of: Input.self) { group -> [Output] in
            urls.forEach { url in
                group.addTask {
                    let image = try? await ImageDownloader.download(url: url)
                    return (url, image)
                }
            }

            var items = [Output]()
            for await item in group {
                if let image = item.image {
                    items.append((item.url, image))
                }
            }
            return items
        }
    }
}
