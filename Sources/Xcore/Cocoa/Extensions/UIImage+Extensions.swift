//
// Xcore
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
}

// MARK: - Create Custom Shape Image

extension UIImage {
    public struct Shape {
        public let rect: CGRect
        fileprivate let draw: (Self, CGContext) -> Void

        public init(rect: CGRect, _ draw: @escaping (Self, CGContext) -> Void) {
            self.rect = rect
            self.draw = draw
        }

        public static var rectangle: Self {
            rectangle(.init(50))
        }

        public static func rectangle(_ size: CGSize) -> Self {
            .init(rect: .init(size)) { shape, context in
                context.fill(shape.rect)
            }
        }

        public static func ellipse(_ size: CGSize) -> Self {
            .init(rect: .init(size)) { shape, context in
                context.fillEllipse(in: shape.rect)
            }
        }
    }

    /// Creates an image from specified color and size and shape.
    ///
    /// - Parameters:
    ///   - color: The color used to create the image.
    ///   - shape: The type of shape to render. The default value is `.rectangle`.
    public convenience init(color: UIColor, shape: Shape = .rectangle) {
        let rect = shape.rect

        let image = UIGraphicsImageRenderer(bounds: rect).image { rendererContext in
            let context = rendererContext.cgContext
            context.setFillColor(color.cgColor)
            shape.draw(shape, context)
        }

        self.init(
            cgImage: image.cgImage!,
            scale: image.scale,
            orientation: image.imageOrientation
        )
    }
}

// MARK: - EncodingFormat

extension UIImage {
    public enum EncodingFormat {
        case png
        case jpeg(quality: Double)
    }

    /// Returns a data object that contains the specified image in given format.
    ///
    /// - Parameter format: The encoding format.
    public func data(using format: EncodingFormat) -> Data? {
        switch format {
            case .png:
                return pngData()
            case let .jpeg(quality):
                return jpegData(compressionQuality: quality)
        }
    }
}
