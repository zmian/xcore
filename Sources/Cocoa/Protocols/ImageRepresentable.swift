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

public enum ImageSourceType  {
    case url(String)
    case uiImage
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
        return .uiImage
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
    ///   - alwaysAnimate:     An option to always animate setting the image. The default value is `false`.
    ///                        The image will only fade in when fetched from a remote url and not in memory cache.
    ///   - animationDuration: The total duration of the animation. If the specified value is negative or 0, the image is set without animation. The default value is `0.5`.
    ///   - callback:          A block to invoke when finished setting the image.
    public func setImage(_ image: ImageRepresentable?, alwaysAnimate: Bool = false, animationDuration: TimeInterval = .slow, callback: ((_ image: UIImage?) -> Void)? = nil) {
        guard let image = image else {
            self.image = nil
            callback?(nil)
            return
        }

        switch image.imageSource {
            case .url(let url):
                remoteOrLocalImage(url, in: image.bundle, alwaysAnimate: alwaysAnimate, animationDuration: animationDuration, callback: callback)
            case .uiImage:
                let duration = alwaysAnimate ? animationDuration : 0
                alpha = duration > 0 ? 0 : 1
                self.image = image as? UIImage
                UIView.animate(withDuration: duration) {
                    self.alpha = 1
                }
                callback?(self.image)
        }
    }

    /// Automatically detect and load the image from local or a remote url.
    ///
    /// - Parameters:
    ///   - image:             The image to display.
    ///   - defaultImage:      The fallback image to display if `image` can't be loaded.
    ///   - alwaysAnimate:     An option to always animate setting the image. The default value is `false`.
    ///                        The image will only fade in when fetched from a remote url and not in memory cache.
    ///   - animationDuration: The total duration of the animation. If the specified value is negative or 0, the image is set without animation. The default value is `0.5`.
    ///   - callback:          A block to invoke when finished setting the image.
    public func setImage(_ image: ImageRepresentable?, defaultImage: ImageRepresentable, alwaysAnimate: Bool = false, animationDuration: TimeInterval = .slow, callback: ((_ image: UIImage?) -> Void)? = nil) {
        guard let image = image else {
            setImage(defaultImage, alwaysAnimate: alwaysAnimate, animationDuration: animationDuration, callback: callback)
            return
        }

        self.image = nil
        setImage(image, alwaysAnimate: alwaysAnimate, animationDuration: animationDuration) { [weak self] image in
            guard let strongSelf = self else { return }
            if image == nil {
                strongSelf.setImage(defaultImage, alwaysAnimate: alwaysAnimate, animationDuration: animationDuration, callback: callback)
            } else {
                callback?(image)
            }
        }
    }
}
