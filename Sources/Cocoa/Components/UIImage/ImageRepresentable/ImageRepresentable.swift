//
// ImageRepresentable.swift
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - ImageSourceType

public enum ImageSourceType: Equatable {
    case url(String)
    case uiImage(UIImage)

    var isValid: Bool {
        switch self {
            case .uiImage:
                return true
            case .url(let value):
                return !value.isBlank
        }
    }

    public var isRemoteUrl: Bool {
        guard
            case .url(let rawValue) = self,
            let url = URL(string: rawValue),
            url.host != nil,
            url.schemeType != .file
        else {
            return false
        }

        return true
    }
}

// MARK: - ImageSourceType.CacheType

extension ImageSourceType {
    public enum CacheType {
        /// The image wasn't available in the cache, but was downloaded from the web.
        case none

        /// The image was obtained from the disk cache.
        case disk

        /// The image was obtained from the memory cache.
        case memory

        var possiblyDelayed: Bool {
            self != .memory
        }
    }
}

// MARK: - ImageRepresentable

public protocol ImageRepresentable {
    var imageSource: ImageSourceType { get }
    var bundle: Bundle? { get }
}

extension ImageRepresentable {
    public var bundle: Bundle? {
        nil
    }

    var cacheKey: String? {
        switch imageSource {
            case .uiImage:
                return nil
            case .url(let value):
                let bundlePrefix = bundle?.bundleIdentifier ?? ""
                return bundlePrefix + value
        }
    }
}

// MARK: - Conformance

extension UIImage: ImageRepresentable {
    public var imageSource: ImageSourceType {
        .uiImage(self)
    }
}

extension URL: ImageRepresentable {
    public var imageSource: ImageSourceType {
        .url(absoluteString)
    }
}

extension String: ImageRepresentable {
    public var imageSource: ImageSourceType {
        .url(self)
    }
}
