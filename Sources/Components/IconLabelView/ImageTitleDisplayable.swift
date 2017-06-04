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

public enum ImageSourceType  { case url, uiImage }
public enum StringSourceType { case attributedString, string }

// MARK: ImageRepresentable

public protocol ImageRepresentable {
    var imageSourceType: ImageSourceType { get }
    var url: String? { get }
}

extension ImageRepresentable {
    public var url: String? { return nil }
}

extension String: ImageRepresentable {
    public var imageSourceType: ImageSourceType { return .url }
    public var url: String? { return self }
}

extension URL: ImageRepresentable {
    public var imageSourceType: ImageSourceType { return .url }
    public var url: String? { return self.absoluteString }
}

extension UIImage: ImageRepresentable {
    public var imageSourceType: ImageSourceType { return .uiImage }
}

extension UIImageView {
    public func setImage(_ image: ImageRepresentable?) {
        guard let image = image else {
            self.image = nil
            return
        }

        switch image.imageSourceType {
            case .url:
                if let url = image.url {
                    remoteOrLocalImage(url)
                }
            case .uiImage:
                self.image = image as? UIImage
        }
    }
}

// MARK: StringRepresentable

public protocol StringRepresentable: CustomStringConvertible {
    var stringSourceType: StringSourceType { get }
}

extension String: StringRepresentable {
    public var stringSourceType: StringSourceType { return .string }
    public var description: String { return self }
}

extension NSAttributedString: StringRepresentable {
    public var stringSourceType: StringSourceType { return .attributedString }
    open override var description: String { return string }
}

extension UILabel {
    public func setText(_ string: StringRepresentable?) {
        guard let string = string else {
            text = nil
            attributedText = nil
            return
        }

        switch string.stringSourceType {
            case .string:
                text = string as? String
            case .attributedString:
                attributedText = string as? NSAttributedString
        }
    }
}

// MARK: ImageTitleDisplayable

public protocol ImageTitleDisplayable {
    var title:    StringRepresentable  { get }
    var subtitle: StringRepresentable? { get }
    var image:    ImageRepresentable?  { get }
}

extension ImageTitleDisplayable {
    public var subtitle: StringRepresentable? { return nil }
}
