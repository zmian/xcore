//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

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

// MARK: - Color

extension UIImage {
    /// Returns the dominant color of the image.
    ///
    /// For more information, [see this article][Credit] by Paul Hudson.
    ///
    /// [Credit]: https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
    public var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else {
            return nil
        }

        let extentVector = CIVector(
            x: inputImage.extent.origin.x,
            y: inputImage.extent.origin.y,
            z: inputImage.extent.size.width,
            w: inputImage.extent.size.height
        )

        guard
            let filter = CIFilter(name: "CIAreaAverage", parameters: [
                kCIInputImageKey: inputImage,
                kCIInputExtentKey: extentVector
            ]),
            let outputImage = filter.outputImage
        else {
            return nil
        }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])

        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: nil
        )

        return UIColor(
            .default,
            red: CGFloat(bitmap[0]) / 255,
            green: CGFloat(bitmap[1]) / 255,
            blue: CGFloat(bitmap[2]) / 255,
            alpha: CGFloat(bitmap[3]) / 255
        )
    }
}
