//
// ImageRepresentable.swift
//
// Copyright © 2015 Zeeshan Mian
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

public enum ImageSourceType {
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

// MARK: ImageRepresentable

public protocol ImageRepresentable {
    var imageSource: ImageSourceType { get }
    var bundle: Bundle? { get }
}

extension ImageRepresentable {
    public var bundle: Bundle? {
        return nil
    }
}

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

extension UIImageView {
    /// Automatically detect and load the image from local or a remote url.
    ///
    /// - Parameters:
    ///   - image:             The image to display.
    ///   - transform:         An optional property to transform the image before setting the image.
    ///   - alwaysAnimate:     An option to always animate setting the image. The default value is `false`.
    ///                        The image will only fade in when fetched from a remote url and not in memory cache.
    ///   - animationDuration: The total duration of the animation. If the specified value is negative or 0, the image is set without animation. The default value is `0.5`.
    ///   - callback:          A block to invoke when finished setting the image.
    public func setImage(_ image: ImageRepresentable?, transform: ImageTransform? = nil, alwaysAnimate: Bool = false, animationDuration: TimeInterval = .slow, callback: ((_ image: UIImage?) -> Void)? = nil) {
        remoteOrLocalImage(image, transform: transform, alwaysAnimate: alwaysAnimate, animationDuration: animationDuration, callback: callback)
    }

    /// Automatically detect and load the image from local or a remote url.
    ///
    /// - Parameters:
    ///   - image:             The image to display.
    ///   - tintColor:         The tint color to apply to the image.
    ///   - alwaysAnimate:     An option to always animate setting the image. The default value is `false`.
    ///                        The image will only fade in when fetched from a remote url and not in memory cache.
    ///   - animationDuration: The total duration of the animation. If the specified value is negative or 0, the image is set without animation. The default value is `0.5`.
    ///   - callback:          A block to invoke when finished setting the image.
    public func setImage(_ image: ImageRepresentable?, tintColor: UIColor, alwaysAnimate: Bool = false, animationDuration: TimeInterval = .slow, callback: ((_ image: UIImage?) -> Void)? = nil) {
        setImage(
            image,
            transform: BlockImageTransform { (image, source) -> UIImage in
                return image.tintColor(tintColor)
            },
            alwaysAnimate: alwaysAnimate,
            animationDuration: animationDuration,
            callback: callback
        )
    }

    /// Automatically detect and load the image from local or a remote url.
    ///
    /// - Parameters:
    ///   - image:             The image to display.
    ///   - defaultImage:      The fallback image to display if `image` can't be loaded.
    ///   - transform:         An optional property to transform the image before setting the image.
    ///   - alwaysAnimate:     An option to always animate setting the image. The default value is `false`.
    ///                        The image will only fade in when fetched from a remote url and not in memory cache.
    ///   - animationDuration: The total duration of the animation. If the specified value is negative or 0, the image is set without animation. The default value is `0.5`.
    ///   - callback:          A block to invoke when finished setting the image.
    public func setImage(_ image: ImageRepresentable?, defaultImage: ImageRepresentable, transform: ImageTransform? = nil, alwaysAnimate: Bool = false, animationDuration: TimeInterval = .slow, callback: ((_ image: UIImage?) -> Void)? = nil) {
        guard let image = image else {
            setImage(defaultImage, transform: transform, alwaysAnimate: alwaysAnimate, animationDuration: animationDuration, callback: callback)
            return
        }

        self.image = nil
        setImage(image, transform: transform, alwaysAnimate: alwaysAnimate, animationDuration: animationDuration) { [weak self] image in
            guard let strongSelf = self else { return }
            if image == nil {
                strongSelf.setImage(defaultImage, transform: transform, alwaysAnimate: alwaysAnimate, animationDuration: animationDuration, callback: callback)
            } else {
                callback?(image)
            }
        }
    }

    /// Automatically detect and load the image from local or a remote url.
    ///
    /// - Parameters:
    ///   - image:             The image to display.
    ///   - defaultImage:      The fallback image to display if `image` can't be loaded.
    ///   - tintColor:         The tint color to apply to the image.
    ///   - alwaysAnimate:     An option to always animate setting the image. The default value is `false`.
    ///                        The image will only fade in when fetched from a remote url and not in memory cache.
    ///   - animationDuration: The total duration of the animation. If the specified value is negative or 0, the image is set without animation. The default value is `0.5`.
    ///   - callback:          A block to invoke when finished setting the image.
    public func setImage(_ image: ImageRepresentable?, defaultImage: ImageRepresentable, tintColor: UIColor, alwaysAnimate: Bool = false, animationDuration: TimeInterval = .slow, callback: ((_ image: UIImage?) -> Void)? = nil) {
        setImage(
            image,
            defaultImage: defaultImage,
            transform: BlockImageTransform { (image, source) -> UIImage in
                return image.tintColor(tintColor)
            },
            alwaysAnimate: alwaysAnimate,
            animationDuration: animationDuration,
            callback: callback
        )
    }
}
