//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIImage {
    /// Fetch an image from the given source.
    public class func fetch(
        _ source: ImageRepresentable,
        callback: @escaping (_ result: Result<UIImage, Error>) -> Void
    ) {
        UIImage.Fetcher.fetch(source, in: nil) { result in
            DispatchQueue.main.asyncSafe {
                callback(result.trimCache())
            }
        }
    }

    /// Download multiple remote images.
    public class func fetch(
        _ urls: [String],
        callback: @escaping (_ images: [(url: URL, image: UIImage)]) -> Void
    ) {
        guard !urls.isEmpty else { return }

        var orderedObjects: [(url: URL, image: UIImage?)] = urls.compactMap(URL.init).filter { $0.host != nil }.compactMap { ($0, nil) }
        var downloadedImages = 0

        orderedObjects.forEach { object in
            ImageDownloader.download(url: object.url) { image, _, _, finished in
                downloadedImages += 1

                if let image = image, finished {
                    if let index = orderedObjects.firstIndex(where: { $0.url == object.url }) {
                        orderedObjects[index].image = image
                    }
                }

                if downloadedImages == urls.count {
                    let imagesAndUrls = orderedObjects.filter { $0.image != nil }.compactMap { (url: $0.url, image: $0.image!) }
                    DispatchQueue.main.asyncSafe {
                        callback(imagesAndUrls)
                    }
                }
            }
        }
    }
}
