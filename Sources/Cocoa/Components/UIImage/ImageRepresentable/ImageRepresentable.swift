//
// ImageRepresentable.swift
//
// Copyright © 2015 Xcore
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
            return self != .memory
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
        return nil
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
        return .uiImage(self)
    }
}

extension URL: ImageRepresentable {
    public var imageSource: ImageSourceType {
        return .url(absoluteString)
    }
}

extension String: ImageRepresentable {
    public var imageSource: ImageSourceType {
        return .url(self)
    }
}
