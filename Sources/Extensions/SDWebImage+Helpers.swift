//
// SDWebImage+Helpers.swift
//
// Copyright © 2014 Zeeshan Mian
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

public extension UIImageView {
    /// Automatically detect and load the image from local or a remote url.
    /// @requires SDWebImage
    public func remoteOrLocalImage(named: String, alwaysAnimate: Bool = false, callback: ((image: UIImage) -> Void)? = nil) {
        guard !named.isBlank else { image = nil; return }

        if let url = NSURL(string: named) where url.host != nil {
            self.sd_setImageWithURL(url) {[weak self] (image, _, cacheType, _) in
                if let weakSelf = self, image = image where (alwaysAnimate || cacheType != SDImageCacheType.Memory) {
                    callback?(image: image)
                    weakSelf.alpha = 0
                    UIView.animateWithDuration(0.5) {
                        weakSelf.alpha = 1
                    }
                }
            }
        } else {
            if alwaysAnimate {
                self.alpha = 0
                self.image = UIImage(named: named)
                UIView.animateWithDuration(0.5) {
                    self.alpha = 1
                }
                callback?(image: self.image!)
            } else {
                self.image = UIImage(named: named)
                callback?(image: self.image!)
            }
        }
    }
}
