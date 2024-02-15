//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIImage {
    /// Asynchronously fetches an image from the specified source.
    ///
    /// - Parameter source: The `ImageRepresentable` source from which the image
    ///   will be fetched.
    /// - Returns: The fetched `UIImage` object.
    /// - Throws: An error if the image fetching operation encounters any issues.
    public static func fetch(_ source: ImageRepresentable) async throws -> UIImage {
        try await UIImage.Fetcher.fetch(source).image
    }

    /// Asynchronously downloads multiple remote images.
    ///
    /// - Parameter urls: An array of `URL` objects representing the remote images
    ///   to be downloaded.
    /// - Returns: An array of tuples containing the downloaded `UIImage` objects
    ///   and their corresponding URLs.
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
