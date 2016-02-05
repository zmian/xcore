//
// ImageTitleDisplayable.swift
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

public enum ImageSourceType { case URL, UIImage }

public protocol ImageRepresentable {
    var imageSourceType: ImageSourceType { get }
}

extension String: ImageRepresentable {
    public var imageSourceType: ImageSourceType { return .URL }
}

extension NSURL: ImageRepresentable {
    public var imageSourceType: ImageSourceType { return .URL }
}

extension UIImage: ImageRepresentable {
    public var imageSourceType: ImageSourceType { return .UIImage }
}

public protocol ImageTitleDisplayable {
    var title: String { get }
    var subtitle: String? { get }
    var image: ImageRepresentable { get }
}

public extension ImageTitleDisplayable {
    var subtitle: String? { return nil }

    func setImage(imageView: UIImageView?) {
        switch image.imageSourceType {
            case .URL:
                if let imageName = image as? String {
                    imageView?.remoteOrLocalImage(imageName)
                } else if let url = image as? NSURL {
                    imageView?.remoteOrLocalImage(url.absoluteString)
                }
            case .UIImage:
                imageView?.image = image as? UIImage
        }
    }
}
