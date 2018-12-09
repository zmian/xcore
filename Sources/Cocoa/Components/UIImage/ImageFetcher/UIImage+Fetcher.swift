//
//  UIImage+Fetcher.swift
//  Xcore
//
//  Created by Zeeshan Mian on 12/8/18.
//  Copyright © 2018 Xcore. All rights reserved.
//

import Foundation

// MARK: Namespace

extension UIImage {
    public enum Fetcher { }
}

// MARK: Registration

extension UIImage.Fetcher {
    static var registered: [ImageFetcher.Type] = [RemoteImageFetcher.self, LocalImageFetcher.self]

    public static func register(_ fetcher: ImageFetcher.Type) {
        registered.append(fetcher)
    }
}

// MARK: Cache Management

extension UIImage.Fetcher {
    public enum CacheType {
        case local
        case remote
    }

    public static func clearCache(type: CacheType) {
        switch type {
            case .local:
                LocalImageFetcher.removeCache()
            case .remote:
                RemoteImageFetcher.removeCache()
        }
    }

    public static func clearAllCache() {
        clearCache(type: .local)
        clearCache(type: .remote)
    }
}

extension UIImageView {
    private struct AssociatedKey {
        static var imageRepresentableSource = "imageRepresentableSource"
        static var imageFetcherCancelBlock = "imageFetcherCancelBlock"
    }

    /// The `ImageSourceType` object associated with the receiver.
    var imageRepresentableSource: ImageSourceType? {
        get { return associatedObject(&AssociatedKey.imageRepresentableSource) }
        set { setAssociatedObject(&AssociatedKey.imageRepresentableSource, value: newValue) }
    }

    /// The image fetch cancel block for the current fetch request.
    var _imageFetcherCancelBlock: (() -> Void)? {
        get { return associatedObject(&AssociatedKey.imageFetcherCancelBlock) }
        set { setAssociatedObject(&AssociatedKey.imageFetcherCancelBlock, value: newValue) }
    }

    /// Cancel any pending or in-flight image fetch/set request dispatched via
    /// `setImage(_:transform:alwaysAnimate:animationDuration:_:)` method.
    ///
    /// - seealso: `setImage(_:transform:alwaysAnimate:animationDuration:_:)`
    public func cancelSetImageRequest() {
        sd_cancelCurrentImageLoad()
        _imageFetcherCancelBlock?()
    }
}
