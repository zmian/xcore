//
// UIImage+Extensions.swift
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIImage {
    /// A convenience init identical to `UIImage:named` but does not cache images
    /// in memory. This is great for animations to quickly discard images after use.
    ///
    /// - Parameters:
    ///   - filename: The name of the file to construct.
    ///   - bundle: The bundle in which this file is located in. The default value is `.main`.
    public convenience init?(filename: String, in bundle: Bundle = .main) {
        let name = filename.deletingPathExtension
        let ext = filename.pathExtension.isEmpty ? "png" : filename.pathExtension

        guard let path = bundle.path(forResource: name, ofType: ext) else {
            return nil
        }

        self.init(contentsOfFile: path)
    }

    /// Creates an image from specified color and size.
    ///
    /// - Parameters:
    ///   - color: The color used to create the image.
    ///   - size: The size of the image. The default size is `50`.
    public convenience init(color: UIColor, size: CGSize = 50) {
        let rect = CGRect(size)

        let image = UIGraphicsImageRenderer(bounds: rect).image { rendererContext in
            let context = rendererContext.cgContext
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }

        self.init(cgImage: image.cgImage!)
    }
}
