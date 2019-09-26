//
// ImageDownloader.swift
//
// Copyright © 2018 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit
import SDWebImage

extension ImageSourceType.CacheType {
    fileprivate init(_ type: SDImageCacheType) {
        switch type {
            case .none:
                self = .none
            case .disk:
                self = .disk
            case .memory:
                self = .memory
            default:
                fatalError(because: .unknownCaseDetected(type))
        }
    }
}

/// An internal class to download remote images.
///
/// Currently, it uses `SDWebImage` for download requests.
final class ImageDownloader {
    typealias CancelToken = () -> Void

    /// Downloads the image at the given URL, if not present in cache or return the cached version otherwise.
    static func load(url: URL, completion: @escaping (_ image: UIImage?, _ data: Data?, _ error: Error?, _ finished: Bool, _ cacheType: ImageSourceType.CacheType) -> Void) -> CancelToken? {
        let token = SDWebImageManager.shared.loadImage(
            with: url,
            options: [.avoidAutoSetImage],
            progress: nil
        ) { image, data, error, cacheType, finished, url in
            completion(image, data, error, finished, .init(cacheType))
        }

        return token?.cancel
    }

    /// Downloads the image from the given url.
    static func download(url: URL, completion: @escaping (_ image: UIImage?, _ data: Data?, _ error: Error?, _ finished: Bool) -> Void) {
        SDWebImageDownloader.shared.downloadImage(
            with: url,
            options: [],
            progress: nil
        ) { image, data, error, finished in
            completion(image, data, error, finished)
        }
    }

    static func clearCache() {
        SDImageCache.shared.apply {
            $0.clearMemory()
            $0.clearDisk()
            $0.deleteOldFiles()
        }
    }
}
